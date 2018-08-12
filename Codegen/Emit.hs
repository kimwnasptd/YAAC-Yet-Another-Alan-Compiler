{-# LANGUAGE OverloadedStrings #-}

module Emit where

import LLVM.AST
import LLVM.Module
import LLVM.Context
import LLVM.Prelude
import LLVM.AST.Type

import qualified LLVM.AST as AST
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Float as F
import qualified LLVM.AST.FloatingPointPredicate as FP

import Data.Word
import Data.Int
import Control.Monad.Except
import Control.Applicative
import Control.Monad.State
import Control.Monad
import qualified Data.ByteString.Char8 as BS8 (pack, unpack)
import qualified Data.Map as Map

-- import Codegen
import qualified ASTTypes as S
import SymbolTableTypes
import SemanticFunctions
import CodegenUtilities

-- TODO: for compilation sake every var is int. We need to change this
toSig :: [S.FPar_Def] -> [(AST.Type, AST.Name)]
toSig ( (S.FPar_Def_Ref name tp) : args ) =
    (i32, AST.Name $ toShort name) : toSig args
toSig ( (S.FPar_Def_NR name tp) : args ) =
    (i32, AST.Name $ toShort name) : toSig args
toSig [] = []


-- TODO: We also need to handle ldefs (symtable ...)
codegenTop :: S.Program -> LLVM ()
codegenTop main = do
    let defs = definitions $ execCodegen (ast_sem main)
    modify $ \s -> s { moduleDefinitions = defs }
  -- define i32 name fnargs bls
  -- where
  --   fnargs = toSig args
  --   bls = createBlocks $ execCodegen $ do
  --     entry <- addBlock entryBlockName
  --     setBlock entry
  --     forM args cgen_farg
  --     cgen body

-- -- NOTE: This probably won't change as the args will always be local vars
-- cgen_farg :: S.FPar_Def -> Codegen ()
-- cgen_farg (S.FPar_Def_Ref name tp) = do
--     var <- alloca i32
--     store var (local (AST.Name $ toShort name))
--     assign name var
-- cgen_farg (S.FPar_Def_NR name tp) = do
--     var <- alloca i32
--     store var (local (AST.Name $ toShort name))
--     assign name var
--
-- cgen :: [S.Stmt] -> Codegen [()]
-- cgen = mapM cgen_stmt
--
-- -- TODO: FCall, If, IFE, While
-- cgen_stmt :: S.Stmt -> Codegen ()
-- cgen_stmt S.Stmt_Ret = ret >> return ()
-- cgen_stmt S.Stmt_Semi = return ()
-- cgen_stmt (S.Stmt_Ret_Expr e1) = cgen_expr e1 >>= ret_val >> return ()
-- cgen_stmt (S.Stmt_Cmp (S.C_Stmt stmts)) = cgen stmts >> return ()
-- cgen_stmt (S.Stmt_Eq lval expr) = do
--     var <- cgen_lval lval
--     val <- cgen_expr expr
--     store var val
--     return ()
-- cgen_stmt stmt = return ()      -- This must be removed in the end
--
-- -- TODO: Arrays
-- cgen_lval :: S.L_Value -> Codegen AST.Operand
-- cgen_lval (S.LV_Var var) = getvar var >>= load
-- cgen_lval lval = return one     -- This must be removed in the end
--
-- -- TODO: Pos, Neg, FCall, ExprChar
-- cgen_expr :: S.Expr -> Codegen AST.Operand
-- cgen_expr (S.Expr_Brack exp) = cgen_expr exp
-- cgen_expr (S.Expr_Lval lval) = cgen_lval lval
-- cgen_expr (S.Expr_Int int) = return $ toInt int
-- cgen_expr (S.Expr_Add e1 e2) = do
--     ce1 <- cgen_expr e1
--     ce2 <- cgen_expr e2
--     add ce1 ce2
-- cgen_expr (S.Expr_Sub e1 e2) = do
--     ce1 <- cgen_expr e1
--     ce2 <- cgen_expr e2
--     sub ce1 ce2
-- cgen_expr (S.Expr_Tms e1 e2) = do
--     ce1 <- cgen_expr e1
--     ce2 <- cgen_expr e2
--     mul ce1 ce2
-- cgen_expr (S.Expr_Div e1 e2) = do
--     ce1 <- cgen_expr e1
--     ce2 <- cgen_expr e2
--     udiv ce1 ce2
-- cgen_expr exp = do
--     return one

-------------------------------------------------------------------------------
-- Operations
-------------------------------------------------------------------------------

-- lt :: AST.Operand -> AST.Operand -> Codegen AST.Operand
-- lt a b = do
--   test <- fcmp FP.ULT a b
--   uitofp double test


-------------------------------------------------------------------------------
-- Compilation
-------------------------------------------------------------------------------

codegen :: AST.Module -> S.Program -> IO AST.Module
codegen mod main = withContext $ \context ->
  withModuleFromAST context newast $ \m -> do
    llstr <- moduleLLVMAssembly m
    putStrLn $ BS8.unpack llstr  -- Convert ByteString -> String
    return newast
  where
    modn    = codegenTop main
    newast  = runLLVM mod modn
