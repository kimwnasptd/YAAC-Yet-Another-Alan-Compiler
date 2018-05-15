module SymbolTableTypes where

import Control.Monad.State
import Control.Monad
import qualified Data.HashMap.Strict as Map


type ScopeID = Int

type SymbolTable = Map.HashMap Name [Scope]    -- NOTE: I am sorry, but I can not go on unless we change this
type SymbolTable_Frontend = Map.HashMap Name [Name ]    -- Tells us in which scope to search
-- it takes us from VARIABLE NAME _>  [ SCOPE NAME ] (the same variable may be in a list of scopes )
type SymbolTable_Backend = Map.HashMap Name Scope
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


data Scope = Scope {
      scope_id        :: ScopeID
    , scp_name        :: Name
    , vars            :: Map.HashMap Name VarInfo     -- args and local vars go here
    , funs            :: Map.HashMap Name FunInfo     -- funcs go here
    , parent_scope    :: Maybe Scope  -- Used when we close a scope
  }
  deriving Show


-- Monad Code
data SemState = SemState {
    -- symbolTable :: SymbolTable
      symbol_fend   :: SymbolTable_Frontend
    , symbol_bend   :: SymbolTable_Backend
    , currentScope  :: Scope   -- > We always keep the current scope close to our chest.
    , counter       :: Int
    , logger        :: String
  }
  deriving Show

emptyScope :: Scope
emptyScope = Scope {
        scope_id = 0  -- I think we won't need this. Yeah yeah
      , scp_name = ""
      , vars = Map.empty
      , funs = Map.empty
      , parent_scope = Nothing    -- Genesis Scope doesn't have a parent
  }

initialSemState :: SemState
initialSemState = SemState {
      symbol_fend = Map.empty
    , symbol_bend = Map.empty
    , currentScope = emptyScope
    , counter = 1   -- We might also not need this
    , logger = ""
  }

-- Our Semantic Monad
type P a = State SemState a
