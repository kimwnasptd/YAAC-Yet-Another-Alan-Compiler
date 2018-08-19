{-# LANGUAGE OverloadedStrings #-}

module Emit where

import LLVM.AST
import LLVM.Module
import LLVM.Context
import LLVM.Prelude
import LLVM.AST.Type
import LLVM.PassManager
import LLVM.Analysis

import qualified LLVM.AST.IntegerPredicate as IPRD
import qualified LLVM.AST as AST
import qualified LLVM.AST.Constant as C
import qualified LLVM.AST.Float as F
import qualified LLVM.AST.FloatingPointPredicate as FP

import Data.Char
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
import LibraryFunctions

-------------------------------------------------------------------------------
-- Compilation
-------------------------------------------------------------------------------

passes :: PassSetSpec   -- the optimizations we want to run
passes = defaultCuratedPassSetSpec { optLevel = Just 0 }

codegen :: AST.Module -> S.Program -> IO AST.Module
codegen mod main = withContext $ \context ->
    withModuleFromAST context newast $ \m -> do
        withPassManager passes $ \pm -> do
            runPassManager pm m
            llstr <- moduleLLVMAssembly m
            verify m
            putStrLn $ BS8.unpack llstr  -- Convert ByteString -> String
            return newast
  where
    modn    = codegenTop main
    newast  = runLLVM mod modn

codegenTop :: S.Program -> LLVM ()
codegenTop main = do
    let codegen = execCodegen (cgen_ast main)
        defs = definitions codegen
        log = logger codegen
    modify $ \s -> s { moduleDefinitions = defs }

-------------------------------------------------------------------------------
-- Codegeneration Functions
-------------------------------------------------------------------------------

cgen_ast :: S.Program -> Codegen String
cgen_ast (S.Prog main) = do
    initMain main    -- > set the name of the main function in our codegenstate
    addLibraryFns lib_fns
    cgenFuncDef main -- > codegen the function
    gets logger >>= return  -- > return the logger of our codegeneration

cgenFuncDef :: S.Func_Def -> Codegen ()
cgenFuncDef (S.F_Def name args_lst f_type ldef_list cmp_stmt) = do
    addFunc name args_lst f_type      -- > we add the function to our CURRENT scope
    openScope name                    -- > every function creates a new scope
    entry <- addBlock entryBlockName
    setBlock entry
    addFArgs args_lst                 -- > add parameters to symtable
    addFunc name args_lst f_type      -- > NOTE: add the function to the inside scope as well ?
    addLDefLst ldef_list              -- > add the local definitions of that function, this is where the recursion happens
    semStmtList cmp_stmt              -- > do the Semantic analysis of the function body
    cgen_stmts cmp_stmt
    closeScope                        -- > close the function' s scope

cgen_stmts :: S.Comp_Stmt -> Codegen [()]
cgen_stmts (S.C_Stmt stmts) = mapM cgen_stmt stmts
-- cgen_stmts (S.C_Stmt stmts) = forM stmts cgen_stmt   -- because we like playing with monads...

-- TODO: FCall, If, IFE, While
cgen_stmt :: S.Stmt -> Codegen ()
cgen_stmt S.Stmt_Ret = ret >> return ()
cgen_stmt S.Stmt_Semi = return ()
cgen_stmt (S.Stmt_Ret_Expr e1) = cgen_expr e1 >>= ret_val >> return ()
cgen_stmt (S.Stmt_Cmp cmp_stmt) = cgen_stmts cmp_stmt >> return ()
cgen_stmt (S.Stmt_Eq lval expr) = do
    var <- cgen_lval lval
    val <- cgen_expr expr
    store var val
    return ()
cgen_stmt (S.Stmt_FCall (S.Func_Call fn args)) = do
    F fun_info <- getSymbol fn
    refs <- forM (fn_args fun_info) (\(_,_,ref,_) -> return ref)
    arg_operands <- mapM cgen_arg (zip args refs)
    foo_operand <- getfun fn
    call_unnamed foo_operand arg_operands
    return ()
--
cgen_stmt (S.Stmt_IFE cond if_stmt else_stmt) = do
    ifthen <- addBlock "if.then"
    ifelse <- addBlock "if.else"
    ifexit <- addBlock "if.exit" -- create the 3 blocks.
        -- ENTRY
    cond_op <- cgen_cond cond    -- generate a 1-bit condition
    cbr cond_op ifthen ifelse    -- branch based on condition
        -- ifthen part
        --------------
    setBlock ifthen             -- now instructions are added to the ifthen block
    cgen_stmt if_stmt           -- fill the block with the proper instructions
    br ifexit                   -- merge the block. NOTE: Fallthrough is not allowed!
    ifthen <- getBlock          -- get back the block for the phi node
        -- ifelse part
        --------------
    setBlock ifelse
    cgen_stmt else_stmt
    br ifexit
    ifelse <- getBlock
        -- exit part
        ------------
    setBlock ifexit
    return () 


cgen_stmt stmt = return ()      -- This must be removed in the end

cgen_expr :: S.Expr -> Codegen AST.Operand
cgen_expr (S.Expr_Brack exp) = cgen_expr exp
cgen_expr (S.Expr_Lval lval) = cgen_lval lval >>= load
cgen_expr (S.Expr_Int int) = return $ toInt int
cgen_expr (S.Expr_Add e1 e2) = do
    ce1 <- cgen_expr e1
    ce2 <- cgen_expr e2
    add ce1 ce2
cgen_expr (S.Expr_Sub e1 e2) = do
    ce1 <- cgen_expr e1
    ce2 <- cgen_expr e2
    sub ce1 ce2
cgen_expr (S.Expr_Tms e1 e2) = do
    ce1 <- cgen_expr e1
    ce2 <- cgen_expr e2
    mul ce1 ce2
cgen_expr (S.Expr_Div e1 e2) = do
    ce1 <- cgen_expr e1
    ce2 <- cgen_expr e2
    sdiv ce1 ce2
cgen_expr (S.Expr_Mod e1 e2) = do
    ce1 <- cgen_expr e1
    ce2 <- cgen_expr e2
    srem ce1 ce2
cgen_expr (S.Expr_Fcall (S.Func_Call fn args ) ) = do
    F fun_info <- getSymbol fn
    refs <- forM (fn_args fun_info) (\(_,_,ref,_) -> return ref)
    arg_operands <- mapM cgen_arg (zip args refs)
    foo_operand <- getfun fn
    call foo_operand arg_operands
cgen_expr (S.Expr_Char ch_str) = do
    return $ toChar (head ch_str)
cgen_expr (S.Expr_Pos expr ) = cgen_expr expr
cgen_expr(S.Expr_Neg expr ) = do
    ce <- cgen_expr expr
    sub zero ce


cgen_cond :: S.Cond -> Codegen AST.Operand
cgen_cond (S.Cond_Eq left right ) = do
    left_op  <- cgen_expr left    -- generate the left operand
    right_op <- cgen_expr right   -- generate the right operand
    cmp IPRD.EQ left_op right_op  -- compare them accordingly
cgen_cond (S.Cond_Neq left right ) = do
    left_op  <- cgen_expr left
    right_op <- cgen_expr right
    cmp IPRD.NE left_op right_op
cgen_cond (S.Cond_G left right ) = do
    left_op  <- cgen_expr left
    right_op <- cgen_expr right
    cmp IPRD.SGT left_op right_op
cgen_cond (S.Cond_L left right ) = do
    left_op  <- cgen_expr left
    right_op <- cgen_expr right
    cmp IPRD.SLT left_op right_op
cgen_cond (S.Cond_GE left right ) = do
    left_op  <- cgen_expr left
    right_op <- cgen_expr right
    cmp IPRD.SGE left_op right_op
cgen_cond (S.Cond_LE left right ) = do
    left_op  <- cgen_expr left
    right_op <- cgen_expr right
    cmp IPRD.SLE left_op right_op
cgen_cond (S.Cond_True) = return true
cgen_cond (S.Cond_False) = return false
cgen_cond (S.Cond_Br br) = cgen_cond br -- just generate the inner condition
cgen_cond (S.Cond_And first second ) = do
    fst_op <- cgen_cond first       -- generate the left condition
    snd_op <- cgen_cond second      -- generate the right condition
    and_instr fst_op snd_op       -- logical AND them
cgen_cond (S.Cond_Or first second ) = do
    fst_op <- cgen_cond first
    snd_op <- cgen_cond second
    or_instr fst_op snd_op
cgen_cond (S.Cond_Bang arg ) = do
    op <- cgen_cond arg     -- generate the 1 bit boolean inside condition
    bang  op                -- reverse it
-- cgen_cond _ = return true   -- NOTE: For sanity checking, should return redundant



-- cgen_lval always returns an address operand
cgen_lval :: S.L_Value -> Codegen AST.Operand
cgen_lval (S.LV_Var var) = getvar var
cgen_lval (S.LV_Tbl tbl_var offset_expr) = do
    offset <- cgen_expr offset_expr   --generate the expression for the offset
    tbl_operand <- getvar tbl_var     -- get the table operand
    create_ptr tbl_operand [offset]
cgen_lval (S.LV_Lit str) = initString str

-- If an array without brackets we need to pass the pointer to the func
cgen_arg :: (S.Expr, Bool) -> Codegen Operand
cgen_arg ((S.Expr_Lval lval), False) = cgen_lval lval >>= load
cgen_arg ((S.Expr_Lval lval), True ) = cgen_lval lval
cgen_arg (expr, _) = cgen_expr expr
-------------------------------------------------------------------------------
-- Driver Functions for navigating the Tree
-------------------------------------------------------------------------------
-- Takes the necessary fields from a function defintion, and adds a fun_info struct to the current scope
addFunc :: SymbolName -> S.FPar_List -> S.R_Type -> Codegen ()
addFunc name args_lst f_type = do
    scpnm <- getScopeName
    writeLog $ "add function was called from scope " ++ scpnm ++ " for function " ++ name
    let our_ret = getFunType f_type   -- we format all of the function stuff properly
        fun_args = map createArgType args_lst
        fn_info = createFunInfo name fun_args our_ret
    fun <- addFunOperand fn_info
    addSymbol (fn_name fn_info) (F fun)   -- > add the function to our SymbolTable

addVar :: S.Var_Def -> Codegen ()    -- takes a VARIABLE DEFINITION , and adds the proper things, to the proper scopes
addVar vdef = do
    scpnm <- getScopeName
    var_info <- createVar_from_Def vdef    -- create the new VarInfo filed to be inserted in the scope
    var <- addVarOpperand var_info         -- NOTE: add the operand to the varinfo field
    addSymbol (var_name var_info) (V var)
    writeLog $ "Adding variable " ++ (var_name var_info) ++ " to the scope " ++ scpnm

-- Put the Function args to the function's scope, as variables variables
addFArgs :: S.FPar_List -> Codegen ()
addFArgs (arg:args) = do
    param <- createVar_from_Arg arg
    param_ready <- addArgOpperand param
    addSymbol (var_name param) (V param_ready)
    addFArgs args
addFArgs [] = return ()

addLDef :: S.Local_Def -> Codegen ()
addLDef (S.Loc_Def_Fun fun) = cgenFuncDef fun
addLDef (S.Loc_Def_Var var) = addVar var

addLDefLst :: [S.Local_Def] -> Codegen  ()
addLDefLst defs = mapM addLDef defs >> return ()

addLibraryFns :: [FunInfo] -> Codegen ()
addLibraryFns (fn:fns) = do
    external retty label argtys
    addSymbol (fn_name fn) (F fn)
    addLibraryFns fns
    where
        retty = type_to_ast (result_type fn)
        label = fn_name fn
        argtys = [(type_to_ast tp, Name $ toShort nm) | (nm, tp, _, _) <- (fn_args fn)]
addLibraryFns [] = return ()

-------------------------------------------------------------------------------
-- Operations
-------------------------------------------------------------------------------

-- lt :: AST.Operand -> AST.Operand -> Codegen AST.Operand
-- lt a b = do
--   test <- fcmp FP.ULT a b
--   uitofp double test
