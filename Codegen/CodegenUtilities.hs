{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module CodegenUtilities where

import Data.Char
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
import LLVM.AST.IntegerPredicate as IPRD
import qualified LLVM.AST.Type as TP
import qualified LLVM.AST as AST

import qualified LLVM.AST.Linkage as L
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Attribute as A
import qualified LLVM.AST.Global as G
import qualified LLVM.AST.CallingConvention as CC
import qualified LLVM.AST.FloatingPointPredicate as FP
import qualified LLVM.AST.AddrSpace as AP

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

toByte :: Int -> Operand
toByte int = cons $ C.Int 8 (toInteger int)

toChar :: Char -> Operand
toChar c = cons $ C.Int 8 (toInteger $ ord $ c)

one :: Operand
one = cons $ C.Int 32 1

zero :: Operand
zero = cons $ C.Int 32 0

false :: Operand
false = cons $ C.Int 1 0

true :: Operand
true = cons $ C.Int 1 1

-- This is used mainly in args, since arrays must be of type Pointer
-- since we don't know it's dimension.
type_to_ast :: SymbolType -> AST.Type
type_to_ast IntType = i32
type_to_ast ByteType = i8
type_to_ast ProcType = TP.void
type_to_ast TableIntType = ptr i32
type_to_ast TableByteType = ptr i8

-- If a var is ref, then its AST.Type will be ptr
to_type :: SymbolType -> Bool -> AST.Type
to_type IntType  True = ptr i32
to_type ByteType True = ptr i8
to_type tp _ = type_to_ast tp

-- When defining a var, we need to get the array type also
symb_to_astp :: Symbol -> AST.Type
symb_to_astp (V var) =
    case (dimension var) of
        Nothing  -> type_to_ast (var_type var)
        Just dim -> case (var_type var) of
                        -- TableIntType -> ArrayType 5 i32
                        -- TableByteType -> ArrayType 5 i8
                        TableIntType -> ArrayType (fromIntegral dim) i32
                        TableByteType -> ArrayType (fromIntegral dim) i8
                        _            -> type_to_ast (var_type var)
symb_to_astp (F fn) = type_to_ast (result_type fn)

str_type :: String -> Type
str_type str = ArrayType (n+1) i8
    where n = fromIntegral $ length str

toSig :: [(SymbolName,SymbolType,Bool,Bool)] -> [(AST.Type, AST.Name)]
toSig args = map convert args
    where convert (name, tp, ref, _) = (to_type tp ref, AST.Name $ toShort name)
-------------------------------------------------------------------------------
-- Module Level
-------------------------------------------------------------------------------

define ::  Global -> Codegen ()
define glob = addDefn $ GlobalDefinition glob

addDefn :: Definition -> Codegen ()
addDefn d = do
  defs <- gets definitions
  modify $ \s -> s { definitions = defs ++ [d] }

globalFun :: Type -> String -> [(Type, Name)] -> [BasicBlock] -> Global
globalFun retty label argtys body = functionDefaults {
    name        = Name $ toShort label
  , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
  , returnType  = retty
  , basicBlocks = body
  }

externalFun ::  Type -> String -> [(Type, Name)] -> Bool -> Global
externalFun retty label argtys varargs = functionDefaults {
    name        = Name $ toShort label
  , linkage     = L.External
  , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], varargs)
  , returnType  = retty
  , basicBlocks = []
  }

-- Only global vars are Strings
globalStr :: String -> String -> Global
globalStr label str = globalVariableDefaults {
    name        = Name $ toShort label
  , G.type'       = ArrayType (n+1) i8
  , linkage     = L.Private
  , unnamedAddr = Just GlobalAddr
  , isConstant  = True
  , initializer = Just $ C.Array i8 chars
  }
  where n = fromIntegral $ length str
        chars = [consChar c | c <- str] ++ [consInt 0]
        consChar c = C.Int 8 (toInteger $ ord c)
        consInt  n = C.Int 8 (toInteger n)

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

-- Same thought process as the original Makeblock right above, with one difference
-- If a block has no terminator, but also has no instructions, then the block is a dud
-- and we never create it
-- How could a block like that have been created?
-- eg it was the if.exit block of a if-then-else statement,
-- but the function was returning on both the if and the else case!
-- makeBlock_filtered :: (Name, BlockState) -> Maybe BasicBlock   -- IF A BLOCK IS A DUD, DO NOT CREATE IT
-- makeBlock_filtered (l, (BlockState _ [] Nothing)) = Nothing
-- makeBlock_filtered (l, (BlockState _ s Nothing)) = error $ "ACTUAL Block has no terminator: " ++ (show l)
-- makeBlock_filtered (l, (BlockState _ s (Just t))) = Just $ BasicBlock l (reverse s) (t)
--
-- createBlocks_filtered :: Scope -> [Maybe BasicBlock]  -- a list of blocks and Nothing where a block was a dud
-- createBlocks_filtered m = map makeBlock_filtered $ sortBlocks $ Map.toList (blocks m)
--
-- createBlocks :: Scope -> [BasicBlock]
-- createBlocks m = map maketerm $ filter (\x -> x /= Nothing )$ createBlocks_filtered m
    -- where
        -- maketerm (Just x ) = x

