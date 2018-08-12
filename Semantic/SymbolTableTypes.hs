module SymbolTableTypes where

import Control.Monad.State
import Control.Monad
import qualified Data.HashMap.Strict as Map

type SymbolTable = Map.HashMap Name [Scope]
type Name = String
data SymbolType = IntType | ByteType | ProcType -- Fun Types
                | TableIntType | TableByteType  -- + Var Types
    deriving (Show, Eq)

data VarInfo = VarInfo {
      var_name    :: Name              -- the variable name
    , var_type    :: SymbolType
    , id_num      :: Int               -- we'll probably need this field later
    , dimension   :: Maybe Int         -- its dimensions, if it's a table NOTE: It's nothing, if we arent' a table
    , byreference :: Bool              -- if it was passed by reference (if it is a function arg)
  }
  deriving Show

data FunInfo = FunInfo {
      fn_name        :: Name
    , result_type    :: SymbolType
    , args           :: [(Name,SymbolType,Bool,Bool)] -- (name, type, ref, table)
    , forward_dec    :: Bool
  }
  deriving Show

data Symbol = V VarInfo
            | F FunInfo
            deriving Show

data Scope = Scope {
      scp_name        :: Name
    , symbols         :: Map.HashMap Name Symbol     -- args and local vars go here
    , parent_scope    :: Maybe Scope  -- Used when we close a scope
  }
  deriving Show


-- Monad Code
data SemState = SemState {
    -- symbolTable :: SymbolTable
      symbolTable   :: SymbolTable
    , currentScope  :: Scope   -- > We always keep the current scope close to our chest.
    , main          :: String  -- we need the name of the main function
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
      symbolTable = Map.empty   -- Scopes vars are defined
    , currentScope = emptyScope
    , main = ""
    , logger = ""
  }

-- Our Semantic Monad
type Semantic a = State SemState a
