import ASTTypes
import Parser
import SemanticFunctions
-- import Codegen
import SymbolTableTypes
import Emit

import Control.Monad.Trans

import System.IO
import System.Environment
import System.Console.Haskeline

import qualified LLVM.AST as AST

initModule :: AST.Module
initModule = emptyModule "-I'm really happy right now. -Me too <3"

process :: AST.Module -> Word -> String -> IO (Maybe AST.Module)
process modo opt source = do
    let parseTree = parse source
    ast <- codegen modo parseTree opt -- Optimisation level
    return $ Just ast

processFile :: String -> Word -> IO (Maybe AST.Module)
processFile fname opt = readFile fname >>= process initModule opt

main :: IO ()
main = do
  args <- getArgs
  case args of
    []      -> error "No file to compile!"
    [fname] -> processFile fname 0 >> return ()
    [fname, opt] -> processFile fname 3 >> return ()
