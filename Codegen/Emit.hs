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
import Data.List
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
import qualified LibraryFunctions as LIB

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
    addLibraryFns LIB.lib_fns
    cgen_main main
    gets logger >>= return  -- > return the logger of our codegeneration

cgen_main :: S.Func_Def -> Codegen ()
cgen_main main@(S.F_Def name args_lst f_type ldef_list cmp_stmt) = do
    openScope "main"
    fun <- addFunc "main" [] f_type
    entry <- addBlock entryBlockName
    setBlock entry
    addLDefLst ldef_list              -- > add the local definitions of that function, this is where the recursion happens
    init_display (max_nesting (S.Loc_Def_Fun main)) -- Updates the stack frame
    putframe
    escapevars
    semStmtList cmp_stmt              -- > do the Semantic analysis of the function body
    cgen_stmts cmp_stmt
    endblock fun
    closeScope                        -- > close the function' s scope

cgenFuncDef :: S.Func_Def -> Codegen ()
cgenFuncDef (S.F_Def name args_lst f_type ldef_list cmp_stmt) = do
    fun <- addFunc name args_lst f_type      -- we add the function to our CURRENT scope
    openScope name                    -- every function creates a new scope
    entry <- addBlock entryBlockName
    setBlock entry                    -- change the current block to the new function
    addFArgs args_lst                 -- add parameters to symtable
    addFunc name args_lst f_type      -- NOTE: add the function to the inside scope as well
    addLDefLst ldef_list              -- add the local definitions of that function, this is where the recursion happens
    putframe
    escapevars                        -- previous functions, Then, local escape our own variables
    semStmtList cmp_stmt              -- do the Semantic analysis of the function body
    recover_vars cmp_stmt             -- walk the function body , recovering all needed external variables from
    cgen_stmts cmp_stmt               -- once the Semantic analysis has passed, gen the body
    endblock fun                      -- If proc, put a ret as terminator
    closeScope                        -- close the function' s scope

cgen_stmts :: S.Comp_Stmt -> Codegen [()]
cgen_stmts (S.C_Stmt stmts) = mapM cgen_stmt stmts
-- cgen_stmts (S.C_Stmt stmts) = forM stmts cgen_stmt   -- because we like playing with monads...

cgen_stmt :: S.Stmt -> Codegen ()
cgen_stmt S.Stmt_Ret = ret >> return ()
cgen_stmt S.Stmt_Semi = return ()
cgen_stmt (S.Stmt_Ret_Expr e1) = cgen_expr e1 >>= retval >> return ()
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
    disp <- getvar "display"
    lbr_fns <- gets libraryfns
    case  fn `elem`  lbr_fns of
        True -> call_void foo_operand arg_operands
        _    -> call_void foo_operand (arg_operands ++ [disp] )
    return ()
    -- -- call_void foo_operand arg_operands
    -- return ()                                                NOTE: ASK SOMEONE
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
    setBlock ifelse             -- same as ifthen block
    cgen_stmt else_stmt
    br ifexit
    ifelse <- getBlock
        -- exit part
        ------------
    setBlock ifexit             -- merge the 2 blocks
    -- ret                         -- WARNING: JUST FOR TESTING, THIS IS WRONG AF
    return ()
cgen_stmt (S.Stmt_If cond if_stmt ) = do
    ifthen <- addBlock "if.then"
    ifexit <- addBlock "if.exit"
    -- ENTRY
    cond_op <- cgen_cond cond    -- generate a 1-bit condition
    cbr cond_op ifthen ifexit    -- branch based on condition
    -- ifthen part
    --------------
    setBlock ifthen
    cgen_stmt if_stmt
    br ifexit
    -- ifthen <- getBlock
    -- exit part
    ------------
    setBlock ifexit
    return ()
cgen_stmt (S.Stmt_Wh cond loop_stmt) = do
    while_entry <- addBlock "while.entry" -- add a block to prep the loop body
    while_loop  <- addBlock "while.loop"  -- add block for the loop body
    while_exit  <- addBlock "while.exit"  -- add fall through loop

    entry_cond <- cgen_cond cond          -- generate the condition for the FIRST time
    cbr entry_cond while_loop while_exit  -- if the condition is true, execute the body
    -- while entry
    setBlock while_entry
    entry_cond <- cgen_cond cond          -- generate the condition for the FIRST time
    cbr entry_cond while_loop while_exit  -- if the condition is true, execute the body
    -- while body
    setBlock while_loop                 -- change block
    cgen_stmt loop_stmt                 -- generate the loop's code
    br while_entry                      -- go to the loop exit
    -- while exit
    setBlock while_exit
    return()

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
    tp  <- getExprType e1
    case tp of
        IntType  ->  sdiv ce1 ce2
        ByteType ->  udiv ce1 ce2
