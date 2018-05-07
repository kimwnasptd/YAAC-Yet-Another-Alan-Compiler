import llvm-hs-pure
import Data.Word
import haskell-names
import Data.Map.Strict     -- > No reason to use a lazy implementation for Map:
-- Small data sizes, (almost) all stored data will be needed in the end


-- double :: Type
-- double  = FloatingPointType 64 IEEE
int :: Type
int = i16
byte :: Type
byte = i8    -- > Placeholder until we can find an appropriate byte type

type Name = String


type SymbolTable = [(String, Operand)]
-- NOTE: LLVM TYPE  An Operand is roughly that which is an argument to an Instruction

data CodegenState             -- >   holds the internal state of our code generator as we walk the AST.
  = CodegenState {
    currentBlock :: Name                     -- Name of the active block to append to
  , blocks       :: Map.Map Name BlockState  -- Blocks for functions
  , symtab       :: SymbolTable              -- Function scope symbol table
  , blockCount   :: Int                      -- Count of basic blocks
  , count        :: Word                     -- Count of unnamed instructions
  , names        :: Names                    -- Name Supply : NOTE  requires haskell-names module, helps with name resolution ???
  } deriving Show

data BlockState
  = BlockState {
    idx   :: Int                            -- Block index
  , stack :: [Named Instruction]            -- Stack of instructions
  , term  :: Maybe (Named Terminator)       -- Block terminator
  } deriving Show


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


emptyModule :: String -> AST.Module         -- > Returns the most plain jane module possible
emptyModule label = defaultModule { moduleName = label }

addDefn :: Definition -> LLVM ()  -- > Takes our existing module and adds a new definition to it
addDefn d = do
  defs <- gets moduleDefinitions
  modify $ \s -> s { moduleDefinitions = defs ++ [d] }





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
entry = gets currentBlock     -- > Pretty self explanatory. Gets the currentBlock from our codegen monad


addBlock :: String -> Codegen Name   -- > We push a new block in the codegen monad
addBlock bname = do
  bls <- gets blocks
  ix  <- gets blockCount
  nms <- gets names

  let new = emptyBlock ix
      (qname, supply) = uniqueName bname nms

  modify $ \s -> s { blocks = Map.insert (Name qname) new bls    -- we update all fields of codgen accordingly. We insert the new block
                   , blockCount = ix + 1                -- blockCount ++
                   , names = supply                     -- this is a "name generator" of sorts, updated to still give a fresh name next time
                   }
  return (Name qname)       -- For some not obvious reason, we return the block that we pushed as a result. ASK QUESTIONS LATER


getBlock :: Codegen Name            -- Does the same as entry ? YEAP.
getBlock = gets currentBlock        -- Do we write whatever we plase ? ALSO YEAP.


modifyBlock :: BlockState -> Codegen ()         -- modifies the current block ( after the Instruction: current block := new )
modifyBlock new = do
  active <- gets currentBlock                   -- gets the name of the current block
  modify $ \s -> s { blocks = Map.insert active new (blocks s) }
-- by inserting the new block in the map with the name of the 'old' block, we are in essence overwritting it


current :: Codegen BlockState               -- gets the current BLOCK (all of its data ), not just ITS NAME
current = do
  c <- gets currentBlock
  blks <- gets blocks
  case Map.lookup c blks of
    Just x -> return x
    Nothing -> error $ "No such block: " ++ show c
