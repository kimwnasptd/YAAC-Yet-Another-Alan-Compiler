{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module CodegenUtilities where

import Data.Word
import Data.String
import Data.List
import Data.Function
import qualified Data.ByteString.Short as BS (toShort, fromShort)
import qualified Data.ByteString.Char8 as BS8 (pack, unpack)
import qualified Data.Map as Map

import Control.Monad.State
import Control.Applicative

import SymbolTableTypes

import LLVM.AST
import LLVM.AST.Global
import LLVM.Prelude
import LLVM.AST.Type
import qualified LLVM.AST as AST

import qualified LLVM.AST.Linkage as L
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Attribute as A
import qualified LLVM.AST.CallingConvention as CC
import qualified LLVM.AST.FloatingPointPredicate as FP


---------------------------------------------------------------------------------
-- Types and Operands
-------------------------------------------------------------------------------

-- IEEE 754 double
-- double :: Type
-- double = FloatingPointType DoubleFP

funct :: Type
funct = FunctionType i32 [] False

int :: Type
int = i32

toInt :: Int -> Operand
toInt int = cons $ C.Int 32 (toInteger int)

one :: Operand
one = cons $ C.Int 32 1

zero :: Operand
zero = cons $ C.Int 32 0

false :: Operand
false = zero

true :: Operand
true = one

-------------------------------------------------------------------------------
-- Module Level
-------------------------------------------------------------------------------

addDefn :: Definition -> Codegen ()
addDefn d = do
  defs <- gets definitions
  modify $ \s -> s { definitions = defs ++ [d] }

define ::  Type -> String -> [(Type, Name)] -> [BasicBlock] -> Codegen ()
define retty label argtys body = addDefn $
  GlobalDefinition $ functionDefaults {
    name        = Name $ toShort label
  , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
  , returnType  = retty
  , basicBlocks = body
  }

external ::  Type -> String -> [(Type, Name)] -> Codegen ()
external retty label argtys = addDefn $
  GlobalDefinition $ functionDefaults {
    name        = Name $ toShort label
  , linkage     = L.External
  , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
  , returnType  = retty
  , basicBlocks = []
  }


-------------------------------------------------------------------------------
-- Names
-------------------------------------------------------------------------------

uniqueName :: String -> Names -> (String, Names)
uniqueName nm ns =
  case Map.lookup nm ns of
    Nothing -> (nm,  Map.insert nm 1 ns)
    Just ix -> (nm ++ show ix, Map.insert nm (ix+1) ns)


-------------------------------------------------------------------------------
-- Codegen Operations
-------------------------------------------------------------------------------

sortBlocks :: [(Name, BlockState)] -> [(Name, BlockState)]
sortBlocks = sortBy (compare `on` (idx . snd))

createBlocks :: Scope -> [BasicBlock]
createBlocks m = map makeBlock $ sortBlocks $ Map.toList (blocks m)

makeBlock :: (Name, BlockState) -> BasicBlock
makeBlock (l, (BlockState _ s t)) = BasicBlock l (reverse s) (maketerm t)
  where
    maketerm (Just x) = x
    maketerm Nothing = error $ "Block has no terminator: " ++ (show l)

fresh :: Codegen Word
fresh = do
  i <- gets $ count . currentScope
  modify $ \s -> s { currentScope = (currentScope s) { count = 1 + i } }
  return $ i + 1

instr :: Instruction -> Codegen (Operand)
instr ins = do
  n <- fresh
  let ref = (UnName n)
  blk <- current
  let i = stack blk
  modifyBlock (blk { stack = (ref := ins) : i } )
  return $ local ref

instr_unnamed :: Instruction -> Codegen (Operand)
instr_unnamed ins = do
  n <- fresh
  let ref = (UnName n)
  blk <- current
  let i = stack blk
  modifyBlock (blk { stack = (Do ins) : i } )
  return $ local ref

terminator :: Named Terminator -> Codegen (Named Terminator)
terminator trm = do
  blk <- current
  modifyBlock (blk { term = Just trm })
  return trm

-------------------------------------------------------------------------------
-- Block Stack
-------------------------------------------------------------------------------

entry :: Codegen Name
entry = gets $ currentBlock . currentScope

addBlock :: String -> Codegen Name
addBlock bname = do
  bls <- gets $ blocks . currentScope
  ix  <- gets $ blockCount . currentScope
  nms <- gets names

  let new = emptyBlock ix
      (qname, supply) = uniqueName bname nms

  modify $ \s -> s { currentScope = (currentScope s) {
                          blocks = Map.insert (Name $ toShort qname) new bls
                        , blockCount = ix + 1 }
                   , names = supply
                   }
  return (Name $ toShort qname)

setBlock :: Name -> Codegen Name
setBlock bname = do
  modify $ \s -> s { currentScope = (currentScope s) { currentBlock = bname } }
  return bname

getBlock :: Codegen Name
getBlock = gets $ currentBlock . currentScope

modifyBlock :: BlockState -> Codegen ()
modifyBlock new = do
  active <- gets $ currentBlock . currentScope
  modify $ \s -> s { currentScope = (currentScope s) {
    blocks = Map.insert active new (blocks . currentScope $ s) } }

current :: Codegen BlockState
current = do
  c <- gets $ currentBlock . currentScope
  blks <- gets $ blocks . currentScope
  case c `Map.lookup` blks of
    Just x -> return x
    Nothing -> error $ "No such block: " ++ show c

-------------------------------------------------------------------------------

-- References
local ::  Name -> Operand
local = LocalReference i32

global ::  Name -> C.Constant
global = C.GlobalReference i32

externf :: Name -> Operand
externf = ConstantOperand . C.GlobalReference i32

-- Arithmetic and Constants
add :: Operand -> Operand -> Codegen Operand
add a b = instr $ Add True True a b []

sub :: Operand -> Operand -> Codegen Operand
sub a b = instr $ Sub True True a b []

mul :: Operand -> Operand -> Codegen Operand
mul a b = instr $ Mul True True a b []

udiv :: Operand -> Operand -> Codegen Operand
udiv a b = instr $ UDiv True a b []

cmp :: FP.FloatingPointPredicate -> Operand -> Operand -> Codegen Operand
cmp cond a b = instr $ FCmp cond a b []

cons :: C.Constant -> Operand
cons = ConstantOperand

uitofp :: Type -> Operand -> Codegen Operand
uitofp ty a = instr $ UIToFP a ty []

toArgs :: [Operand] -> [(Operand, [A.ParameterAttribute])]
toArgs = map (\x -> (x, []))

-- Effects
call :: Operand -> [Operand] -> Codegen Operand
call fn args = instr $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []

alloca :: Type -> Codegen Operand
alloca ty = instr $ Alloca ty Nothing 0 []

store :: Operand -> Operand -> Codegen Operand
store ptr val = instr_unnamed $ Store False ptr val Nothing 0 []   -- We can find a better name

load :: Operand -> Codegen Operand
load ptr = instr $ Load False ptr Nothing 0 []

-- Control Flow
br :: Name -> Codegen (Named Terminator)
br val = terminator $ Do $ Br val []

cbr :: Operand -> Name -> Name -> Codegen (Named Terminator)
cbr cond tr fl = terminator $ Do $ CondBr cond tr fl []

phi :: Type -> [(Operand, Name)] -> Codegen Operand
phi ty incoming = instr $ Phi ty incoming []

ret_val :: Operand -> Codegen (Named Terminator)
ret_val val = terminator $ Do $ Ret (Just val) []

ret :: Codegen (Named Terminator)
ret = terminator $ Do $ Ret Nothing []
