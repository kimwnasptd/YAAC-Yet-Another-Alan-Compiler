module SemanticFunctions where

import Tokens
import ASTTypes
import SymbolTableTypes
import qualified Data.HashMap.Strict as Map
import Control.Monad.State
import Control.Monad
-- import Lexer.hs

-- ------------------------------------------------------- --
-- ------------------------------------------------------- --
-- The Types for the Symbol Table Entries

-- F_Def -> update the current scope with the new fun, openScope

-- A function that add the args of a fun to the current scope
-- A function that adds the Local Defs to the scope. If it find an F_Def it calls the previous function
-- Need a function that turnes F_Def -> FunInfo

-- Add to the scope the new function, the args
-- First add local vars and methods to
-- We'll need to add the Counter (for the Scope IDs) to the Monad
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

-- ------------------------------------------------------- --
-- ----------------------Scope Functions----------------- --

-- Opens a new scope, we just edit
-- the currentScope in our State
openScope :: String -> P ()
openScope name = do
  writeLog $ "Opening a new Scope for " ++ name
  s <- get
  case scp_name (currentScope s) of
    "" -> put s { currentScope = emptyScope { scp_name = name } }  -- if we are the INITIAL scope, we just change the scope's name
    _  -> put s {   -- Put as a State the current one
                  currentScope = emptyScope { -- But as a currentScope we put an empty one
                  parent_scope = (Just $ currentScope s)  -- And change its parent
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
  let currScope = currentScope s
  -- Remove the Var Names
  let var_names = Map.keys $ vars currScope
  removeScopeVars var_names
  -- Remove the Function Names
  let fun_names = Map.keys $ funs currScope
  removeScopeFuns fun_names
  -- Make current Scope the Parent one
  case parent_scope (currentScope s) of
    Just scope -> put s { currentScope = scope }
    Nothing -> return ()


-- Removes the current Scope from the list of Scopes
-- for each of the variables in this scope
removeScopeVars :: [Name] -> P ()
removeScopeVars (var:vars) = do
  return ()   -- TODO
removeScopeVars [] = do
  return ()

removeScopeFuns :: [Name] -> P ()
removeScopeFuns (fun:funs) = do
  return ()   -- TODO
removeScopeFuns [] = do
  return ()

-- Put the Function args to the current Scope
addFArgs :: FPar_List -> P ()
addFArgs (arg:args) = do
  return ()
addFArgs [] = do
  return ()

-- addFunc
-- addVar
-- addFArgs

createFunInfo :: Name -> [(Name,VarType,Bool)]  ->  FunType -> FunInfo
createFunInfo func_name fun_args fun_res = FunInfo {
      fn_name = func_name
    , result_type = fun_res
    , args = fun_args
    , forward_dec = False
}   -- we simply get all fileds already computed and package them in a FunInfo Struct


-- data VarInfo = VarInfo {
--       var_name    :: Name              -- the variable name
--     , var_type    :: VarType
--     , id          :: Int
--     , dimension   :: Maybe Int         -- its dimensions, if it's a table
--     , byreference :: Bool              -- if it was passed by reference (if it is a function arg)
--   }
--   deriving Show

createFType :: R_Type -> FunType  -- takes the token that corresponds to a functions return type
createFType R_Type_Proc =  "proc" -- and returns its VarType string
-- createFtype ( R_Type_DT (D_Type sth  ) ) = show sth    -- NOTE: I am going to strangle you Kimonas.
createFtype ( R_Type_DT (D_Type sth  ) ) = case show sth of
  "TInt"  -> "int"
  "TByte" -> "byte"
  _ -> seq undefined "oops "
-- createFType ( R_Type_DT (D_Type TByte ) ) = "byte"

createArgType:: FPar_Def -> (Name,VarType, Bool )    -- takes a function arguement from the ast and returns its sem tuple
createArgType ( FPar_Def_Ref str (S_Type (D_Type TInt)) )      = (str, "int" ,True)
createArgType ( FPar_Def_Ref str (S_Type (D_Type TByte)) )     = (str, "byte" ,True)
createArgType ( FPar_Def_Ref str (Table_Type (D_Type TInt)) )  = (str, "int table" ,True)
createArgType ( FPar_Def_Ref str (Table_Type (D_Type TByte)))  = (str, "int table" ,True)
createArgType ( FPar_Def_NR  str (S_Type (D_Type TInt)) )      = (str, "int" ,False)
createArgType ( FPar_Def_NR  str (S_Type (D_Type TByte)) )     = (str, "byte" ,False)
createArgType ( FPar_Def_NR  str (Table_Type (D_Type TInt)) )  = (str, "int table" ,False)
createArgType ( FPar_Def_NR  str (Table_Type (D_Type TByte)) ) = (str, "int table" ,False)


createVar :: Var_Def -> VarInfo
createVar ( VDef str (D_Type TInt) )  = createVarInfo str "int"  0 Nothing False
createVar ( VDef str (D_Type TByte) ) = createVarInfo str "byte" 0 Nothing False
createVar ( VDef_T str (D_Type TInt) dimension  )  = createVarInfo str "int table"  0 (Just dimension) False
createVar ( VDef_T str (D_Type TByte) dimension )  = createVarInfo str "byte table" 0 (Just dimension) False
-- Whenever we create a variable from a Var_Def, it's always NOT by reference
-- If it's a table, we know a priori its size, so we add it
-- Else, we add Nothing to the dimension


createVarInfo:: Name -> VarType -> Int ->  Maybe Int -> Bool -> VarInfo
createVarInfo  nm_str vt idv dimension_num by_ref_bool =  VarInfo {
      var_name = nm_str
    , var_type = vt
    , id_num = idv
    , dimension = dimension_num
    , byreference = by_ref_bool
}   -- we get all fields of a VarInfo and package them accordingly

addFunc :: String ->  FPar_List  ->  R_Type -> P ()
addFunc name args_lst f_type = do
    scpnm <- getScopeName
    writeLog  $ "add function was called from scope  " ++ scpnm ++ "for function " ++ name
    let
      our_ret = createFType f_type   -- we format all of the function stuff properly
      fun_args = map createArgType args_lst
      our_fn = createFunInfo name fun_args our_ret
    -- insert name  NOTE: We need to talk about what sem functions actually do ...
    return ()

addLDef :: L_Def_List -> P ()
addLDef _ = do
    return ()




-- createLocalDef:: L_Def  

--
-- ------------------------------------------------------- --
-- ----------------Top Level Functions-------------------- --

semFuncDef :: Func_Def -> P ()
semFuncDef (F_Def name args_lst f_type ldef_list cmp_stmt) = do
  addFunc name args_lst f_type    -- > we add the function to our CURRENT scope, so the one who defined the function can then call her.
  openScope name   -- > every function creates a new scope
  addFArgs args_lst  -- > add formal parameters
  addFunc name args_lst f_type  -- > NOTE: add the function to the inside scope as well ?
  addLDef ldef_list             -- > add the local definitions of that function
  semStmtList cmp_stmt          -- > do the Semantic analysis of the function body
  closeScope                    -- > close the function' s scope


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