cgen_expr (S.Expr_Mod e1 e2) = do
    ce1 <- cgen_expr e1
    ce2 <- cgen_expr e2
    tp  <- getExprType e1
    case tp of
        IntType  ->  srem ce1 ce2
        ByteType ->  urem ce1 ce2
cgen_expr (S.Expr_Fcall (S.Func_Call fn args ) ) = do
    F fun_info <- getSymbol fn
    refs <- forM (fn_args fun_info) (\(_,_,ref,_) -> return ref)
    arg_operands <- mapM cgen_arg (zip args refs)
    foo_operand <- getfun fn
    disp <- getvar "display"
    lbr_fns <- gets libraryfns
    case  fn `elem`  lbr_fns of
        True -> call foo_operand arg_operands
        _    -> call foo_operand (arg_operands ++ [disp] )
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

-- cgen_lval always returns an address operand
cgen_lval :: S.L_Value -> Codegen AST.Operand
cgen_lval (S.LV_Var var) = getvar var
cgen_lval (S.LV_Tbl tbl_var offset_expr) = do
    offset <- cgen_expr offset_expr   --generate the expression for the offset
    tbl_operand <- getvar tbl_var     -- get the table operand
    create_ptr tbl_operand [offset] tbl_var
cgen_lval (S.LV_Lit str) = do
    globStrName <- freshStr
    define $ globalStr globStrName str
    let op = externstr (Name $ toShort globStrName) (str_type str)
    bitcast op (ptr i8)

-- If an array without brackets we need to pass the pointer to the func
cgen_arg :: (S.Expr, Bool) -> Codegen Operand
cgen_arg ((S.Expr_Lval lval), False) = cgen_lval lval >>= load
cgen_arg ((S.Expr_Lval lval), True ) = cgen_lval lval
cgen_arg (expr, _) = cgen_expr expr

-------------------------------------------------------------------------------
-- Symbol Table and Scopes Handling
-------------------------------------------------------------------------------

getvar :: SymbolName -> Codegen Operand
getvar var = do
    symbol <- getSymbol_enhanced var
    case symbol of
        (Left (F _ ) )                ->  error $ "Var " ++ (show var) ++ " is also a function on the current scope!"
        (Right ( _, F _ ) )           ->  error $ "Var " ++ (show var) ++ " is a function on a previous scope!"
        (Left ( V var_info ) )        -> case var_operand var_info of
            Nothing -> error $ "Symbol " ++ (show var) ++ " has no operand"
            Just op -> return op
        (Right ( scp, V var_info) )   -> case var_operand var_info of
            Nothing -> error $ "Symbol " ++ (show var) ++ " has no operand in the parent function!"
            Just op -> putvar (scp_name scp) (nesting scp) var_info  -- we need to put it in the scope

-- takes the nesting level in which a non local variable can be found
-- and the var_info of that function in order to add it to our own scope
putvar :: String -> Int -> VarInfo -> Codegen Operand
putvar fn_name level v_info = do
    let (offset, v_name ) =  (var_idx v_info, var_name v_info )   --calculate the offset for local rec
    local_recover_operand <- getfun "llvm.localrecover"
    func_operand <- getfun fn_name
    bitcasted_func <- bitcast func_operand (ptr i8)  -- bitcast the function operand to * i8 for localrecover
    fp_op <- getframe level              -- load the frame ptr we are looking for

    recovered_op <- call local_recover_operand [bitcasted_func , fp_op ,(toInt offset) ]
    op <- convert_op recovered_op v_info

    addSymbol v_name (V v_info { var_operand = Just op })
    return $ op

getfun :: SymbolName -> Codegen Operand
getfun fn = do
    symbol <- getSymbol fn
    case symbol of
        V _        -> error $ "Fun " ++ (show fn) ++ " is also a variable"
        F fun_info -> case fun_operand fun_info of
            Nothing -> error $ "Symbol " ++ (show fn) ++ " has no operand"
            Just op -> return op

init_display :: Int -> Codegen ()
init_display lvl = do
    disp_info <- addVarOperand (display lvl)
    addSymbol "display" (V disp_info)

