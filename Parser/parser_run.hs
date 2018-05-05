import Parser
import Lexer

-- No monad
-- main = do
--   inpStr <- getContents
--   let parseTree = basicParser $ runner inpStr
--   putStrLn $ show parseTree

main = do
  inpStr <- getContents
  let parseTree = parse inpStr
  putStrLn $ show parseTree
