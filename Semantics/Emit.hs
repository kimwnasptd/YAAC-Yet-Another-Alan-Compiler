-- NOTE: EVERYTHING HERE IS MISSING TYPE CHECKING/ ALL TYPES ARE HARDCORED AS DOUBLES
-- Emit.hs must ingest our AST and create an llvm module from it
-- To do so, Emit will use two functions:
-- codegenTop, which  will emit toplevel constructions in modules ( functions and external
--definitions ) and will return a LLVM monad. We'll also sequentially assign each
--  of the named arguments from the function to a stack allocated value with a reference
-- in our symbol table. The last instruction of the stack will be bound into the ret instr
-- to ensure the block returns.

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


-- to sig: takes a string list (the arguements of a call )
-- and returns the same list, formatted in (Type, Name )
toSig :: [String] -> [(AST.Type, AST.Name)]
toSig = map (\x -> (double, AST.Name x))
-- SHOULD BECOME:
-- toSig = map (\x -> (lookup x SYMBOLTABLE, AST.Name x))

    -- NEEDS CHANING: NOT EVERYTHING IS OF TYPE DOUBLE


-- NOW THE INTERESTING STUFF: CGEN
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

-- just look at the binary operations of llvm.
-- we put everything on a map to clean up the rest of the code.
binops = Map.fromList [
      ("*",  mul )  -- > Done
    , ("/",  sdiv)  -- > Done
    , ("%",  srem)  -- > Done? Perhaps we want UREM?
    , ("+",  add )  -- > Done
    , ("-",  sub )  -- > Done
    , ("==", eq  )
    , ("!=", ne  )
    , (">",  gt  )
    , ("<",  lt  )
    , ("<=", leq )
    , (">=", geq )
    , ("&",  andL)   
    , ("|",  orL )
  ]
-- for our operators, we create a predifined association map
-- from the operations symbol, to it's corresponding representation in LLVM IR

-- ORIGINAL:
-- lt :: AST.Operand -> AST.Operand -> Codegen AST.Operand
-- lt a b = do
--   test <- fcmp FP.ULT a b
--   uitofp double test
-- NOTE : I am kinda confused about that, but for the time being, we'll leave it as is


-- OUR VERSION:
-- NOTE:  The llvm instructions are probably correct. For the rest, I have my doubts.

eq :: AST.Operand -> AST.Operand -> Codegen AST.Operand
eq a b = do
  test <- ICmp EQ a b

ne :: AST.Operand -> AST.Operand -> Codegen AST.Operand
ne a b = do
  test <- ICmp NE  a b

gt :: AST.Operand -> AST.Operand -> Codegen AST.Operand
gt a b = do
  test <- ICmp UGT a b

lt :: AST.Operand -> AST.Operand -> Codegen AST.Operand
lt a b = do
  test <- ICmp ULT  a b

leq :: AST.Operand -> AST.Operand -> Codegen AST.Operand
leq a b = do
  test <- ICmp ULE a b

geq :: AST.Operand -> AST.Operand -> Codegen AST.Operand
geq a b = do
  test <- ICmp UGE a b

-- NOTE: I still haven't figured out what to do about the 2 logical instructions, maybe
-- we should talk about it.
-- andL :: AST.Operand -> AST.Operand -> Codegen AST.Operand
-- lt a b = do
--   test <- ICmp UGE a b
--
-- orL :: AST.Operand -> AST.Operand -> Codegen AST.Operand
-- lt a b = do
--   test <- ICmp UGE a b





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


-- NOTE: Papaspyrou will be as if he sees as using the IO module
--  but we have to start from somewhere
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
