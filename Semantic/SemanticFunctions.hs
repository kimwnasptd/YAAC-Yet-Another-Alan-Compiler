module SemanticFunctions where

import Tokens
import ASTTypes
import SymbolTableTypes
import qualified Data.Map as Map
import Control.Monad.State
import Control.Monad

import LLVM.AST
import LLVM.AST.Type
import qualified LLVM.AST.Type as TP
import qualified LLVM.AST as AST

import CodegenUtilities

-- INDEX:
-- 1. Helper Functions          13
-- 2. Transofrmation Functions  21
-- 3. Get Type of Expr          83
-- 4. Semantic Analysis of Conditions   167
-- 5. Symbol Table Functions    199
-- 6. Scope Functions           266
-- 7. Semantic Analysis of statements   323
-- 8. Top level Semantic Analysis       363

--------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------
-- Write a Log Message
writeLog :: String -> Codegen ()
writeLog line = modify $ \s -> s { logger = (logger s) ++ line ++ ['\n'] }

-- Get the nesting depth of a function (used for main to get display's size)
max_nesting :: Local_Def -> Int
max_nesting (Loc_Def_Fun (F_Def _ _ _ ldefs _)) = (maximum $ map max_nesting ldefs) + 1
    where maximum (x:xs) = max x (maximum xs)
          maximum []     = 0
max_nesting _ = 0

--------------------------------------------------------------------------------
-- Transofrmation Functions (Convrsions for argument types)
--------------------------------------------------------------------------------

createFunInfo :: SymbolName -> [(SymbolName,SymbolType,Bool,Bool)] -> SymbolType -> FunInfo
createFunInfo func_name fun_args fun_res = FunInfo {
      fn_name = func_name
    , result_type = fun_res
    , fun_operand = Nothing
    , fn_args = fun_args
    , varargs = False
}   -- we simply get all fields already computed and package them in a FunInfo Struct

createVarInfo:: SymbolName -> SymbolType -> Int ->  Maybe Int -> Bool -> Codegen VarInfo
createVarInfo nm vt idv dim byref =  do
    return VarInfo {
      var_name = nm
    , var_type = vt
    , var_idx = 0
    , var_operand = Nothing
    , id_num = idv
    , dimension = dim
    , byreference = byref
}

getFunType :: R_Type -> SymbolType  -- takes the token that corresponds to a functions return type
getFunType R_Type_Proc =  ProcType
getFunType ( R_Type_DT (D_Type TInt ) ) =  IntType
getFunType ( R_Type_DT (D_Type TByte ) ) =  ByteType
-- getFunType sth = error $ "Create f type was called with " ++ (show sth )

-- (Var SymbolName, Var Type{int, byte}, Reference{T,F}, Table{T,F})
createArgType:: FPar_Def -> (SymbolName,SymbolType, Bool, Bool )
createArgType ( FPar_Def_Ref str (S_Type (D_Type TInt)) )      = (str, IntType , True, False)
createArgType ( FPar_Def_Ref str (S_Type (D_Type TByte)) )     = (str, ByteType, True, False)
createArgType ( FPar_Def_Ref str (Table_Type (D_Type TInt)) )  = (str, TableIntType , True, True)
createArgType ( FPar_Def_Ref str (Table_Type (D_Type TByte)))  = (str, TableByteType, True, True)
createArgType ( FPar_Def_NR  str (S_Type (D_Type TInt)) )      = (str, IntType , False, False)
createArgType ( FPar_Def_NR  str (S_Type (D_Type TByte)) )     = (str, ByteType, False, False)
createArgType ( FPar_Def_NR  str (Table_Type (D_Type TInt)) )  = error $ "tables should be passed by reference"
createArgType ( FPar_Def_NR  str (Table_Type (D_Type TByte)) ) = error $ "tables should be passed by reference"

createVar_from_Def :: Var_Def -> Codegen VarInfo
createVar_from_Def ( VDef str (D_Type TInt) )         = createVarInfo str IntType  0 Nothing False
createVar_from_Def ( VDef str (D_Type TByte) )        = createVarInfo str ByteType 0 Nothing False
createVar_from_Def ( VDef_T str (D_Type TInt) dim  )  = createVarInfo str TableIntType  0 (Just dim) False
createVar_from_Def ( VDef_T str (D_Type TByte) dim )  = createVarInfo str TableByteType 0 (Just dim) False
-- Whenever we create a variable from a Var_Def, it's always NOT by reference
-- If it's a table, we know a priori its size, so we add it
-- Else, we add Nothing to the dimension

-- NOTE: When we are inside a function, we treat this functions arguments as normal parameters,
-- so we keep a var_info type for all of them
createVar_from_Arg :: FPar_Def -> Codegen VarInfo
createVar_from_Arg ( FPar_Def_Ref str (S_Type (D_Type TInt)) )      = createVarInfo str IntType 0 Nothing True
createVar_from_Arg ( FPar_Def_Ref str (S_Type (D_Type TByte)) )     = createVarInfo str ByteType 0 Nothing True
createVar_from_Arg ( FPar_Def_Ref str (Table_Type (D_Type TInt)) )  = createVarInfo str TableIntType 0 (Just 0) True
createVar_from_Arg ( FPar_Def_Ref str (Table_Type (D_Type TByte)))  = createVarInfo str TableByteType 0 (Just 0) True
createVar_from_Arg ( FPar_Def_NR  str (S_Type (D_Type TInt)) )      = createVarInfo str IntType 0 Nothing False
createVar_from_Arg ( FPar_Def_NR  str (S_Type (D_Type TByte)) )     = createVarInfo str ByteType 0 Nothing False
createVar_from_Arg ( FPar_Def_NR  str (Table_Type (D_Type TInt)) )  = createVarInfo str TableIntType 0 (Just 0) False
createVar_from_Arg ( FPar_Def_NR  str (Table_Type (D_Type TByte)) ) = createVarInfo str TableByteType 0 (Just 0 ) False
-- NOTE: A VarInfo table having as dimensions JUST 0 has special meaning:
-- it means that we are indeed talking about a table, but we don't know its size yet

--------------------------------------------------------------------------------
-- Get Type of Expr
--------------------------------------------------------------------------------
-- Takes an expression and checks whether it's a valid left value
checkRef :: Expr -> Bool
checkRef (Expr_Lval sth ) = True
checkRef _ = False

-- Takes a list of actual types of a fuction, and returns
-- a list of tuples of (actual type,whether it's  left_value )
get_expr_types::[Expr] -> Codegen [(SymbolType, Bool)]
get_expr_types exprs = forM exprs $ \expr -> do
    act_type <- getExprType expr
    return (act_type, checkRef expr)

-- takes the name of a function, and returns a list
-- of (arg type, by reference ) tuple,  in the proper order
get_fnargs_types:: String -> Codegen [(SymbolType, Bool)]
get_fnargs_types fn_name = do
    F fn_info <- getSymbol fn_name -- lookup the function on the symbol table
    return $ map get_vartype (fn_args fn_info)
        where get_vartype (a,b,c,d) = (b,c)

-- Helper function for repetetive stuff
type_check :: Expr -> Expr -> String -> Codegen SymbolType
type_check left right fn = do
    left_type  <- getExprType left
    right_type <- getExprType right
    case (left_type, right_type) of
        (IntType, IntType) -> return IntType
        (ByteType, ByteType) -> return IntType
        _ -> error $ "Can't " ++ fn ++ " a " ++ (show left_type) ++ " with a " ++ (show right_type)

-- Left Values
-- in case we encounter something that looks like a variable, we do simple stuff:
-- we just check our symbol table, and return its type, regarldess of what
-- that type might be
getLvalType :: L_Value -> Codegen SymbolType
getLvalType (LV_Lit str) = return TableByteType
getLvalType (LV_Var var) = do
    V var_info <- getSymbol var
    return $ var_type var_info
getLvalType (LV_Tbl var ind) = do
    ind_type <- getExprType ind
    V table_info <- getSymbol var
    case (ind_type , var_type table_info, byreference table_info) of
        (IntType, TableIntType, False)  -> return IntType
        (IntType, TableByteType, False) -> return ByteType
        (IntType, IntType, True)        -> return IntType
        (IntType, ByteType, True)       -> return ByteType
        (a, b, c)                       -> error  $ var ++ ": "++(show b)++" index: "++(show a)++" reference: "++(show c)

-- Expressions
getExprType :: Expr -> Codegen SymbolType
getExprType (Expr_Int num ) = return IntType
getExprType (Expr_Char _)= return ByteType
getExprType (Expr_Brack expr) = getExprType expr
getExprType (Expr_Add left right ) = type_check left right "add"
getExprType (Expr_Sub left right ) = type_check left right "substract"
getExprType (Expr_Tms left right ) = type_check left right "multiply"
getExprType (Expr_Mod left right ) = type_check left right "mod"
getExprType (Expr_Div left right ) = type_check left right "divide"
getExprType (Expr_Lval lval) = getLvalType lval
getExprType (Expr_Pos num ) = do
    num  <- getExprType num
    case num of
        IntType -> return IntType
        _     -> error $ "Type " ++ (show num)  ++  " has no positive (only ints do)."
getExprType (Expr_Neg num ) = do
    num  <- getExprType num
    case num of
        IntType -> return IntType
        _     -> error $ "Type " ++ (show num)  ++  " has no negative (only ints do)."
getExprType (Expr_Fcall (Func_Call fname fargs) ) = do
    actual_types <- get_expr_types fargs      -- [(SymbolType,Reference)]
    formal_types <- get_fnargs_types fname    -- [(SymbolType, Reference)]
    F foo_info <- getSymbol fname
    if ( agree actual_types formal_types ) then return $ result_type foo_info
    else  error $ "arg missmatch in function " ++ fname

-- Simple enough: If the type of all the actual paramters a function
-- was called with match respectively with the type of the formal
-- types, then the result type is the one declared by the fuction
-- We also pay special attention to the fact that for every actual paramter that was
-- declared by reference, the value passed as argument is a left value


agree :: [(SymbolType, Bool)] -> [(SymbolType, Bool)] -> Bool
agree [] [] = True
agree ( (type1, ref1 ):rest1 ) ( (type2, ref2):rest2 ) = case (ref1,ref2) of
    (True,  _ ) -> if (type1 == type2 ) then agree rest1 rest2 else False
    (False, False ) -> if (type1 == type2 ) then agree rest1 rest2 else False
    ( False, True ) -> False
agree _ _ = False
-- Takes the ACTUAL and FORMAL paramters of a function and checkes whether
-- their references are compatitable.
-- If they are, it also checks that their types are compatit


--------------------------------------------------------------------------------
-- Semantic Analysis of Conditions
--------------------------------------------------------------------------------
check_conditions :: Expr -> Expr -> Codegen ()
check_conditions expr1 expr2 = do
    type1 <- getExprType expr1  -- check that the 2 operands being
    type2 <- getExprType expr2  -- compared have  valid types for
    case (type1, type2 ) of    -- an equality check
        (IntType, IntType)     -> return ()
        (ByteType, ByteType)   -> return ()
        _                  -> error $ "Wrong condition types"

semCond :: Cond -> Codegen ()
semCond Cond_True = return ()
semCond Cond_False = return ()
semCond (Cond_Br cond) = semCond cond
semCond (Cond_Bang cond) = semCond cond
semCond (Cond_Eq expr1 expr2) = check_conditions expr1 expr2
semCond (Cond_Neq expr1 expr2) = check_conditions expr1 expr2
semCond (Cond_L expr1 expr2) = check_conditions expr1 expr2
semCond (Cond_G expr1 expr2) = check_conditions expr1 expr2
semCond (Cond_LE expr1 expr2) = check_conditions expr1 expr2
semCond (Cond_GE expr1 expr2) = check_conditions expr1 expr2
semCond (Cond_And c1 c2 ) = semCond c1 >> semCond c2
semCond (Cond_Or c1 c2 ) = semCond c1 >> semCond c2

--------------------------------------------------------------------------------
-- Symbol Table Functions
--------------------------------------------------------------------------------
-- Checks if var is defined in main
checkSymbolTable :: SymbolName -> Codegen Scope
checkSymbolTable sym = do
    symtab <- gets symbolTable
    case sym `Map.lookup` symtab of
        Nothing -> error error_msg -- the variable is nowhere to be found
        Just [] -> error error_msg -- the variable is nowhere to be found (it was previously declared, but deleted )
        Just (scp:scps) -> return scp
    where error_msg = "Symbol " ++ sym ++ " is not defined!"

getSymbol:: SymbolName -> Codegen Symbol
getSymbol sym = do
    curr_scp <- gets currentScope
    case sym `Map.lookup` (symbols curr_scp) of
        Just info -> return info  -- the variable is in the current scope
        Nothing   -> do
            scp <- checkSymbolTable sym
            case sym `Map.lookup` (symbols scp) of
                Just info -> return info
                Nothing   -> error error_msg
    where error_msg = "Symbol " ++ sym ++ " is not defined!"

getSymbol_enhanced :: SymbolName -> Codegen (Either Symbol (Scope, Symbol) )  -- Nesting Level, Offset
getSymbol_enhanced sym = do
    curr_scp <- gets currentScope
    case sym `Map.lookup` (symbols curr_scp) of
        Just info -> return $ Left info  -- the variable is in the current scope
        Nothing   -> do
            scp <- checkSymbolTable sym
            case sym `Map.lookup` (symbols scp ) of
                Just info -> return $ Right (scp, info)
                Nothing -> error error_msg
        where error_msg = "Symbol " ++ sym ++ " is not defined!"

addSymbol :: SymbolName -> Symbol -> Codegen ()
addSymbol symbol_name symbol_info = do
    s <- get
    let currScope = currentScope s                -- get the current scope
        currSymbols = symbols currScope           -- get the current symbol table, from the current scope
        symb_t = symbolTable s               -- get our backend implementation of nested scopes
        newSymbols = Map.insert symbol_name symbol_info currSymbols -- we update our symbol table
        newScope = currScope { symbols = newSymbols }   -- we updated our scope

    put s { symbolTable  = Map.insertWith (++) symbol_name [newScope] symb_t
          , currentScope = newScope
    }

--------------------------------------------------------------------------------
-- Scope Functions
--------------------------------------------------------------------------------
getScopeName :: Codegen String
getScopeName = gets currentScope >>= return . scp_name

-- Opens a new scope, we just edit
-- the currentScope in our State
openScope :: String -> Codegen ()
openScope name = do
    s <- get
    let curr_scope = currentScope s
        curr_name = scp_name curr_scope
        prev_nest = nesting curr_scope
    case curr_name of
        "" -> put s { currentScope = (currentScope s) { scp_name = name } }  -- if we are the INITIAL scope, we just change the scope's name
        _  -> put s { currentScope = emptyScope { -- But as a currentScope we put an empty one
                        parent_scope = (Just $ curr_scope)  -- And change its parent
                      , scp_name = name
                      , nesting = ( prev_nest + 1 )
                      }
                    }

-- Revert the currentScope to the parent one
-- and remove the Latest entries of the vars
-- in this scope from our Symbol Table
closeScope :: Codegen ()
closeScope = do
    scpnm <- getScopeName
    writeLog $ "Closing the Scope for " ++ scpnm
    s <- get
    F fn <- getSymbol scpnm
    let tp = type_to_ast $ result_type fn
        nm = scpnm
        args = toSig $ fn_args fn
        bls = createBlocks $ currentScope s
    define $ globalFun tp nm args bls
    let symbol_names = Map.keys $ symbols (currentScope s)
    removeScopeSymbols symbol_names scpnm
    s <- get
    -- Make current Scope the Parent one
    case parent_scope (currentScope s) of
        Nothing  -> return ()
        Just scp -> put s { currentScope = scp }

-- Removes the variables from all the appropriate scopes
cleanup_symbols :: SymbolTable -> [SymbolName] -> SymbolTable
cleanup_symbols symb_t [] = symb_t
cleanup_symbols symb_t (var:vars) =
    case Map.lookup var symb_t of
        Nothing         -> cleanup_symbols symb_t vars
        Just []         -> cleanup_symbols symb_t vars
        Just (scp:scps) -> cleanup_symbols ( Map.insert var scps symb_t ) vars

removeScopeSymbols :: [SymbolName] -> SymbolName ->  Codegen ()
removeScopeSymbols [] nm  = do
    writeLog $ "cleaning up the (EMTPY) symbol table for scope name "  ++ nm
removeScopeSymbols symbol_lst nm = do
    writeLog $ "cleaning up the symbol table for scope name "  ++ nm
    s <- get
    let cleanSymbolTable = cleanup_symbols (symbolTable s) symbol_lst  -- clean it up
    put s { symbolTable = cleanSymbolTable }  -- put the clean symbol table back in the state.

--------------------------------------------------------------------------------
-- Semantic Analysis of statements
--------------------------------------------------------------------------------
semStmt :: Stmt -> Codegen ()
semStmt Stmt_Semi = return ()
semStmt (Stmt_Cmp cmp_stmt) = semStmtList cmp_stmt
semStmt (Stmt_If cond stmt) = semCond cond >> semStmt stmt
semStmt (Stmt_IFE cond stmt1 stmt2 ) = semCond cond >> semStmt stmt1 >> semStmt stmt2
semStmt (Stmt_Wh cond stmt) = semCond cond >> semStmt stmt
semStmt (Stmt_Eq lval expr) = do
    lval_type <- getLvalType lval
    expr_type <- getExprType expr
    let err = "Can't assign type  " ++ (show expr_type) ++ " to type " ++ (show lval_type)
    case (lval_type, expr_type) of
        (IntType, IntType)    -> return ()
        (ByteType, ByteType)  -> return ()
        _                 -> error $ err

semStmt (Stmt_Ret_Expr expr) = do
    expr_type <- getExprType expr -- get the type of the expression
    fn_name <- getScopeName       -- current function = current scope
    info <- getSymbol fn_name
    case info of    -- check if the return type is actually the same as the one declared in the fuction defintion
        V var_info -> error $ "Can't return " ++ (show expr)
        F fun_info -> if ( result_type fun_info ==  expr_type ) then return ()
            else error $ "Can't return " ++ (show expr_type) ++ " from func " ++ fn_name

-- Same logic as above, the difference being that now
-- the return type of the expression is proc by default
semStmt Stmt_Ret = do
    fn_name <- getScopeName       -- current function = current scope
    info <- getSymbol fn_name
    case info of    -- check if the return type is actually the same as the one declared in the fuction defintion
        V var_info -> error $ "Can't return from a variable."
        F fun_info -> case result_type fun_info of
            ProcType -> return ()
            _        -> error $ "Must return a value from a non void function"

semStmt (Stmt_FCall (Func_Call fname fargs)) = do
    actual_types <- get_expr_types fargs      -- [(SymbolType,Reference)]
    formal_types <- get_fnargs_types fname    -- [(SymbolType, Reference)]
    F foo_info <- getSymbol fname
    if ( agree actual_types formal_types ) then return $ ()
    else  error $ "arg missmatch in function " ++ fname ++ ": " ++ (show actual_types) ++ " " ++ (show formal_types)

semStmtList :: Comp_Stmt -> Codegen ()
semStmtList (C_Stmt stmts) = mapM semStmt stmts >> return ()
