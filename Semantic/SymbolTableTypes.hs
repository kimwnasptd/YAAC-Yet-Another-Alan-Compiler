module SymbolTableTypes where

import Control.Monad.State
import Control.Monad
import qualified Data.HashMap.Strict as Map


type ScopeID = Int

type SymbolTable = Map.HashMap Name [Scope]

-- type NameTable = Map.Map Name [ScopeID]     -- Key: Variable Name, Val: Scope Key
-- type ScopeTable = Map.Map ScopeID Scope     -- (Used to search them in their own Map)

type Name = String
type VarType = String   -- int, byte, t_byte, t_int (with "")
type FunType = String   -- int, byte, proc

data VarInfo = VarInfo {
      var_name    :: Name
    , var_type    :: VarType
    , id          :: Int
    , dimension   :: Maybe Int
    , byreference :: Bool 
  }
  deriving Show

data FunInfo = FunInfo {
      fn_name        :: Name
    , result_type    :: FunType
    , args           :: [(Name,VarType)]
    , forward_dec    :: Bool
  }
  deriving Show


data Scope = Scope {
      scope_id        :: ScopeID
    , scp_name        :: Name
    , vars            :: Map.HashMap Name VarInfo     -- args go here ?
    , funs            :: Map.HashMap Name FunInfo
    , parent_scope    :: Maybe Scope  -- Used when we close a scope
  }
  deriving Show


-- Monad Code
data SemState = SemState {
      symbolTable   :: SymbolTable
    , currentScope  :: Scope
    , counter       :: Int
    , logger        :: String
  }
  deriving Show

emptyScope :: Scope
emptyScope = Scope {
        scope_id = 0  -- I think we won't need this
      , scp_name = ""
      , vars = Map.empty
      , funs = Map.empty
      , parent_scope = Nothing    -- Genesis Scope doesn't have a parent
  }

initialSemState :: SemState
initialSemState = SemState {
      symbolTable = Map.empty
    , currentScope = emptyScope
    , counter = 1   -- We might also not need this
    , logger = ""
  }

-- Our Semantic Monad
type P a = State SemState a
