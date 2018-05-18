module SymbolTableTypes where

import Control.Monad.State
import Control.Monad
import qualified Data.HashMap.Strict as Map

type SymbolTable = Map.HashMap Name [Scope]
-- we give it the SCOPE NAME and it gives us the actual scope

-- type NameTable = Map.Map Name [ScopeID]     -- Key: Variable Name, Val: Scope Key
-- type ScopeTable = Map.Map ScopeID Scope     -- (Used to search them in their own Map)

type Name = String
type VarType = String   -- int, byte, t_byte, t_int (with "")
type FunType = String   -- int, byte, proc

data VarInfo = VarInfo {
      var_name    :: Name              -- the variable name
    , var_type    :: VarType
    , id_num      :: Int               -- we'll probably need this field later
    , dimension   :: Maybe Int         -- its dimensions, if it's a table
    , byreference :: Bool              -- if it was passed by reference (if it is a function arg)
  }
  deriving Show

data FunInfo = FunInfo {
      fn_name        :: Name
    , result_type    :: FunType
    , args           :: [(Name,VarType, Bool )]  -- NOTE: for every argument, we know if its by reference or not
    , forward_dec    :: Bool
  }
  deriving Show

data G_Info = V VarInfo
            | F FunInfo
            deriving Show

data Scope = Scope {
      scp_name        :: Name
    , symbols         :: Map.HashMap Name G_Info     -- args and local vars go here
    , parent_scope    :: Maybe Scope  -- Used when we close a scope
  }
  deriving Show


-- Monad Code
data SemState = SemState {
    -- symbolTable :: SymbolTable
      symbolTable   :: SymbolTable
    , currentScope  :: Scope   -- > We always keep the current scope close to our chest.
    , logger        :: String
  }
  deriving Show

emptyScope :: Scope
emptyScope = Scope {
        scp_name = ""
      , symbols = Map.empty
      , parent_scope = Nothing    -- Genesis Scope doesn't have a parent
  }

initialSemState :: SemState
initialSemState = SemState {
      symbolTable = Map.empty
    , currentScope = emptyScope
    , logger = ""
  }

-- Our Semantic Monad
type P a = State SemState a