fresh :: Codegen Word
fresh = do
  i <- gets $ count . currentScope
  modify $ \s -> s { currentScope = (currentScope s) { count = 1 + i } }
  return $ i + 1

freshStr :: Codegen String
freshStr = do
    n <- fresh
    (Name bname) <- getBlock
    return $ "str." ++ (toString bname) ++ "." ++ (show n)

-- write a string to an array
initString :: String -> Codegen Operand
initString str = do
    let val = cons $ C.Array i8 chars
        n = fromIntegral $ length str
    var <- alloca (ArrayType (n+1) i8)
    store var val
    bitcast var (ptr i8)
    where chars = [consChar c | c <- str] ++ [consInt 0]
          consChar c = C.Int 8 (toInteger $ ord $ c)
          consInt  n = C.Int 8 (toInteger n)

-- Default values for operands
initOperand :: SymbolType -> Maybe Int -> Codegen Operand
initOperand IntType _ = return zero
initOperand ByteType _ = return $ cons $ C.Int 8 0
initOperand ProcType _ = return zero
initOperand TableIntType  (Just dim) = return $ cons $ C.Array i32 [C.Int 32 0 | _ <- [1..dim]]
initOperand TableByteType (Just dim) = return $ cons $ C.Array i8  [C.Int  8 0 | _ <- [1..dim]]
initOperand _ _ = return zero

operand :: Symbol -> Codegen Operand
operand (F fn)  = case fun_operand fn of
    Nothing -> error $ "No Operand for " ++ (fn_name fn)
    Just op -> return op
operand (V var) = case var_operand var of
    Nothing -> error $ "No Operand for " ++ (var_name var)
    Just op -> return op

currvars :: Codegen [VarInfo]
currvars = do
    syms <- gets $ symbols . currentScope
    return $ keepvars (Map.elems syms)
    where keepvars ((V var):syms) = var : (keepvars syms)
          keepvars ((F fun):syms) = keepvars syms
          keepvars [] = []

currfuns :: Codegen [FunInfo]
currfuns = do
    syms <- gets $ symbols . currentScope
    return $ keepfns (Map.elems syms)
    where keepfns ((V var):syms) = keepfns syms
          keepfns ((F fun):syms) = fun : (keepfns syms)
          keepfns [] = []

addVarOpperand :: VarInfo -> Codegen VarInfo
addVarOpperand var_info = do
    let tp = var_type var_info
        dim = dimension var_info
        nm = var_name var_info
    init_val <- initOperand tp dim
    var <- allocavar (symb_to_astp (V var_info)) nm
    store var init_val
    case tp of
        TableIntType  -> do
            pointer_int <-  bitcast var (ptr i32)
            return $ var_info { var_operand = Just pointer_int }
        TableByteType -> do
            pointer_byte <- bitcast var (ptr i8)
            return $ var_info { var_operand = Just pointer_byte }
        _             -> return $ var_info { var_operand = Just var }

addArgOpperand :: VarInfo -> Codegen VarInfo
addArgOpperand arg = do
    let tp = var_type arg
        nm = var_name arg
        ref = byreference arg
    var <- allocavar (to_type tp ref) nm
    store var (local (AST.Name $ toShort nm))
    case byreference arg of
        True -> do
            ref_op <- load var
            return $ arg { var_operand = Just ref_op}
        False -> return $ arg { var_operand = Just var}

-- Creates the operand for a function
addFunOperand :: FunInfo -> Codegen FunInfo
addFunOperand foo_info = do
    return $ foo_info { fun_operand = Just fn_op } where
        fn_op = externf sorted_name typed_res arg_types varg
        name = fn_name foo_info
        varg = varargs foo_info
        result = result_type foo_info
        args = fn_args foo_info
        sorted_name = (AST.Name $ toShort name)
        typed_res = type_to_ast result
        arg_types = [tp | (tp, _) <- toSig args]

instr_named :: Instruction -> String -> Codegen (Operand)
instr_named ins nm = do
    n <- fresh
    let ref = Name $ toShort $ nm ++ "."  ++ (show n)
    blk <- current
    let i = stack blk
    modifyBlock (blk { stack = (ref := ins) : i } )
    return $ local ref

instr :: Instruction -> Codegen (Operand)
instr ins = do
    n <- fresh
    let ref = (UnName n)
    blk <- current
    let i = stack blk
    modifyBlock (blk { stack = (ref := ins) : i } )
    return $ local ref

