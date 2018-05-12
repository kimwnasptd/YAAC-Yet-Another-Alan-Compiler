module SemanticFunctions where

import ASTTypes
import SymbolTableTypes
import qualified Data.Map as Map
import Control.Monad.State
import Control.Monad

-- The Types for the Symbol Table Entries

-- F_Def -> update the current scope with the new fun, openScope

-- A function that add the args of a fun to the current scope
-- A function that adds the Local Defs to the scope. If it find an F_Def it calls the previous function
-- Need a function that turnes F_Def -> FunInfo

-- Add to the scope the new function, the args
-- First add local vars and methods to 
-- We'll need to add the Counter (for the Scope IDs) to the Monad


ast_sem :: Program -> IO ()
ast_sem (Prog alan) = do
    print ("Semantics finished successfully")


