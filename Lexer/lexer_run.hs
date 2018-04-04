import Lexer

main = do
    s <- getContents
    print (runner s)