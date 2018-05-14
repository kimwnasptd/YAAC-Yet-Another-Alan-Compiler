module SemanticFunctions where

import ASTTypes
import SymbolTableTypes
import qualified Data.HashMap.Strict as Map
import Control.Monad.State
import Control.Monad

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
--
-- ------------------------------------------------------- --
-- ----------------Top Level Functions-------------------- --

semFuncDef :: F_Def -> P ()
semFuncDef (F_Def name args_lst f_type ldef_list cmp_stmt) = do
  addFunc name args_lst f_type
  openScope name   -- > every function creates a new scope
  addFArgs args_lst  -- > add formal parameters
  addFunc name args_lst f_type
  addLDef ldef_list
  semStmtList cmp_stmt
  closeScope

ast_sem :: Program -> P String
ast_sem (Prog main) = do
  semFuncDef main
  s <- get
  return (logger s)

run_sem :: Program -> String
run_sem alan = evalState (ast_sem alan) initialSemState
