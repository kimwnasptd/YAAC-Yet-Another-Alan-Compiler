{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module SymbolTableTypes where

import Control.Monad.State
import Control.Monad
import qualified Data.Map as Map
import qualified Data.ByteString.Short as BS (toShort, fromShort)
import qualified Data.ByteString.Char8 as BS8 (pack, unpack)

import LLVM.AST
import LLVM.AST.Global
import LLVM.Prelude
import LLVM.AST.Type
import qualified LLVM.AST as AST

-------------------------------------------------------------------------------
-- String Conversions
-------------------------------------------------------------------------------
toShort :: String -> ShortByteString
toShort s = BS.toShort $ BS8.pack s

toString :: ShortByteString -> String
toString bs = BS8.unpack $ BS.fromShort bs

-------------------------------------------------------------------------------
-- Types and Data Declerations
-------------------------------------------------------------------------------
type Names = Map.Map String Int
type SymbolTable = Map.Map SymbolName [Scope]
type SymbolName = String
data SymbolType = IntType | ByteType | ProcType -- Fun Types
                | TableIntType | TableByteType  -- + Var Types
    deriving (Show, Eq)

data VarInfo = VarInfo {
      var_name    :: SymbolName              -- the variable name
    , var_type    :: SymbolType
    , var_operand :: Maybe Operand           -- AST.Operand
    , id_num      :: Int               -- we'll probably need this field later
    , dimension   :: Maybe Int         -- its dimensions, if it's a table NOTE: It's nothing, if we arent' a table
    , byreference :: Bool              -- if it was passed by reference (if it is a function arg)
  }
  deriving Show

data FunInfo = FunInfo {
      fn_name        :: SymbolName
    , result_type    :: SymbolType
    , fun_operand    :: Maybe Operand
    , args           :: [(SymbolName,SymbolType,Bool,Bool)] -- (name, type, ref, table)
    , forward_dec    :: Bool
  }
  deriving Show

data Symbol = V VarInfo
            | F FunInfo
            deriving Show

data Scope = Scope {
      scp_name        :: String
    , symbols         :: Map.Map SymbolName Symbol     -- args and local vars go here
    , currentBlock    :: Name    -- AST.Name
    , blocks          :: Map.Map Name BlockState
    , blockCount      :: Int
    , count           :: Word -- Count of unnamed instructions
    , parent_scope    :: Maybe Scope  -- Used when we close a scope
  }
  deriving Show

-- Monad Code
data CodegenState = CodegenState {
      symbolTable   :: SymbolTable
    , currentScope  :: Scope   -- > We always keep the current scope close to our chest.
    , names         :: Names
    , definitions   :: [Definition]
    , mainfn        :: String  -- we need the name of the main function
    , logger        :: String
  }
  deriving Show

data BlockState = BlockState {
      idx   :: Int                            -- Block index
    , stack :: [Named Instruction]            -- Stack of instructions
    , term  :: Maybe (Named Terminator)       -- Block terminator
} deriving Show

-- Inital Values
emptyScope :: Scope
emptyScope = Scope {
        scp_name = ""
      , symbols = Map.empty
      , currentBlock = (Name $ toShort entryBlockName)
      , blocks = Map.empty
      , blockCount = 1
      , count = 0
      , parent_scope = Nothing    -- Genesis Scope doesn't have a parent
  }

entryBlockName :: String
entryBlockName = "entry"

emptyBlock :: Int -> BlockState
emptyBlock i = BlockState i [] Nothing

emptyCodegen :: CodegenState
emptyCodegen = CodegenState {
      symbolTable = Map.empty
    , currentScope = emptyScope
    , names = Map.empty
    , definitions = []
    , mainfn = ""
    , logger = ""
}

newtype Codegen a = Codegen { runCodegen :: State CodegenState a }
    deriving (Functor, Applicative, Monad, MonadState CodegenState )

execCodegen :: Codegen a -> CodegenState
execCodegen m = execState (runCodegen m) emptyCodegen

-------------------------------------------------------------------------------
-- AST Module Level
-------------------------------------------------------------------------------
newtype LLVM a = LLVM (State AST.Module a)
  deriving (Functor, Applicative, Monad, MonadState AST.Module )

runLLVM :: AST.Module -> LLVM a -> AST.Module
runLLVM mod (LLVM m) = execState m mod

emptyModule :: String -> AST.Module
emptyModule label = defaultModule { moduleName = toShort label }
