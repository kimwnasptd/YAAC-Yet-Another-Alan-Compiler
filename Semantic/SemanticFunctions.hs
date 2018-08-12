module SemanticFunctions (run_sem, ast_sem) where

import Tokens
import ASTTypes
import SymbolTableTypes
import qualified Data.HashMap.Strict as Map
import Control.Monad.State
import Control.Monad

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
writeLog :: String -> Semantic ()
writeLog line = modify $ \s -> s { logger = (logger s) ++ line ++ ['\n'] }

--------------------------------------------------------------------------------
-- Transofrmation Functions (Convrsions for argument types)
--------------------------------------------------------------------------------
createFunInfo :: Name -> [(Name,SymbolType,Bool,Bool)]  ->  SymbolType -> FunInfo
createFunInfo func_name fun_args fun_res = FunInfo {
      fn_name = func_name
    , result_type = fun_res
    , args = fun_args
    , forward_dec = False
}   -- we simply get all fields already computed and package them in a FunInfo Struct

createFType :: R_Type -> SymbolType  -- takes the token that corresponds to a functions return type
createFType R_Type_Proc =  ProcType
createFType ( R_Type_DT (D_Type TInt ) ) =  IntType
createFType ( R_Type_DT (D_Type TByte ) ) =  ByteType
-- createFType sth = error $ "Create f type was called with " ++ (show sth )

-- (Var Name, Var Type{int, byte}, Reference{T,F}, Table{T,F})
createArgType:: FPar_Def -> (Name,SymbolType, Bool, Bool )    -- takes a function arguement from the ast and returns its sem tuple
createArgType ( FPar_Def_Ref str (S_Type (D_Type TInt)) )      = (str, IntType , True, False)
createArgType ( FPar_Def_Ref str (S_Type (D_Type TByte)) )     = (str, ByteType, True, False)
createArgType ( FPar_Def_Ref str (Table_Type (D_Type TInt)) )  = (str, TableIntType , True, True)
createArgType ( FPar_Def_Ref str (Table_Type (D_Type TByte)))  = (str, TableByteType, True, True)
createArgType ( FPar_Def_NR  str (S_Type (D_Type TInt)) )      = (str, IntType , False, False)
createArgType ( FPar_Def_NR  str (S_Type (D_Type TByte)) )     = (str, ByteType, False, False)
createArgType ( FPar_Def_NR  str (Table_Type (D_Type TInt)) )  = (str, TableIntType , False, True)
createArgType ( FPar_Def_NR  str (Table_Type (D_Type TByte)) ) = (str, TableByteType, False, True)

createVar_from_Def :: Var_Def -> VarInfo
createVar_from_Def ( VDef str (D_Type TInt) )         = createVarInfo str IntType  0 Nothing False
createVar_from_Def ( VDef str (D_Type TByte) )        = createVarInfo str ByteType 0 Nothing False
createVar_from_Def ( VDef_T str (D_Type TInt) dim  )  = createVarInfo str TableIntType  0 (Just dim) False
createVar_from_Def ( VDef_T str (D_Type TByte) dim )  = createVarInfo str TableByteType 0 (Just dim) False
-- Whenever we create a variable from a Var_Def, it's always NOT by reference
-- If it's a table, we know a priori its size, so we add it
-- Else, we add Nothing to the dimension

-- NOTE: When we are inside a function, we treat this functions arguments as normal parameters,
-- so we keep a var_info type for all of them
createVar_from_Arg :: FPar_Def -> VarInfo
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

createVarInfo:: Name -> SymbolType -> Int ->  Maybe Int -> Bool -> VarInfo
createVarInfo  nm vt idv dim byref =  VarInfo {
      var_name = nm
    , var_type = vt
    , id_num = idv
    , dimension = dim
    , byreference = byref
}

--------------------------------------------------------------------------------
-- Get Type of Expr
--------------------------------------------------------------------------------
-- Takes an expression and checks whether it's a valid left value
checkRef :: Expr -> Bool
checkRef (Expr_Lval sth ) = True
checkRef _ = False

