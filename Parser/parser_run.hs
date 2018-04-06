import Parser
import Lexer

main = do
  inpStr <- getContents
  let parseTree = basicParser $ runner inpStr
  putStrLn $ show parseTree 