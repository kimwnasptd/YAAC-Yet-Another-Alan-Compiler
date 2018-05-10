-- Emit.hs must ingest our AST and create an llvm module from it
-- To do so, Emit will use two functions:
-- codegenTop, will emit toplevel constructions in modules ( functions and external definitions ) and will return a LLVM monad
-- . We'll also sequentially assign each of the named arguments from the function to a stack allocated value with a reference in our symbol table.


codegenTop :: S.Expr -> LLVM ()
codegenTop (S.Function name args body) = do
  define double name fnargs bls
  where
    fnargs = toSig args
    bls = createBlocks $ execCodegen $ do
      entry <- addBlock entryBlockName
      setBlock entry
      forM args $ \a -> do
        var <- alloca double
        store var (local (AST.Name a))
        assign a var
      cgen body >>= ret

codegenTop (S.Extern name args) = do
  external double name fnargs
  where fnargs = toSig args

codegenTop exp = do
  define double "main" [] blks
  where
    blks = createBlocks $ execCodegen $ do
      entry <- addBlock entryBlockName
      setBlock entry
      cgen exp >>= ret                          -- >  The last instruction on the stack we'll bind into the ret instruction to ensure and emit as the return value of the function.

toSig :: [String] -> [(AST.Type, AST.Name)]
toSig = map (\x -> (double, AST.Name x))                        -- NEEDS CHANING: NOT EVERYTHING IS OF TYPE DOUBLE




-- NOW THE INTERESTING STUFF: CGEN   NOTE: EVERYTHING HERE IS MISSING TYPE CHECKING/ ALL TYPES ARE HARDCORED AS DOUBLES
-- This one recursively walks the AST, pushing instructions on the stack and  changing the current block as needed.

cgen :: S.Expr -> Codegen AST.Operand
cgen (S.Float n) = return $ cons $ C.Float (F.Double n)
-- The simplest AST node. In case of a constant, we simply return the corresponding constant in LLVM IR

cgen (S.Var x) = getvar x >>= load
-- looks up that variable on the symbol table, and maps it over LLVM's load

cgen (S.Call fn args) = do
  largs <- mapM cgen args
  call (externf (AST.Name fn)) largs
-- In the case of a function call, we first generate the llvm arguments, and then invoke the function with those.


binops = Map.fromList [
      ("+", fadd)
    , ("-", fsub)
    , ("*", fmul)
    , ("/", fdiv)
    , ("<", lt)
  ]
-- for our operators, we create a predifined association map
-- from the operations symbol, to it's corresponding representation in LLVM IR


lt :: AST.Operand -> AST.Operand -> Codegen AST.Operand
lt a b = do
  test <- fcmp FP.ULT a b
  uitofp double test
-- NOTE : I am kinda confused about that, but for the time being, we'll leave it as is


cgen (S.BinaryOp op a b) = do
  case Map.lookup op binops of
    Just f -> do
      ca <- cgen a
      cb <- cgen b
      f ca cb
    Nothing -> error "No such operator"
-- Just like the case of calling a function,  we simply generate the code for the operands,
-- and invoke the function  that corresponds to the given symbol.


-- ANDDDD THAT'S ALL FOLKS!
-- Now we just hook into LLVM bindings to generate a string representation of the LLVM IR
-- which will print out the proper string in our repl NOTE : repl is our main, which just calls EVERYTHING, one at a time

codegen :: AST.Module -> [S.Expr] -> IO AST.Module
codegen mod fns = withContext $ \context ->
  liftError $ withModuleFromAST context newast $ \m -> do
    llstr <- moduleLLVMAssembly m
    putStrLn llstr
    return newast
  where
    modn = mapM codegenTop fns
    newast = runLLVM mod modn


-- Are we done?
-- OF COURSE NOT! The fun never ends!
-- Now we enter the bottomless pit of optimizations!  
