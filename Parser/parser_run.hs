import Parser
import Lexer
import ASTTypes

main = do
  inpStr <- getContents
  let (Prog main) = parse inpStr
  putStrLn $ show (Prog main)
  putStrLn $ "\nMax nesting: " ++ (show $ max_nesting (Loc_Def_Fun main))
