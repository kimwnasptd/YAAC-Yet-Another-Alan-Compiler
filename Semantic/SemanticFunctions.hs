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
  -- NOTE: If you are using more than one in the same function, chances
  -- are people (redditors at least ) will make fun of you.
    let
        currScope = currentScope s
        symbol_names = Map.keys $ symbols currScope

    removeScopeSymbols symbol_names scpnm
  -- Remove the Function Names


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

-- Removes the va
cleanup :: SymbolTable_Frontend -> [Name] -> Name -> SymbolTable_Frontend
cleanup frontend [] scope_name = frontend
cleanup frontend (var_name:rest) scope_name = case Map.lookup var_name frontend of
    Nothing -> cleanup frontend rest scope_name -- what we wanted to remove didn't even make it
    -- to the inner workings of our symbol table, what a short life!
    Just [] -> cleanup frontend rest scope_name -- NOTE: This would have been a bug for the ages!
    Just name_list -> case head name_list of
        scope_name -> cleanup ( Map.insert var_name (tail name_list) frontend ) rest  scope_name
            -- new_frontend = Map.insert var_name (tail name_list) frontend
            -- cleanup new_frontend rest scope_name
            -- we remove the name of the current scope from the record of names that has that variable
        _ -> cleanup frontend rest scope_name
        -- again, what we wanted to remove wasn't even properly inserted in our symbol table
        -- to begin with

--NOTE: How is it possible for a search to our symbol table front end to return nothing?
-- Keep in mind we always keep our current scope close at hand, in a field named currentScope at our
-- semstate, in order to be more efficient. If that scope stops being live before we need to change our
-- active scope, then the variables that scope contained will never be added to the hashmap of scopes that
-- we use for book keeping.

removeScopeSymbols :: [Name] -> Name ->  P ()
removeScopeSymbols [] nm  = do
  return ()
removeScopeSymbols symbol_lst nm = do
    writeLog $ "cleaning up the symbol table for scope name "  ++ nm
    s <- get
    let
        curr_fend = symbol_fend s  -- get the current front-end of our symbol table
        clean_fend = cleanup curr_fend symbol_lst nm  -- clean it up
    put s { symbol_fend = clean_fend}  -- put the clean symbol table back in the state.
    return ()   -- TODO





-- Put the Function args to the function's scope, as variables variables
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


-- Takes the necessary fields from a function defintion, and adds a fun_info struct to the current scope
addFunc :: Name ->  FPar_List  ->  R_Type -> P ()
addFunc name args_lst f_type = do
    s <- get
    scpnm <- getScopeName
    writeLog  $ "add function was called from scope  " ++ scpnm ++ "for function " ++ name
    let
        our_ret = createFType f_type   -- we format all of the function stuff properly
        fun_args = map createArgType args_lst
        new_fn_info = createFunInfo name fun_args our_ret
        new_G_Info = F new_fn_info
        -- NOTE: From this point down, it's the same as addVar
        currScope = currentScope s                -- get the current scope
        currSymbols = symbols currScope           -- get the current symbol table, from the current scope
        curr_fend = symbol_fend s                 -- get our backend implementation of nested scopes
        newSymbols = Map.insert name new_G_Info currSymbols -- we update our symbol table
        newScope = currScope { symbols = newSymbols }   -- we updated our scope
        new_fend = Map.insertWith foo name [scpnm] curr_fend where  -- we also update our backend
            foo lst_a lst_b = lst_a ++ lst_b
            -- NOTE : We also need to update our behind the scenes scopes! If you have an issue with that Kimonas,
            -- my biceps are bigger than yours, just saying...

    put s    { symbol_fend = new_fend
             , currentScope = newScope
    }

    return ()


addVar :: Var_Def -> P ()    -- takes a VARIABLE DEFINITION , and adds the proper things, to the proper scopes
addVar vdef = do
    s <- get   -- get the state
    scpnm <- getScopeName
    let
        new_var_info = createVar_from_Def vdef    -- create the new VarInfo filed to be inserted in the scope
        new_var_name = var_name new_var_info      -- get its name to be used as key
        new_G_Info = V new_var_info               -- package it properly for the scope
        -- NOTE: Below this point, it's the same thing as add Fun
        currScope = currentScope s                -- get the current scope
        currSymbols = symbols currScope           -- get the current symbol table, from the current scope
        curr_fend = symbol_fend s                 -- get our backend implementation of nested scopes
        newSymbols = Map.insert new_var_name new_G_Info currSymbols -- we update our symbol table
        newScope = currScope { symbols = newSymbols }   -- we updated our scope
        new_fend = Map.insertWith foo new_var_name [scpnm] curr_fend where  -- we also update our backend
            foo lst_a lst_b = lst_a ++ lst_b
            -- NOTE : We also need to update our behind the scenes scopes! If you have an issue with that Kimonas,
            -- my biceps are bigger than yours, just saying...

    put s    { symbol_fend = new_fend
             , currentScope = newScope
    }
    writeLog $ "adding variable " ++ new_var_name ++ "to the scope " ++ scpnm

    return ()







-- ------------------------------------------------------- --
-- ----------------Top Level Functions-------------------- --

semFuncDef :: Func_Def -> P ()
semFuncDef (F_Def name args_lst f_type ldef_list cmp_stmt) = do
  addFunc name args_lst f_type    --  > we add the function to our CURRENT scope, so the one who defined the function can then call her.
  openScope name   -- > every function creates a new scope
  addFArgs args_lst  -- > add formal parameters  (list of var info , add it to the map with the vars)
  addFunc name args_lst f_type  -- > NOTE: add the function to the inside scope as well ?
  --NOTE: addLDef ldef_list             -- > add the local definitions of that function
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
