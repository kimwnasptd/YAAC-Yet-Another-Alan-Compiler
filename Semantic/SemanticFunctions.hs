module SemanticFunctions (run_sem, ast_sem) where

import Tokens
import ASTTypes
import SymbolTableTypes
import qualified Data.HashMap.Strict as Map
import Control.Monad.State
import Control.Monad

-- ------------------------------------------------------- --
-- ----------------------Helper Functions----------------- --

-- Write a Log Message
writeLog :: String -> P ()
writeLog line = do
    s <- get
    put s { logger = (logger s) ++ line ++ ['\n'] }
    return ()

getScopeName :: P String
getScopeName = do
    s <- get
    return (scp_name $ currentScope s)


-- Looks up for a definition of a name in all scopes, and returs its defintion,
-- the name of the scope it was found in, and whether that was the current scope or not
checkSymbol:: Name -> P ( Maybe G_Info )
checkSymbol var_name = do
    s <- get
    let curr_scope = currentScope s
    case var_name `Map.lookup` (symbols curr_scope) of
        Just info -> return $ Just info  -- the variable is in the current scope
        Nothing   ->  do   -- the variable isn't defined in the current scope
            case var_name `Map.lookup` (symbolTable s) of
                Nothing -> return Nothing -- the variable is nowhere to be found
                Just [] -> return Nothing -- the variable is nowhere to be found (it was previously declared, but deleted )
                Just (scp:scps) -> case var_name `Map.lookup` (symbols scp) of
                    Just info -> return ( Just info )
                    Nothing   -> error $ "go home, you're drunk " ++ var_name       -- NOTE: I think this should throw an error
                    -- Nothing   -> return Nothing       -- Original

-- To save ourselfes writing "case" again and again
checkSymbolError :: Name -> P G_Info
checkSymbolError symbol = do
    symbol_check <- checkSymbol symbol
    case symbol_check of
        Nothing     -> error $ "Symbol " ++ symbol ++ " is not defined!"
        Just def    -> return def
-- ------------------------------------------------------- --
-- ----------------------Scope Functions------------------ --

-- Opens a new scope, we just edit
-- the currentScope in our State
openScope :: String -> P ()
openScope name = do
    s <- get
    writeLog $ "The keys of the scope we were in are: " ++ (show $ Map.keys $ symbols $ currentScope s)
    writeLog $ "Opening a new Scope for " ++ name
    s <- get
    let
        curr_scope = currentScope s
        curr_name = scp_name curr_scope
    case curr_name of
        "" -> put s { currentScope = emptyScope { scp_name = name } }  -- if we are the INITIAL scope, we just change the scope's name
        _  -> put s {   -- Put as a State the current one
                      currentScope = emptyScope { -- But as a currentScope we put an empty one
                      parent_scope = (Just $ curr_scope)  -- And change its parent
                      , scp_name = name
                      }
                    }

-- Revert the currentScope to the parent one
-- and remove the Latest entries of the vars
-- in this scope from our Symbol Table
closeScope :: P ()
closeScope = do
    scpnm <- getScopeName
    writeLog $ "Closing the Scope for " ++ scpnm
    s <- get
    -- NOTE: If you are using more than one in the same function, chances
    -- are people (redditors at least ) will make fun of you.
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
        -- Just pop the last scope from the list
        -- NOTE: You have Ermis' seal of approval here. Well done sir.

removeScopeSymbols :: [Name] -> Name ->  P ()
removeScopeSymbols [] nm  = do
    writeLog $ "cleaning up the (EMTPY) symbol table for scope name "  ++ nm
removeScopeSymbols symbol_lst nm = do
    writeLog $ "cleaning up the symbol table for scope name "  ++ nm
    s <- get
    let cleanSymbolTable = cleanup (symbolTable s) symbol_lst  -- clean it up
    put s { symbolTable = cleanSymbolTable }  -- put the clean symbol table back in the state.

