import llvm-hs-pure
import Data.Word
import haskell-names
import Data.Map.Strict     -- > No reason to use a lazy implementation for Map:
-- Small data sizes, (almost) all stored data will be needed in the end


double :: Type
double  = FloatingPointType 64 IEEE  -- has a simple double as its abbreviation
int :: Type
int = i16         -- This will be a SIGNED integer number
byte :: Type
byte = i8         -- This will be an UNSIGNED byte. Why? Well, I am glad you asked!
-- http://lists.llvm.org/pipermail/llvm-dev/2011-November/044966.html
-- there is no need to represent boolean values in our memory, so we don't have
-- to declare them.


type Name = String                -- e.g. names of functions, blocks, etc are just Strings
type Names = Map.Map String Int   --the backend for our name supply
-- note that Strings have an instance of Ord, so this map is more efficient than it looks!

type SymbolTable = [(String, Operand)]
-- NOTE: LLVM TYPE  An Operand is roughly that which is an argument to an Instruction, will become clear later

data CodegenState       -- >   holds the internal state of our code generator as we walk the AST.
  = CodegenState {
    currentBlock :: Name                     -- Name of the active block to append to
  , blocks       :: Map.Map Name BlockState  -- Blocks for functions
  , symtab       :: SymbolTable              -- Function scope symbol table
  , blockCount   :: Int                      -- Count of basic blocks
  , count        :: Word                     -- Count of unnamed instructions
  , names        :: Names                    -- Name Supply : Its use is shown on lines ~150-160
  } deriving Show

-- If you think about it, CodegenState and block state need not derive anything more:
-- We only have one codgenstate monad, with nothing else to compare it to.
-- We are never going to compare a bloc with another one. What semantics would that have?

data BlockState
  = BlockState {
    idx   :: Int                            -- Block index
  , stack :: [Named Instruction]            -- Stack of instructions
  , term  :: Maybe (Named Terminator)       -- Block terminator
  } deriving Show

-- NOTE: eg of a block, written in llvm:
--
-- define i64 @n1(i64 %x, i64 %y, i64 %z){
-- entry:                              <-- BLOCK INDEX
--  %0 = mul i64 %x, %y                <-- stack[0]
--  %1 = add i64 %0, %z                <-- stack[1]
--  ret i64 %1                         <-- terminator
-- }
-- ( NOTE : in practice we always append them from the front, so stack numbers are reversed )

newtype Codegen a = Codegen { runCodegen :: State CodegenState a }
  deriving (Functor, Applicative, Monad, MonadState CodegenState )

-- We'll hold the state of the code generator inside of Codegen State monad, the Codegen monad
-- contains a map of block names to their BlockState representation.


-- We create an LLVM state monad,which will hold all code a for the LLVM module
-- Upon evaluation, it will emit an llvm-hs module, containing the AST
-- We'll append to the list of definitions in the AST.Module field moduleDefinitions.

newtype LLVM a = LLVM (State AST.Module a)
  deriving (Functor, Applicative, Monad, MonadState AST.Module )

-- NOTE: AST MODULE TYPE: Defined in LLVM.General.AST

-- Module{
-- moduleName :: String
-- moduleDataLayout :: Maybe DataLayout   --> a DataLayout, if specified, must match that of the eventual code generator
-- moduleTargetTriple :: Maybe String
-- moduleDefinitions :: [Definition]
-- }


