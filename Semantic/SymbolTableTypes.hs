module SymbolTableTypes where

import Control.Monad.State
import Control.Monad
import qualified Data.Map as Map


type ScopeID = Int

type NameTable = Map.Map Name [ScopeID]     -- Key: Variable Name, Val: Scope Key (Used to search them in their own Map)
type ScopeTable = Map.Map ScopeID Scope     -- 

type Name = String
type VarType = String   -- int, byte, t_byte, t_int (with "")
type FunType = String   -- int, byte, proc

data VarInfo = 
    VarInfo {
      var_name    :: Name
    , var_type    :: VarType
    , id          :: Int 
    , dimension   :: Maybe Int
  }
  deriving Show

data FunInfo = 
    FunInfo {
      fn_name        :: Name
    , result_type    :: FunType
    , args           :: [(Name,VarType)]
    , forward_dec    :: Bool
  }
  deriving Show


data Scope = 
    Scope {
      scope_id        :: ScopeID
    , vars            :: Map.Map Name VarInfo     -- args go here ?
    , funs            :: Map.Map Name FunInfo
    , parent_scope    :: Scope  -- Maybe we won't need this one

  }
  deriving Show


-- Monad Code
data SemState =
     SemState { nameTable   :: NameTable
              , scopeTable  :: ScopeTable
              , counter     :: Int
              }
    deriving Show

initialSemState :: SemState
initialSemState = SemState { nameTable = Map.empty, 
                             scopeTable = Map.empty, 
                             counter = 1
                           }

-- Our Semantic Monad
type P a = State SemState a