-- ------------------------------------------------------- --
-- ----------------Transofrmation Functions--------------- --
-----                  ---  (ArgName, Type )
createFunInfo :: Name -> [(Name,VarType,Bool,Bool)]  ->  FunType -> FunInfo
createFunInfo func_name fun_args fun_res = FunInfo {
      fn_name = func_name
    , result_type = fun_res
    , args = fun_args
    , forward_dec = False
}   -- we simply get all fileds already computed and package them in a FunInfo Struct

createFType :: R_Type -> FunType  -- takes the token that corresponds to a functions return type
createFType R_Type_Proc =  "proc" -- and returns its VarType string
createFtype ( R_Type_DT (D_Type TInt ) ) =  "int"
createFtype ( R_Type_DT (D_Type TByte ) ) =  "byte"

-- (Var Name, Var Type{int, byte}, Reference{T,F}, Table{T,F})
createArgType:: FPar_Def -> (Name,VarType, Bool, Bool )    -- takes a function arguement from the ast and returns its sem tuple
createArgType ( FPar_Def_Ref str (S_Type (D_Type TInt)) )      = (str, "int" , True, False)
createArgType ( FPar_Def_Ref str (S_Type (D_Type TByte)) )     = (str, "byte", True, False)
createArgType ( FPar_Def_Ref str (Table_Type (D_Type TInt)) )  = (str, "table int" , True, True)
createArgType ( FPar_Def_Ref str (Table_Type (D_Type TByte)))  = (str, "table byte", True, True)
createArgType ( FPar_Def_NR  str (S_Type (D_Type TInt)) )      = (str, "int" , False, False)
createArgType ( FPar_Def_NR  str (S_Type (D_Type TByte)) )     = (str, "byte", False, False)
createArgType ( FPar_Def_NR  str (Table_Type (D_Type TInt)) )  = (str, "table int" , False, True)
createArgType ( FPar_Def_NR  str (Table_Type (D_Type TByte)) ) = (str, "table byte", False, True)


createVar_from_Def :: Var_Def -> VarInfo
createVar_from_Def ( VDef str (D_Type TInt) )  = createVarInfo str "int"  0 Nothing False
createVar_from_Def ( VDef str (D_Type TByte) ) = createVarInfo str "byte" 0 Nothing False
createVar_from_Def ( VDef_T str (D_Type TInt) dimension  )  = createVarInfo str "table int"  0 (Just dimension) False
createVar_from_Def ( VDef_T str (D_Type TByte) dimension )  = createVarInfo str "table byte" 0 (Just dimension) False
-- Whenever we create a variable from a Var_Def, it's always NOT by reference
-- If it's a table, we know a priori its size, so we add it
-- Else, we add Nothing to the dimension

-- NOTE: When we are inside a function, we treat this functions arguments as normal parameters,
-- so we keep a var_info type for all of them
createVar_from_Arg :: FPar_Def -> VarInfo
createVar_from_Arg ( FPar_Def_Ref str (S_Type (D_Type TInt)) )      = createVarInfo str "int" 0 Nothing True
createVar_from_Arg ( FPar_Def_Ref str (S_Type (D_Type TByte)) )     = createVarInfo str "byte" 0 Nothing True
createVar_from_Arg ( FPar_Def_Ref str (Table_Type (D_Type TInt)) )  = createVarInfo str "table int" 0 (Just 0) True
createVar_from_Arg ( FPar_Def_Ref str (Table_Type (D_Type TByte)))  = createVarInfo str "table byte" 0 (Just 0) True
createVar_from_Arg ( FPar_Def_NR  str (S_Type (D_Type TInt)) )      = createVarInfo str "int" 0 Nothing False
createVar_from_Arg ( FPar_Def_NR  str (S_Type (D_Type TByte)) )     = createVarInfo str "byte" 0 Nothing False
createVar_from_Arg ( FPar_Def_NR  str (Table_Type (D_Type TInt)) )  = createVarInfo str "table int" 0 (Just 0) False
createVar_from_Arg ( FPar_Def_NR  str (Table_Type (D_Type TByte)) ) = createVarInfo str "table byte" 0 (Just 0 ) False
-- NOTE: A VarInfo table having as dimensions JUST 0 has special meaning:
-- it means that we are indeed talking about a table, but we don't know its size yet