runLLVM :: AST.Module -> LLVM a -> AST.Module
runLLVM mod (LLVM m) = execState m mod
 -- NOTE: The type runLLVM takes an AST (the one corresponding to the parser's output  ) and returns an LLVM module, containing ANOTHER AST,
 -- one with semantics/ other cool stuff done to it


emptyModule :: String -> AST.Module         -- > Returns the most plain jane AST.module possible
emptyModule label = defaultModule { moduleName = label }

addDefn :: Definition -> LLVM ()  -- > Takes our existing module and adds a new definition to it
addDefn d = do
  defs <- gets moduleDefinitions
  modify $ \s -> s { moduleDefinitions = defs ++ [d] }

-- NOTE:
-- Definition: anythiνg that can be at the top level of a module
-- CONSTRUCTORS  we will use:
-- GlobalDefinition Global


-- Inside of our module we'll need to insert our toplevel definitions.
-- For our purposes this will consist entirely of local functions and external function declarations.

define ::  Type -> String -> [(Type, Name)] -> [BasicBlock] -> LLVM ()
define retty label argtys body = addDefn $
  GlobalDefinition $ functionDefaults {
    name        = Name label
  , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
  , returnType  = retty
  , basicBlocks = body
  }

external ::  Type -> String -> [(Type, Name)] -> LLVM ()
external retty label argtys = addDefn $
  GlobalDefinition $ functionDefaults {
    name        = Name label
  , linkage     = L.External
  , parameters  = ([Parameter ty nm [] | (ty, nm) <- argtys], False)
  , returnType  = retty
  , basicBlocks = []
  }


                                --      //      --


-- Now that our codegen monad is ready, we create some functions to work with it:

entry :: Codegen Name
entry = gets currentBlock  -- > Pretty self explanatory. Gets the currentBlock from our codegen monad


addBlock :: String -> Codegen Name   -- > We push a new block in the codegen monad
addBlock bname = do
  bls <- gets blocks
  ix  <- gets blockCount
  nms <- gets names

  let new = emptyBlock ix                       -- creates a fresh name for the new block
      (qname, supply) = uniqueName bname nms

  modify $ \s -> s { blocks = Map.insert (Name qname) new bls    -- we update all fields of codegen accordingly. We insert the new block
                   , blockCount = ix + 1                -- blockCount ++
                   , names = supply                     -- this is a "name generator" of sorts, updated to still give a fresh name next time
                   }
  return (Name qname)       -- For some not obvious reason, we return the nae
                            -- of the  that we pushed as a result. ASK QUESTIONS LATER

getBlock :: Codegen Name            -- Does the same as entry ? YEAP.
getBlock = gets currentBlock        -- Do we write whatever we plase ? ALSO YEAP.


modifyBlock :: BlockState -> Codegen ()         -- modifies the current block ( after the Instruction: current block := new )
modifyBlock new = do
  active <- gets currentBlock                   -- gets the name of the current block
  modify $ \s -> s { blocks = Map.insert active new (blocks s) }
-- by inserting the new block in the map with the name of the 'old' block, we are in essence overwritting it


current :: Codegen BlockState               -- gets the current BLOCK (all of its data ), not just ITS NAME
current = do                                -- if a block with the current's name doesn't exist  in our hashmap
  c <- gets currentBlock                    -- we throw a "no such block " error
  blks <- gets blocks
  case Map.lookup c blks of
    Just x -> return x
    Nothing -> error $ "No such block: " ++ show c


 -----              This is the end of our basic infrastructure     -----



 ----- We need some helper functions for our llvm bindings          ------

fresh :: Codegen Word      -- Provides a fresh name supply , whenever we need names for our bidings, using our Codegen monad
fresh = do
  i <- gets count
  modify $ \s -> s { count = 1 + i }   -- Increases codegen count  by  1, so that the next call can also take a fresh name
  return $ i + 1              -- returns a number? YEAP! think of the 'names' we provide to unnamed instructions:
  -- %1, %2, %3 etc


uniqueName :: String -> Names -> (String, Names)   -- A second fresh name supply. The difference is that this one
uniqueName nm ns =                                 -- Guarantees that our block names are unique
  case Map.lookup nm ns of
    Nothing -> (nm,  Map.insert nm 1 ns)            -- If the name is unique, we insert it in our hash of names, and return the tuple (unique  Name, updated Names )
    Just ix -> (nm ++ show ix, Map.insert nm (ix+1) ns)     -- If it isn't, we apply make up to it, and return the corresponding tuple



 -- Since we can now work with named LLVM values we need to create several functions
 -- for referring to references of values:

-- IMPORTANT NOTE: These two ABSOLUTELY need changes, they have double types only here.
local ::  Name -> Operand
local = LocalReference double

externf :: Name -> Operand
externf = ConstantOperand . C.GlobalReference double
-- Extern is a bit of a pain in our back


-- Two simple functions for referring to local/external references




-- Because we need to refer by name to values on the stack, we will need a symbol table (one of its uses ).
-- For starters, we will create a simple symbol table, as an association list, letting us assign variable names
-- to operand quantities  and subsequently look them up when used :



assign :: String -> Operand -> Codegen ()   -- Updates the codegen monad, by adding the pair VName - Operand to it
assign var x = do
  lcls <- gets symtab
  modify $ \s -> s { symtab = [(var, x)] ++ lcls }

getvar :: String -> Codegen Operand  -- Looks up for a Vname on the symbol table, and returns it's typ... operand I mean
getvar var = do
  syms <- gets symtab
  case lookup var syms of     -- NOTE: this is O(logN ). It may be a smart idea to convert
    Just x  -> return x       -- to a hashmap
    Nothing -> error $ "Local variable not in scope: " ++ show var


-- Now that we have a way of naming instructions we'll create an internal function to take an llvm-hs AST node and push it on the current basic block stack.
-- We'll return the left hand side reference of the instruction. Instructions will come in two flavors, instructions and terminators.
-- Every basic block has a unique terminator and every last basic block in a function must terminate in a ret.


instr :: Instruction -> Codegen (Operand)           -- takes an instruction as an argument, and appends it to the instruction stack
instr ins = do
  n <- fresh               -- EVERY instruction gets a fresh  name. NOTE: helps with SSA
  let ref = (UnName n)     -- NOTE: UnName Int   is the llvm-hs constructor for unnamed instructions
  blk <- current            -- for example,  ret i32 %1 : %1 corresponds to UnName 1
  let i = stack blk        -- Gets the instruction stack of the current block
  modifyBlock (blk { stack = (ref := ins) : i } )      -- appends the new instruction to it
  return $ local ref



terminator :: Named Terminator -> Codegen (Named Terminator)        -- takes an instruction as an argument and sets it as the blocks terminator
terminator trm = do
  blk <- current        --get current block
  modifyBlock (blk { term = Just trm })     -- set its' terminator to our arguement
  return trm            -- the JUST is neededed because in our block term:: Maybe Terminator


-- In all these, we use the instr function to wrap the AST nodes for simple arithmetic functions


-- THESE ARE THE ORIGINAL:
-- fadd :: Operand -> Operand -> Codegen Operand
-- fadd a b = instr $ FAdd NoFastMathFlags a b []
--
-- fsub :: Operand -> Operand -> Codegen Operand
-- fsub a b = instr $ FSub NoFastMathFlags a b []
--
-- fmul :: Operand -> Operand -> Codegen Operand
-- fmul a b = instr $ FMul NoFastMathFlags a b []
--
-- fdiv :: Operand -> Operand -> Codegen Operand
-- fdiv a b = instr $ FDiv NoFastMathFlags a b []

-- JUST A BIT BETTER!
-- all instructions can be found at: https://hackage.haskell.org/package/llvm-hs-pure-5.1.2/docs/LLVM-AST-Instruction.html
add :: Operand -> Operand -> Codegen Operand
add a b = instr $ Add  a b []

sub :: Operand -> Operand -> Codegen Operand
sub a b = instr $ Sub  a b []

mul :: Operand -> Operand -> Codegen Operand
mul a b = instr $ Mul a b []

sdiv :: Operand -> Operand -> Codegen Operand           -- SIGNED Integer  Division
sdiv a b = instr $ SDiv  a b []

srem :: Operand -> Operand -> Codegen Operand           -- SIGNED Integer  Division Remainder
srem a b = instr $ SRem  a b []
-- FastMath are for noobs
-- we only use QUICK MUFFS
-- ( The integer instructions don't use fast math flags )


-- Control flow operations --
-- These all must end the current block, so the instruction is added to the terminator, not the instruction stack
-- Same logic as before applies, but now we call the terminator function instead of the instr one

br :: Name -> Codegen (Named Terminator)
br val = terminator $ Do $ Br val []

cbr :: Operand -> Name -> Name -> Codegen (Named Terminator)
cbr cond tr fl = terminator $ Do $ CondBr cond tr fl []

ret :: Operand -> Codegen (Named Terminator)
ret val = terminator $ Do $ Ret (Just val) []


-- EFFECT Instructions:  these effect memory / evaluation side effects
call :: Operand -> [Operand] -> Codegen Operand  -- takes a named function reference and a list of arguments,evaluates it,
call fn args = instr $ Call Nothing CC.C [] (Right fn) (toArgs args) [] []   -- and then invokes it at the current position

alloca :: Type -> Codegen Operand                   -- takes the type of the value we want to allocate space for, and creates
alloca ty = instr $ Alloca ty Nothing 0 []        --  a pointer to a STACK ALLOCATED, UNINITIALIZED  of the given type.

store :: Operand -> Operand -> Codegen Operand      -- takes a pointer and a value, and stores the value to that pointer,
store ptr val = instr $ Store False ptr val Nothing 0 []         -- provided that the types are valid

load :: Operand -> Codegen Operand
load ptr = instr $ Load False ptr Nothing 0 []


-- Our basic infrastructure is done. Now the burdain falls to Emit.hs