cond_instr :: Instruction -> Codegen (Operand)
cond_instr ins = do
    n <- fresh
    let ref = (UnName n)
    blk <- current
    let i = stack blk
    modifyBlock (blk { stack = (ref := ins) : i } )
    return $ local_extended i1 ref

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

fndblock :: Name -> Codegen BlockState
fndblock blk = do
    blks <- gets $ blocks . currentScope
    case blk `Map.lookup` blks of
      Just x -> return x
      Nothing -> error $ "No such block: " ++ show blk

endblock :: FunInfo -> Codegen ()
endblock fun = do
    case result_type fun of
        ProcType -> ret >> return ()
        IntType  -> retval zero >> return ()
        ByteType -> retval (toByte 0) >> return ()
        _ -> error $ "Function not of type Int, Byte or Proc"

-------------------------------------------------------------------------------

-- References
local ::  Name -> Operand
local = LocalReference i32

global ::  Name -> C.Constant
global = C.GlobalReference i32

local_extended ::  Type -> Name ->  Operand
local_extended = LocalReference

externf :: Name -> Type -> [Type] -> Bool -> Operand
externf name tp op_list vararg = ConstantOperand $ C.GlobalReference (ptr fn_type ) name where
    fn_type = FunctionType tp op_list vararg

externstr :: Name -> Type -> Operand
externstr name tp = ConstantOperand $ C.GlobalReference (ptr tp) name

-- Arithmetic and Constants
add :: Operand -> Operand -> Codegen Operand
add a b = instr $ Add True True a b []

sub :: Operand -> Operand -> Codegen Operand
sub a b = instr $ Sub True True a b []

mul :: Operand -> Operand -> Codegen Operand
mul a b = instr $ Mul True True a b []

sdiv :: Operand -> Operand -> Codegen Operand
sdiv a b = instr $ SDiv True a b []

srem :: Operand -> Operand -> Codegen Operand
srem a b = instr $ SRem  a b []

-- cmp :: FP.FloatingPointPredicate -> Operand -> Operand -> Codegen Operand
-- cmp cond a b = instr $ FCmp cond a b []

cons :: C.Constant -> Operand
cons = ConstantOperand

uitofp :: Type -> Operand -> Codegen Operand
uitofp ty a = instr $ UIToFP a ty []

toArgs :: [Operand] -> [(Operand, [A.ParameterAttribute])]
toArgs = map (\x -> (x, []))

-- Effects
call :: Operand -> [Operand] -> Codegen Operand
call fn args = instr $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []

call_void :: Operand -> [Operand] -> Codegen Operand
call_void fn args = instr_unnamed $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []

alloca :: Type -> Codegen Operand
alloca ty = instr $ Alloca ty Nothing 0 []

allocavar :: Type -> String -> Codegen Operand
allocavar ty nm = instr_named (Alloca ty Nothing 0 []) nm

store :: Operand -> Operand -> Codegen Operand
store ptr val = instr_unnamed $ Store False ptr val Nothing 0 []   -- We can find a better name

load :: Operand -> Codegen Operand
load ptr = instr $ Load False ptr Nothing 0 []

create_ptr :: Operand -> [Operand] -> String -> Codegen Operand -- used for table indexing
create_ptr table indexes nm = instr_named (GetElementPtr False table indexes []) (nm++".elem")

bitcast :: Operand -> Type -> Codegen Operand
bitcast op tp = instr $ BitCast op tp []

-- Control Flow
-- watch out for return before the branch
br :: Name -> Codegen (Named Terminator)
br val = do
    curblk <- current
    case (term curblk) of
        Just trm -> return trm
        Nothing  -> terminator $ Do $ Br val []

cbr :: Operand -> Name -> Name -> Codegen (Named Terminator)
cbr cond tr fl = terminator $ Do $ CondBr cond tr fl []

phi :: Type -> [(Operand, Name)] -> Codegen Operand
phi ty incoming = instr $ Phi ty incoming []

retval :: Operand -> Codegen (Named Terminator)
retval val = terminator $ Do $ Ret (Just val) []

ret :: Codegen (Named Terminator)
ret = terminator $ Do $ Ret Nothing []

-- Comparison
cmp :: IPRD.IntegerPredicate -> Operand -> Operand -> Codegen Operand
cmp predicate op1 op2 = cond_instr  $ ICmp predicate op1 op2 []
--NOTE: just like Kimonas would have liked, one function for all comparisons

and_instr :: Operand -> Operand -> Codegen Operand
and_instr op1 op2 = cond_instr $ And op1 op2 []

or_instr :: Operand -> Operand -> Codegen Operand
or_instr op1 op2 = cond_instr $ Or op1 op2 []

bang :: Operand -> Codegen Operand
bang op1 = cond_instr $ Xor (op1) true []
