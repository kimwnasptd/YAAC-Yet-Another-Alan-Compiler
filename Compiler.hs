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

process :: AST.Module -> String -> IO (Maybe AST.Module)
process modo source = do
    let parseTree = parse source
    -- putStrLn (res ++ "\n\nASSEMBLY CODE\n-------------\n")
    ast <- codegen modo parseTree
    return $ Just ast

processFile :: String -> IO (Maybe AST.Module)
processFile fname = readFile fname >>= process initModule

repl :: IO ()
repl = runInputT defaultSettings (loop initModule)
  where
  loop mod = do
    minput <- getInputLine "ready> "
    case minput of
      Nothing -> outputStrLn "Goodbye."
      Just input -> do
        modn <- liftIO $ process mod input
        case modn of
          Just modn -> loop modn
          Nothing -> loop mod

main :: IO ()
main = do
  args <- getArgs
  case args of
    []      -> repl
    [fname] -> processFile fname >> return ()
