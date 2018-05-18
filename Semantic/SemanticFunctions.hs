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
checkSymbol:: Name -> P ( Maybe (G_Info, Name, Bool) )
checkSymbol var_name = do
    s <- get
    let curr_scope = currentScope s
    case var_name `Map.lookup` (symbols curr_scope) of
        Just info -> return $ Just (info, scp_name curr_scope, True )  -- the variable is in the current scope
        Nothing   ->  do   -- the variable isn't defined in the current scope
            case var_name `Map.lookup` (symbolTable s) of
                Nothing -> return Nothing -- the variable is nowhere to be found
                Just [] -> return Nothing -- the variable is nowhere to be found
                Just (scp:scps) -> case var_name `Map.lookup` (symbols scp) of
                    Just info -> return ( Just (info, scp_name scp, False) )
                    Nothing   -> return Nothing

-- ------------------------------------------------------- --
-- ----------------------Scope Functions------------------ --

-- Opens a new scope, we just edit
-- the currentScope in our State
openScope :: String -> P ()
openScope name = do
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

removeScopeSymbols :: [Name] -> Name ->  P ()
removeScopeSymbols [] nm  = do
    writeLog $ "cleaning up the symbol table for scope name "  ++ nm
removeScopeSymbols symbol_lst nm = do
    writeLog $ "cleaning up the symbol table for scope name "  ++ nm
    s <- get
    let cleanSymbolTable = cleanup (symbolTable s) symbol_lst  -- clean it up
    put s { symbolTable = cleanSymbolTable }  -- put the clean symbol table back in the state.

-- ------------------------------------------------------- --
-- ----------------Transofrmation Functions--------------- --

createFunInfo :: Name -> [(Name,VarType,Bool)]  ->  FunType -> FunInfo
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

createArgType:: FPar_Def -> (Name,VarType, Bool )    -- takes a function arguement from the ast and returns its sem tuple
createArgType ( FPar_Def_Ref str (S_Type (D_Type TInt)) )      = (str, "int" ,True)
createArgType ( FPar_Def_Ref str (S_Type (D_Type TByte)) )     = (str, "byte" ,True)
createArgType ( FPar_Def_Ref str (Table_Type (D_Type TInt)) )  = (str, "int table" ,True)
createArgType ( FPar_Def_Ref str (Table_Type (D_Type TByte)))  = (str, "byte table" ,True)
createArgType ( FPar_Def_NR  str (S_Type (D_Type TInt)) )      = (str, "int" ,False)
createArgType ( FPar_Def_NR  str (S_Type (D_Type TByte)) )     = (str, "byte" ,False)
createArgType ( FPar_Def_NR  str (Table_Type (D_Type TInt)) )  = (str, "int table" ,False)
createArgType ( FPar_Def_NR  str (Table_Type (D_Type TByte)) ) = (str, "byte table" ,False)


createVar_from_Def :: Var_Def -> VarInfo
createVar_from_Def ( VDef str (D_Type TInt) )  = createVarInfo str "int"  0 Nothing False
createVar_from_Def ( VDef str (D_Type TByte) ) = createVarInfo str "byte" 0 Nothing False
createVar_from_Def ( VDef_T str (D_Type TInt) dimension  )  = createVarInfo str "int table"  0 (Just dimension) False
createVar_from_Def ( VDef_T str (D_Type TByte) dimension )  = createVarInfo str "byte table" 0 (Just dimension) False
-- Whenever we create a variable from a Var_Def, it's always NOT by reference
-- If it's a table, we know a priori its size, so we add it
-- Else, we add Nothing to the dimension

-- NOTE: When we are inside a function, we treat this functions arguments as normal parameters,
-- so we keep a var_info type for all of them
createVar_from_Arg :: FPar_Def -> VarInfo
createVar_from_Arg ( FPar_Def_Ref str (S_Type (D_Type TInt)) )      = createVarInfo str "int" 0 Nothing True
createVar_from_Arg ( FPar_Def_Ref str (S_Type (D_Type TByte)) )     = createVarInfo str "byte" 0 Nothing True
createVar_from_Arg ( FPar_Def_Ref str (Table_Type (D_Type TInt)) )  = createVarInfo str "int table" 0 (Just 0) True
createVar_from_Arg ( FPar_Def_Ref str (Table_Type (D_Type TByte)))  = createVarInfo str "byte table" 0 (Just 0) True
createVar_from_Arg ( FPar_Def_NR  str (S_Type (D_Type TInt)) )      = createVarInfo str "int" 0 Nothing False
createVar_from_Arg ( FPar_Def_NR  str (S_Type (D_Type TByte)) )     = createVarInfo str "byte" 0 Nothing False
createVar_from_Arg ( FPar_Def_NR  str (Table_Type (D_Type TInt)) )  = createVarInfo str "int table" 0 (Just 0) False
createVar_from_Arg ( FPar_Def_NR  str (Table_Type (D_Type TByte)) ) = createVarInfo str "byte table" 0 (Just 0 ) False
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

semFuncDef :: Func_Def -> P ()
semFuncDef (F_Def name args_lst f_type ldef_list cmp_stmt) = do
    addFunc name args_lst f_type      -- > we add the function to our CURRENT scope, so the one who defined the function can then call her.
    openScope name                    -- > every function creates a new scope
    addFArgs args_lst                 -- > add formal parameters  (list of var info , add it to the map with the vars)
    addFunc name args_lst f_type      -- > NOTE: add the function to the inside scope as well ?
    addLDefLst ldef_list              -- > add the local definitions of that function, this is where the recursion happens
    semStmtList cmp_stmt              -- > do the Semantic analysis of the function body
    closeScope                        -- > close the function' s scope


semStmtList :: Comp_Stmt -> P ()
semStmtList _ = do
    return ()

ast_sem :: Program -> P String
ast_sem (Prog main) = do
    semFuncDef main
    s <- get
    return (logger s)


run_sem :: Program -> String
run_sem alan = evalState (ast_sem alan) initialSemState