-- Takes a list of actual types of a fuction, and returns
-- a list of tuples of (actual type,whether it's  left_value )
get_expr_types::[Expr] -> Semantic [(SymbolType, Bool)]
get_expr_types exprs = forM exprs $ \expr -> do
    act_type <- getExprType expr
    return (act_type, checkRef expr)

-- takes the name of a function, and returns a list
-- of (arg type, by reference ) tuple,  in the proper order
get_fnargs_types:: String -> Semantic [(SymbolType, Bool)]
get_fnargs_types fn_name = do
    F fn_info <- checkSymbol fn_name -- lookup the function on the symbol table
    return $ map get_vartype (args fn_info)
        where get_vartype (a,b,c,d) = (b,c)

-- Helper function for repetetive stuff
type_check :: Expr -> Expr -> String -> Semantic SymbolType
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
getLvalType :: L_Value -> Semantic SymbolType
getLvalType (LV_Lit str) = return TableByteType
getLvalType (LV_Var var) = do
    V var_info <- checkSymbol var
    return $ var_type var_info
getLvalType (LV_Tbl var dim) = do
    dim_type <- getExprType dim
    V table_info <- checkSymbol var
    case (dim_type , var_type table_info ) of
        (IntType, TableIntType )  -> return IntType
        (IntType, TableByteType)  -> return ByteType
        ( _ , _)               -> error  $ "Something sketchy is going on with the " ++ var ++ " table!"

-- Expressions
getExprType :: Expr -> Semantic SymbolType
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
    F foo_info <- checkSymbol fname
    if ( formal_types ==  actual_types ) then return $ result_type foo_info
    else  error $ "arg missmatch in function " ++ fname
-- Simple enough: If the type of all the actual paramters a function
-- was called with match respectively with the type of the formal
-- types, then the result type is the one declared by the fuction
-- We also pay special attention to the fact that for every actual paramter that was
-- declared by reference, the value passed as argument is a left value

--------------------------------------------------------------------------------
-- Semantic Analysis of Conditions
--------------------------------------------------------------------------------
check_conditions :: Expr -> Expr -> Semantic ()
check_conditions expr1 expr2 = do
    type1 <- getExprType expr1  -- check that the 2 operands being
    type2 <- getExprType expr2  -- compared have  valid types for
    case (type1, type2 ) of    -- an equality check
        (IntType, IntType)     -> return ()
        (ByteType, ByteType)   -> return ()
        _                  -> error $ "Wrong condition types"

semCond :: Cond -> Semantic ()
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
checkGlobalVar :: Name -> Semantic (Maybe Symbol)
checkGlobalVar var = do
    symtable <- gets symbolTable
    main_scp <- gets main
    case var `Map.lookup` symtable of
        Nothing -> error $ error_msg
        Just [] -> error $ error_msg
        Just scps -> do
            let fst_scp = scps !! 0
            case (scp_name fst_scp) == main_scp of
                True  -> return $ var `Map.lookup` (symbols fst_scp)
                False -> return $ Nothing
    where
        error_msg = "Symbol " ++ var ++ " is not defined as global!"

checkSymbol:: Name -> Semantic Symbol
checkSymbol var = do
    curr_scp <- gets currentScope
    case var `Map.lookup` (symbols curr_scp) of
        Just info -> return info  -- the variable is in the current scope
        Nothing   ->  do   -- the variable isn't defined in the current
            check <- checkGlobalVar var
            case check of
                Nothing -> error error_msg
                Just info -> return info
    where
        error_msg = "Symbol " ++ var ++ " is not defined!"

addSymbol :: Name -> Symbol -> Semantic ()
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

-- Takes the necessary fields from a function defintion, and adds a fun_info struct to the current scope
addFunc :: Name ->  FPar_List  ->  R_Type -> Semantic ()
addFunc name args_lst f_type = do
    scpnm <- getScopeName
    writeLog $ "add function was called from scope " ++ scpnm ++ " for function " ++ name
    let our_ret = createFType f_type   -- we format all of the function stuff properly
        fun_args = map createArgType args_lst
        fn_info = createFunInfo name fun_args our_ret
    addSymbol (fn_name fn_info) (F fn_info)

addVar :: Var_Def -> Semantic ()    -- takes a VARIABLE DEFINITION , and adds the proper things, to the proper scopes
addVar vdef = do
    scpnm <- getScopeName
    let var_info = createVar_from_Def vdef    -- create the new VarInfo filed to be inserted in the scope
    addSymbol (var_name var_info) (V var_info)
    writeLog $ "Adding variable " ++ (var_name var_info) ++ " to the scope " ++ scpnm

-- Put the Function args to the function's scope, as variables variables
addFArgs :: FPar_List -> Semantic ()
addFArgs (arg:args) = do
    let param = createVar_from_Arg arg
    writeLog $ "Adding Func Param " ++ (var_name param) ++ " to the scope"
    addSymbol (var_name param) (V param)
    addFArgs args
addFArgs [] = return ()

addLDef :: Local_Def -> Semantic ()
addLDef (Loc_Def_Fun fun) = semFuncDef fun
addLDef (Loc_Def_Var var) = addVar var

-- Check it at night. -> Looks fine to me.
addLDefLst :: [Local_Def] -> Semantic  ()
addLDefLst defs = mapM addLDef defs >> return ()

--------------------------------------------------------------------------------
-- Scope Functions
--------------------------------------------------------------------------------
getScopeName :: Semantic String
getScopeName = gets currentScope >>= return . scp_name

-- Opens a new scope, we just edit
-- the currentScope in our State
openScope :: String -> Semantic ()
openScope name = do
    s <- get
    writeLog $ "The keys of the scope we were in are: " ++ (show $ Map.keys $ symbols $ currentScope s)
    writeLog $ "Opening a new Scope for " ++ name
    s <- get
    let curr_scope = currentScope s
        curr_name = scp_name curr_scope
    case curr_name of
        "" -> put s { currentScope = emptyScope { scp_name = name } }  -- if we are the INITIAL scope, we just change the scope's name
        _  -> put s { currentScope = emptyScope { -- But as a currentScope we put an empty one
                        parent_scope = (Just $ curr_scope)  -- And change its parent
                      , scp_name = name
                      }
                    }

-- Revert the currentScope to the parent one
-- and remove the Latest entries of the vars
-- in this scope from our Symbol Table
closeScope :: Semantic ()
closeScope = do
    scpnm <- getScopeName
    writeLog $ "Closing the Scope for " ++ scpnm
    s <- get
    let symbol_names = Map.keys $ symbols (currentScope s)
    removeScopeSymbols symbol_names scpnm
    s <- get
    -- Make current Scope the Parent one
    case parent_scope (currentScope s) of
        Nothing  -> return ()
        Just scp -> put s { currentScope = scp }

-- Removes the variables from all the appropriate scopes
cleanup :: SymbolTable -> [Name] -> SymbolTable
cleanup symb_t [] = symb_t
cleanup symb_t (var:vars) =
    case Map.lookup var symb_t of
        Nothing         -> cleanup symb_t vars
        Just []         -> cleanup symb_t vars
        Just (scp:scps) -> cleanup ( Map.insert var scps symb_t ) vars

removeScopeSymbols :: [Name] -> Name ->  Semantic ()
removeScopeSymbols [] nm  = do
    writeLog $ "cleaning up the (EMTPY) symbol table for scope name "  ++ nm
removeScopeSymbols symbol_lst nm = do
    writeLog $ "cleaning up the symbol table for scope name "  ++ nm
    s <- get
    let cleanSymbolTable = cleanup (symbolTable s) symbol_lst  -- clean it up
    put s { symbolTable = cleanSymbolTable }  -- put the clean symbol table back in the state.

--------------------------------------------------------------------------------
-- Semantic Analysis of statements
--------------------------------------------------------------------------------
semStmt :: Stmt -> Semantic ()
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
        (IntType, IntType)    ->  return ()
        (ByteType, ByteType)  -> return ()
        _                 -> error $ err

semStmt (Stmt_Ret_Expr expr) = do
    expr_type <- getExprType expr -- get the type of the expression
    fn_name <- getScopeName       -- current function = current scope
    info <- checkSymbol fn_name
    case info of    -- check if the return type is actually the same as the one declared in the fuction defintion
        V var_info -> error $ "Can't return " ++ (show expr)
        F fun_info -> if ( result_type fun_info ==  expr_type ) then return ()
            else error $ "Can't return " ++ (show expr_type) ++ " from func " ++ fn_name

-- Same logic as above, the difference being that now
-- the return type of the expression is proc by default
semStmt Stmt_Ret = do
    fn_name <- getScopeName       -- current function = current scope
    info <- checkSymbol fn_name
    case info of    -- check if the return type is actually the same as the one declared in the fuction defintion
        V var_info -> error $ "Can't return from a variable."
        F fun_info -> case result_type fun_info of
            ProcType -> return ()
            _        -> error $ "Must return a value from a non void function"

semStmtList :: Comp_Stmt -> Semantic ()
semStmtList (C_Stmt stmts) = mapM semStmt stmts >> return ()

--------------------------------------------------------------------------------
-- Top level Semantic Analysis
--------------------------------------------------------------------------------
initMain :: Func_Def -> Semantic ()
initMain (F_Def name _ _ _ _) = modify $ \s -> s { main = name }

semFuncDef :: Func_Def -> Semantic ()
semFuncDef (F_Def name args_lst f_type ldef_list cmp_stmt) = do
    addFunc name args_lst f_type      -- > we add the function to our CURRENT scope, so the one who defined the function can then call her.
    openScope name                    -- > every function creates a new scope
    addFArgs args_lst                 -- > add parameters to symtable
    addFunc name args_lst f_type      -- > NOTE: add the function to the inside scope as well ?
    addLDefLst ldef_list              -- > add the local definitions of that function, this is where the recursion happens
    semStmtList cmp_stmt              -- > do the Semantic analysis of the function body
    closeScope                        -- > close the function' s scope

ast_sem :: Program -> Semantic String
ast_sem (Prog main) = do
    initMain main
    semFuncDef main
    gets logger >>= return

run_sem :: Program -> String
run_sem alan = evalState (ast_sem alan) initialSemState
