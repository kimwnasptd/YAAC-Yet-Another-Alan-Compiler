{-# LANGUAGE OverloadedStrings #-}

module Emit where

import LLVM.Module
import LLVM.Context
import LLVM.Prelude

import qualified LLVM.AST as AST
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Float as F
import qualified LLVM.AST.FloatingPointPredicate as FP

import Data.Word
import Data.Int
import Control.Monad.Except
import Control.Applicative
import qualified Data.ByteString.Char8 as BS8 (pack, unpack)
import qualified Data.Map as Map

import Codegen
import qualified ASTTypes as S


toSig :: [S.FPar_Def] -> [(AST.Type, AST.Name)]
toSig ( (S.FPar_Def_Ref name tp) : args ) =
    (double, AST.Name $ toShort name) : toSig args
toSig ( (S.FPar_Def_NR name tp) : args ) =
    (double, AST.Name $ toShort name) : toSig args
toSig [] = []

codegenTop :: S.Func_Def -> LLVM ()
codegenTop (S.F_Def name args retty ldefs body) = do
  define double name fnargs bls
  where
    fnargs = toSig args
    bls = createBlocks $ execCodegen $ do
      entry <- addBlock entryBlockName
      setBlock entry
      forM args cgen_farg
      ret

cgen_farg :: S.FPar_Def -> Codegen ()
cgen_farg (S.FPar_Def_Ref name tp) = do
    var <- alloca double
    store var (local (AST.Name $ toShort name))
    assign name var
cgen_farg (S.FPar_Def_NR name tp) = do
    var <- alloca double
    store var (local (AST.Name $ toShort name))
    assign name var

-- cgen :: [S.Stmt] -> Codegen ()
-- cgen =
--
-- cgen_stmt :: S.Stmt -> Codegen AST.Operand
-- cgen_stmt S.Stmt_Ret = ret

-------------------------------------------------------------------------------
-- Operations
-------------------------------------------------------------------------------

lt :: AST.Operand -> AST.Operand -> Codegen AST.Operand
lt a b = do
  test <- fcmp FP.ULT a b
  uitofp double test

binops = Map.fromList [
      ("+", fadd)
    , ("-", fsub)
    , ("*", fmul)
    , ("/", fdiv)
    , ("<", lt)
  ]

-------------------------------------------------------------------------------
-- Compilation
-------------------------------------------------------------------------------

codegen :: AST.Module -> S.Program -> IO AST.Module
codegen mod (S.Prog main ) = withContext $ \context ->
  withModuleFromAST context newast $ \m -> do
    llstr <- moduleLLVMAssembly m
    putStrLn $ BS8.unpack llstr  -- Convert ByteString -> String
    return newast
  where
    modn    = codegenTop main
    newast  = runLLVM mod modn