putframe :: Codegen ()
putframe = do
    curr_nst     <- gets $ nesting . currentScope  -- get current nesting level
    fn_operand   <- getfun "llvm.frameaddress"      --  get the call opearand
    frame_op     <- call fn_operand [zero]         -- call the function to get the frame pointer
    curr_display <- getvar "display"
    offseted_ptr <- create_ptr curr_display [toInt curr_nst] "display"
    store offseted_ptr frame_op
    return ()

getframe :: Int -> Codegen Operand
getframe idx = do
    let offset = toInt idx
    tbl_operand <- getvar "display"
    display_pos <- create_ptr tbl_operand [offset] "display"
    load display_pos

escapevars :: Codegen ()
escapevars = do
    funs <- currfuns            -- take all the functions in our scope
    case funs of
        [self] -> return ()  -- Leaf function
        funs   -> do
            vars_withdisp <- currvars         -- take the variables of the curret scope INCLUDING display
            let vars = filter ( \x ->  (var_type x) /= DisplayType ) vars_withdisp
            let sortedVars = var_sort vars
            -- operands <- forM sortedVars (getvar . var_name)
            operands <- forM sortedVars escape_op
            fn_operand <- getfun "llvm.localescape"      -- localescape every variable in the function
            call_void fn_operand operands
            return ()
    where
        var_sort :: [VarInfo] -> [VarInfo]
        var_sort = sortBy ( \a b -> compare (var_idx a)  (var_idx b) )

-- recovers all function variables on the entry block of that function, using walkers
recover_vars :: S.Comp_Stmt -> Codegen ()
recover_vars (S.C_Stmt []  ) = return ()
recover_vars (S.C_Stmt stmt_list) = mapM walk_stmt stmt_list >> return ()

-- WALKERS: They traverse the whole body of a function, and only check for variable accesses
-- For every variable found, if it comes from a previous function, they make sure to use
-- local recover ON THE ENTRY BLOCK, so that the the variable is visible on every
-- function block, regarldess of control flow. They ignore everything else.
walk_stmt :: S.Stmt -> Codegen ()
walk_stmt S.Stmt_Ret = return ()
walk_stmt S.Stmt_Semi = return ()
walk_stmt (S.Stmt_Ret_Expr e1) = walk_expr e1
walk_stmt (S.Stmt_Cmp (S.C_Stmt list ) ) = mapM walk_stmt list >> return ()   -- THIS LINE IS WHAT REAL PAIN LOOKS LIKE
walk_stmt (S.Stmt_Eq lval expr) = walk_expr (S.Expr_Lval lval) >> walk_expr expr
walk_stmt (S.Stmt_FCall (S.Func_Call fn args)) = mapM walk_expr args >> return ()
walk_stmt (S.Stmt_If cond stmt) = walk_cond cond >> walk_stmt stmt
walk_stmt (S.Stmt_Wh cond stmt) = walk_cond cond >> walk_stmt stmt
walk_stmt (S.Stmt_IFE cond stmt1 stmt2) = do
    walk_cond cond
    walk_stmt stmt1
    walk_stmt stmt2

walk_cond :: S.Cond -> Codegen ()
walk_cond S.Cond_True = return ()
walk_cond S.Cond_False = return ()
walk_cond (S.Cond_Br cond ) = walk_cond cond
walk_cond (S.Cond_Bang cond ) = walk_cond cond
walk_cond (S.Cond_Eq left right ) = walk_expr left>> walk_expr right
walk_cond (S.Cond_Neq left right ) = walk_expr left >> walk_expr right
walk_cond (S.Cond_L left right ) = walk_expr left >> walk_expr right
walk_cond (S.Cond_G left right ) = walk_expr left >> walk_expr right
walk_cond (S.Cond_LE left right ) = walk_expr left >> walk_expr right
walk_cond (S.Cond_GE left right ) = walk_expr left >> walk_expr right
walk_cond (S.Cond_And cond1 cond2 ) = walk_cond cond1 >> walk_cond cond2
walk_cond (S.Cond_Or cond1 cond2 ) = walk_cond cond1 >> walk_cond cond2

walk_expr :: S.Expr -> Codegen ()
walk_expr (S.Expr_Add left right) = walk_expr left >> walk_expr right
walk_expr (S.Expr_Sub left right) = walk_expr left >> walk_expr right
walk_expr (S.Expr_Tms left right) = walk_expr left>> walk_expr right
walk_expr (S.Expr_Div left right) = walk_expr left >> walk_expr right
walk_expr (S.Expr_Mod left right) = walk_expr left >> walk_expr right
walk_expr (S.Expr_Pos expr) = walk_expr expr
walk_expr (S.Expr_Neg expr) = walk_expr expr
walk_expr (S.Expr_Brack expr) = walk_expr expr
walk_expr (S.Expr_Fcall (S.Func_Call nm args) ) = mapM walk_expr args >> return ()
walk_expr (S.Expr_Lval (S.LV_Var var)) = getvar var >> return ()
walk_expr (S.Expr_Lval (S.LV_Tbl tbl_var offset_expr)) = do
    walk_expr offset_expr
    tbl_operand <- getvar tbl_var
    -- create_ptr tbl_operand [offset] tbl_var                           -- WARNING MAYBE WE NEED IT?
    return ()