createVarInfo:: Name -> VarType -> Int ->  Maybe Int -> Bool -> VarInfo
createVarInfo  nm_str vt idv dimension_num by_ref_bool =  VarInfo {
      var_name = nm_str
    , var_type = vt
    , id_num = idv
    , dimension = dimension_num
    , byreference = by_ref_bool
}   -- we get all fields of a VarInfo and package them accordingly

-- ------------------------------------------------------- --
-- ------------Symbol Manipulation Functions-------------- --

-- We need to add a symbol with addFunc, addVar, addFArgs
addSymbol :: Name -> G_Info -> P ()
addSymbol symbol_name symbol_info = do
    s <- get
    let
        currScope = currentScope s                -- get the current scope
        currSymbols = symbols currScope           -- get the current symbol table, from the current scope
        symb_t = symbolTable s               -- get our backend implementation of nested scopes
        newSymbols = Map.insert symbol_name symbol_info currSymbols -- we update our symbol table
        newScope = currScope { symbols = newSymbols }   -- we updated our scope

    put s    { symbolTable  = Map.insertWith (++) symbol_name [newScope] symb_t
             , currentScope = newScope
    }
    -- NOTE : We also need to update our behind the scenes scopes! If you have an issue with that Kimonas,
    -- my biceps are bigger than yours, just saying...

-- Takes the necessary fields from a function defintion, and adds a fun_info struct to the current scope
addFunc :: Name ->  FPar_List  ->  R_Type -> P ()
addFunc name args_lst f_type = do
    scpnm <- getScopeName
    writeLog $ "add function was called from scope " ++ scpnm ++ " for function " ++ name
    let
        our_ret = createFType f_type   -- we format all of the function stuff properly
        fun_args = map createArgType args_lst
        fn_info = createFunInfo name fun_args our_ret
    addSymbol (fn_name fn_info) (F fn_info)

addVar :: Var_Def -> P ()    -- takes a VARIABLE DEFINITION , and adds the proper things, to the proper scopes
addVar vdef = do
    scpnm <- getScopeName
    let var_info = createVar_from_Def vdef    -- create the new VarInfo filed to be inserted in the scope
    addSymbol (var_name var_info) (V var_info)
    writeLog $ "Adding variable " ++ (var_name var_info) ++ " to the scope " ++ scpnm

-- Put the Function args to the function's scope, as variables variables
addFArgs :: FPar_List -> P ()
addFArgs (arg:args) = do
    let param = createVar_from_Arg arg
    writeLog $ "Adding Func Param " ++ (var_name param) ++ " to the scope"
    addSymbol (var_name param) (V param)
    addFArgs args
addFArgs [] = do
    return ()

addLDef :: Local_Def -> P ()
addLDef def = do
  case def of
    Loc_Def_Fun fun -> semFuncDef fun
    Loc_Def_Var var -> addVar var

-- Check it at night. -> Looks fine to me.
addLDefLst :: [Local_Def] -> P  ()
addLDefLst [] = do { return () }
addLDefLst (def:defs) = do
    addLDef def
    addLDefLst defs

-- ------------------------------------------------------- --
-- ----------------Top Level Functions-------------------- --

-- Used to ensure that variables are used as variables
-- and tables as tables - Kimon

-- That function is completely gone, but the redundant comments survived
-- in its memory

--NOTE : Checks that soething that looks like a table
-- is a talbe, and soething that looks like a var, is a var
--  -Ermis

-- Recursively check the type of the expression, and return it
getExprType :: Expr -> P String
-- getExprType (Expr_Int _) = return "int"
getExprType (Expr_Int num ) = return "int"

getExprType (Expr_Char _)= return "byte"
getExprType (Expr_Brack expr) = getExprType expr

