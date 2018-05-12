import ASTTypes
import Parser
import SemanticFunctions


main = do
  inpStr <- getContents
  let parseTree = parse inpStr
  print $ "Parsing completed successfully"
  ast_sem parseTree