walk_expr _ = return ()

-- In case of Tables, we 'alloca' a Pointer Holder and escape that one
escape_op :: VarInfo -> Codegen Operand
escape_op vinfo
    | (byreference vinfo) == False = getvar $ var_name vinfo
    | otherwise = do
        addr <- getvar $ var_name vinfo
        ptr_holder <- allocavar (to_type tp ref) nm -- The holder of the pointer is what we escape
        store ptr_holder addr >> return ptr_holder
    where tp  = var_type vinfo
          nm  = var_name vinfo
          ref = byreference vinfo

-- Bitcasts the result of llvm.localrecover to the corect type
convert_op :: Operand -> VarInfo -> Codegen Operand
convert_op recovered_op vinfo
    | ref == False = bitcast recovered_op (proper_type tp ref)
    | otherwise    = bitcast recovered_op (proper_type tp ref) >>= load >>= return
    where tp = var_type vinfo
          ref = byreference vinfo
          proper_type IntType  False = ptr i32
          proper_type ByteType False = ptr i8
          proper_type IntType  True  = ptr (ptr i32)
          proper_type ByteType True  = ptr (ptr i8)
          proper_type tabletp _      = ptr $ type_to_ast tabletp

-------------------------------------------------------------------------------
-- Driver Functions for navigating the Tree
-------------------------------------------------------------------------------
-- Takes the necessary fields from a function defintion, and adds a fun_info struct to the current scope
addFunc :: SymbolName -> S.FPar_List -> S.R_Type -> Codegen FunInfo
addFunc name args_lst f_type = do
    scpnm <- getScopeName
    nest <- gets $ nesting . currentScope
    let our_ret = getFunType f_type   -- we format all of the function stuff properly
        fun_args = (map createArgType args_lst) ++ (argdisplay nest name)
        fn_info = createFunInfo name fun_args our_ret
    fun <- addFunOperand fn_info
    addSymbol (fn_name fn_info) (F fun)   -- > add the function to our SymbolTable
    return fun

addVar :: S.Var_Def -> Codegen ()    -- takes a VARIABLE DEFINITION , and adds the proper things, to the proper scopes
addVar vdef = do
    scpnm <- getScopeName
    var_info <- createVar_from_Def vdef    -- create the new VarInfo filed to be inserted in the scope
    var <- addVarOperand var_info         -- NOTE: add the operand to the varinfo field
    current_scope <- gets currentScope
    let curr_index = max_index current_scope    -- get the current max index
    let new_var = var{ var_idx = curr_index}    -- update the index for localescape
    modify $ \s -> s { currentScope = (current_scope) { max_index = curr_index + 1  } }
    addSymbol (var_name var_info) (V new_var)

-- Put the Function args to the function's scope, as variables
addFArgs :: S.FPar_List -> Codegen ()
addFArgs (arg:args) = do
    param <- createVar_from_Arg arg
    param_ready <- addArgOperand param
    addSymbol (var_name param) (V param_ready)
    addFArgs args
addFArgs [] = do
    disp <- addArgOperand (display 0)
    addSymbol "display" (V disp)

addLDef :: S.Local_Def -> Codegen ()
addLDef (S.Loc_Def_Fun fun) = cgenFuncDef fun
addLDef (S.Loc_Def_Var var) = addVar var

addLDefLst :: [S.Local_Def] -> Codegen  ()
addLDefLst defs = mapM addLDef defs >> return ()

addLibraryFns :: [FunInfo] -> Codegen ()
addLibraryFns (fn:fns) = do
    define $ externalFun retty label argtys vargs
    addSymbol (fn_name fn) (F fn)
    libfns <- gets libraryfns
    modify $ \s -> s {libraryfns = label:libfns}
    addLibraryFns fns
    where
        retty = type_to_ast (result_type fn)
        label = fn_name fn
        argtys = [(type_to_ast tp, Name $ toShort nm) | (nm, tp, _, _) <- (fn_args fn)]
        vargs = varargs fn
addLibraryFns [] = return ()