getExprType (Expr_Add left right ) = do
    left_type  <- getExprType left
    right_type <- getExprType right
    case unifyTypes left_type right_type of
        "incompatitable"  -> error $ "Types " ++ left_type ++ " " ++ right_type ++ " are incompatitable for addition."
        _ -> return (unifyTypes left_type right_type)

getExprType (Expr_Sub left right ) = do
    left_type  <- getExprType left
    right_type <- getExprType right
    case unifyTypes left_type right_type of
        "incompatitable"  -> error $ "Types " ++ left_type ++ " " ++ right_type ++ " are incompatitable for subtraction."
        _                 -> return (unifyTypes left_type right_type)


getExprType (Expr_Tms left right ) = do
    left_type  <- getExprType left
    right_type <- getExprType right
    case unifyTypes left_type right_type of
        "incompatitable"  -> error $ "Types " ++ left_type ++ " " ++ right_type ++ " are incompatitable for multiplication."
        _                 -> return (unifyTypes left_type right_type)


getExprType (Expr_Mod left right ) = do
    left_type  <- getExprType left
    right_type <- getExprType right
    case unifyTypes left_type right_type of
        "incompatitable"  -> error $ "Types " ++ left_type ++ " " ++ right_type ++ " are incompatitable for mod."
        _                 -> return (unifyTypes left_type right_type)

getExprType (Expr_Div left right ) = do
    left_type  <- getExprType left
    right_type <- getExprType right
    case unifyTypes left_type right_type of
        "incompatitable"  -> error $ "Types " ++ left_type ++ " " ++ right_type ++ " can't be divided."
        _                 -> return (unifyTypes left_type right_type)

getExprType (Expr_Pos num ) = do
    num  <- getExprType num
    case num of
        "int"           -> return "int"
        "byte"          -> return "byte"
        "int or byte"   -> return "int or byte"
        _ -> error $ "Type " ++ num  ++  " has no positive."
-- the only types that can have a positive or negative sign are int and byte
-- the resulting type must be the same as the initial


-- NOTE: Not sure what we must do about that. Bytes have no negative?
-- WARNING: PAY SPECIAL ATTENTION TO NEGATIVE!
getExprType (Expr_Neg num ) = do
    num  <- getExprType num
    case num of
        "int"  -> return "int"
        "int or byte" -> return "int"
        _ -> error $ "Type " ++ num  ++  " has no negative."
-- the only types that can have a positive or negative sign are int and byte
-- the resulting type must be the same as the initial

getExprType (Expr_Lval (LV_Lit str)) = return "table byte"

getExprType (Expr_Lval (LV_Var var)) = do
    V var_info <- checkSymbolError var
    return $ var_type var_info
-- in case we encounter something that looks like a variable, we do simple stuff:
-- we just check our symbol table, and return its type, regarldess of what
-- that type might be


getExprType (Expr_Lval (LV_Tbl var dim)) = do
    dim_type <- getExprType dim
    V table_info <- checkSymbolError var
    case (dim_type , var_type table_info ) of
        ("int", "table int" )  -> return "int"
        ("int", "table byte")  -> return "byte"
        ("int or byte", "table int")  -> return "int"
        ("int or byte", "table byte")  -> return "byte"
        ( _ , _)               -> error  $ "Something sketchy is going on with the table " ++ var



-- NOTE: late night, maybe this should be beautified, but definetely not now
-- NOTE: Not sure if the check here is proper!  --> Fixed.
getExprType (Expr_Fcall (Func_Call fname fargs) ) = do
    actual_types <- get_actual_types fargs [] -- get the list of types of the given arguements
    formal_types <- get_formal_types fname
    F foo_info <- checkSymbolError fname
    if (check_inferred_types formal_types actual_types ) then return $ result_type foo_info
    else  error $ "arg missmatch in function " ++ fname
-- Simple enough: If the type of all the actual paramters a function
-- was called with match respectively with the type of the formal
-- types, then the result type is the one declared by the fuction


