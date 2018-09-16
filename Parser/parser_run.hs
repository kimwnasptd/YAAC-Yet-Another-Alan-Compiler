import Parser
import Lexer

main = do
  inpStr <- getContents
  let parseTree = parse inpStr
  putStrLn $ show parseTree