getExprType _ = return ""   -- NOTE: The compiler should return this pattern is redundant here
-- which it does, because we have tested all the cases.

-- tries to take care of the int/byte problem
unifyTypes:: String -> String -> String
unifyTypes "int" "int" = "int"
unifyTypes "byte" "byte" = "byte"
unifyTypes "int" "int or byte" = "int"
unifyTypes "byte" "int or byte" =   "byte"
unifyTypes "int or byte" "int or byte" =  "int or byte"
-- unifyTypes first second = error $ "can not unify types " ++ first ++ " second!"
unifyTypes first second = "incompatitable"




get_actual_types::[Expr] -> [String] ->  P [String]
get_actual_types [] types = return $ reverse types
get_actual_types (expr:rest) types = do
    act_type <- getExprType expr -- take the type of the expression at the head of the list for interpretation
    get_actual_types rest (act_type:types )  -- keep interpeting


-- takes the name of a function, and returns a list
-- with the type of its arguments, in the proper order
get_formal_types:: String -> P [String]
get_formal_types fn_name = do
    F fn_info <- checkSymbolError fn_name -- lookup the function on the symbol table
    return $ map get_vartype (args fn_info)
    where get_vartype (a,b,c,d) = b

-- Takes the list of types of the formal parameters,
-- and the list of types of the arguements, and checks whether they
-- can be unified
check_inferred_types:: [String] -> [String] -> Bool
check_inferred_types [] [] = True
check_inferred_types ("int" : rest1) ("int or byte": rest2 ) = check_inferred_types rest1 rest2
check_inferred_types ("byte" : rest1) ("int or byte": rest2 ) = check_inferred_types rest1 rest2
check_inferred_types (h1 : rest1) ( h2: rest2 ) = case (h1 == h2 ) of
    True  -> check_inferred_types rest1 rest2
    False -> False
check_inferred_types _ _ = False




-- NOTE Up to now Smt_Eq only works
-- check getExprType which check if an Expr is well defined and returns its type
-- Haven't touched function checking (params, return vals etc)  -- > Done.
semStmt :: Stmt -> P ()
-- Just a ; do nothing
semStmt Stmt_Semi = return ()

-- Case where L_Value = Expr (Stmt_Eq)
semStmt (Stmt_Eq (LV_Lit str) expr) =
    error $ "Cannot assign value to string: " ++ str
-- NOTE: Now we don't need special case for this:


semStmt (Stmt_Eq lval expr) = do
    lval_type <- getExprType (Expr_Lval lval)
    expr_type <- getExprType expr
    case (lval_type, expr_type) of
        ("int", "int")    ->  return ()
        ("byte", "byte")  -> return ()
        _                 -> error $ "Types " ++ lval_type ++ " and " ++ expr_type ++ "can't be assigned!"

semStmt (Stmt_Cmp cmp_stmt) = do
    semStmtList cmp_stmt
    return ()

-- WARNING: FN_CALL is incomplete (read specs page 9 )
semStmt (Stmt_FCall ( Func_Call name args  ) ) = do
     response <- checkSymbolError name  -- get the function defintion
     case response of
         F foo_info -> return ()
         V voo_info -> error $ "you can't call a non-function like " ++ name
-- WARNING:Continue from here!
    -- case (ret_type ) of
    --     "proc"  -> return ()
    --     _       -> error $ "When we have a fun call as a statement, its type must be proc, not " ++ ret_type

semStmt (Stmt_If cond stmt) = do
    semCond cond   -- do the semantic analysis of the condition
    semStmt stmt   -- do the semantic analysis of the statement
    return ()      -- if they didn't fail, we don't fail

semStmt (Stmt_IFE cond stmt1 stmt2 ) = do
    semCond cond  -- same logic, we just check both statements
    semStmt stmt1
    semStmt stmt2
    return ()

semStmt (Stmt_Wh cond stmt) = do
    semCond cond    -- do the semantic analysis of the condition
    semStmt stmt    -- do the semantic analysis of the statement
    return ()       -- if they didn't fail, we don't fail


-- WARNING: Also incorrect, this needs a lot of work I think
semStmt Stmt_Ret = return ()


semStmt (  Stmt_Ret_Expr expr ) = return ()

semStmt _ = return ()
-- NOTE: again, if we have done our job properly, this
-- should return "pattern match redundant"


-- Checks if a condition is valid. If it is, it just returns.
semCond :: Cond -> P ()
semCond Cond_True = return ()
semCond Cond_False = return ()
-- in the simple cases, we just return

semCond (Cond_Br cond) = do
    semCond cond  -- if the analysis of the inner condition
    return ()     -- doesn't fail, we don't

semCond (Cond_Bang cond) = do
    semCond cond  -- if the analysis of the inner condition
    return ()     -- doesn't fail, we don't

semCond (Cond_Eq expr1 expr2) = do
    type1 <- getExprType expr1  -- check that the 2 operands being
    type2 <- getExprType expr2  -- compared have  valid types for
    case (type1, type2 ) of    -- an equality check
        ("int", "int")     -> return ()
        ("byte", "byte")   -> return ()

semCond (Cond_Neq expr1 expr2) = do
    type1 <- getExprType expr1
    type2 <- getExprType expr2
    case (type1, type2 ) of
        ("int", "int")     -> return ()
        ("byte", "byte")   -> return ()

semCond (Cond_L expr1 expr2) = do
    type1 <- getExprType expr1
    type2 <- getExprType expr2
    case (type1, type2 ) of
        ("int", "int")     -> return ()
        ("byte", "byte")   -> return ()

semCond (Cond_G expr1 expr2) = do
    type1 <- getExprType expr1
    type2 <- getExprType expr2
    case (type1, type2 ) of
        ("int", "int")     -> return ()
        ("byte", "byte")   -> return ()

semCond (Cond_LE expr1 expr2) = do
    type1 <- getExprType expr1
    type2 <- getExprType expr2
    case (type1, type2 ) of
        ("int", "int")     -> return ()
        ("byte", "byte")   -> return ()

semCond (Cond_GE expr1 expr2) = do
    type1 <- getExprType expr1
    type2 <- getExprType expr2
    case (type1, type2 ) of
        ("int", "int")     -> return ()
        ("byte", "byte")   -> return ()

semCond (Cond_And c1 c2 ) = do
    semCond c1  -- If neither of the inner conditions failed
    semCond c2  -- we don't.
    return ()

semCond (Cond_Or c1 c2 ) = do  --same logic as and
    semCond c1
    semCond c2
    return ()

semCond _ = return () -- NOTE: This should return pattern match
--redunadant, just a sanity check that we have covered every case.

semStmtList :: Comp_Stmt -> P ()
semStmtList (C_Stmt []) = do
    return ()
semStmtList (C_Stmt (stmt:rest)) = do
    semStmt stmt
    semStmtList (C_Stmt rest)    -- this will be beautified with a nice fmap

semFuncDef :: Func_Def -> P ()
semFuncDef (F_Def name args_lst f_type ldef_list cmp_stmt) = do
    addFunc name args_lst f_type      -- > we add the function to our CURRENT scope, so the one who defined the function can then call her.
    openScope name                    -- > every function creates a new scope
    addFArgs args_lst                 -- > add formal parameters  (list of var info , add it to the map with the vars)
    addFunc name args_lst f_type      -- > NOTE: add the function to the inside scope as well ?
    addLDefLst ldef_list              -- > add the local definitions of that function, this is where the recursion happens
    semStmtList cmp_stmt              -- > do the Semantic analysis of the function body
    closeScope                        -- > close the function' s scope


ast_sem :: Program -> P String
ast_sem (Prog main) = do
    semFuncDef main
    s <- get
    return (logger s)


run_sem :: Program -> String
run_sem alan = evalState (ast_sem alan) initialSemState
