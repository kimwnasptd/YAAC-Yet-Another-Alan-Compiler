-- TODO: Operators (all)    Missing only ( ! )
--       Fix missing escape characters  Medium
--       Comments   NP Hard xD

{
module Lexer (
  lexer, lexDummy, runner
  ) 
where

import Control.Monad
import Control.Monad.State
import AlexInterface
import Tokens
}

$digit = 0-9            -- digits
$alpha = [a-zA-Z]       -- alphabetic characters
$hexdig = [0-9A-Fa-f]
$special = [\.\;\,\$\|\*\+\?\#\~\-\{\}\(\)\[\]\^\/]
$esc_seq    = [\n \t \r \0 \\ \' \xnn \"  ]   -- DOES THIS PLAY???

@string     = \" ($printable | \" | $esc_seq)* \"               -- Printable contains $white
@chars      = \' ($alpha | $digit | $esc_seq | $special) \'     -- Missing some characters
@name       = $alpha[$alpha $digit \_]*

tokens :-

<0> {
  $white+               ;
  "byte"                { getToken $ TByte }
  "else"                { getToken $ TElse }
  "false"               { getToken $ TFalse }
  "if"                  { getToken $ TIf }
  "int"                 { getToken $ TInt }
  "proc"                { getToken $ TProc }
  "reference"           { getToken $ TReference }
  "return"              { getToken $ TReturn }
  "while"               { getToken $ TWhile }
  "true"                { getToken $ TTrue }

  $esc_seq              ;

  [\+\-\*\/]            { getToken $ TOp ""  }
  "&"                   { getToken $ TOp ""  }
  "|"                   { getToken $ TOp ""  }
  "%"                   { getToken $ TOp ""  }
  "!"                   { getToken $ TOp ""  }

  "="                   { getToken $ TAssign }
  "=="                  { getToken $ TComOp "" }
  "!="                  { getToken $ TComOp "" }
  ">="                  { getToken $ TComOp "" }
  "<="                  { getToken $ TComOp "" }
  ">"                   { getToken $ TComOp "" }
  "<"                   { getToken $ TComOp "" }

  "."                   { getToken $ TPeriod }
  ";"                   { getToken $ TSemiColon }
  "("                   { getToken $ TLeftParen }
  ")"                   { getToken $ TRightParen }
  "{"                   { getToken $ TLeftBrace }
  "}"                   { getToken $ TRightBrace }
  ","                   { getToken $ TComma }
  "["                   { getToken $ TLeftBrack }
  "]"                   { getToken $ TRightBrack }

  @chars                { getToken $ TChar "" }
  $digit+               { getToken $ TIntLiteral 0 }
  @name                 { getToken $ TName "" }
  @string               { getToken $ TStringLiteral  ""  }    -- remove the leading " and trailing "
  -- .                     { getToken $ TErrorSymbol s }
}

-- The rules here apply for all the States of Lexer
\-\-.*\n              ;
"(*"                  { beginComment }

-- The 'Comment' State of Lexer
<commentSC> {
  "*)"                { endComment }
  [.\n]               ;  -- The . does not match with \n
}

{


-- Int -> Chars Matched
-- String -> String Matched
type Action = Int -> String -> P (Maybe Token)

-- Function that returns the Token inside our Monad
getToken :: Token -> Action
getToken (TOp _) _ s            = return $ Just $ TOp s
getToken (TComOp _) _ s         = return $ Just $ TComOp s
getToken (TStringLiteral _) _ s = return $ Just $ TStringLiteral $ init $ tail s
getToken (TName _) _ s          = return $ Just $ TName s
getToken (TIntLiteral _) _ s    = return $ Just $ TIntLiteral $ read s
getToken (TChar _) _ s          = return $ Just $ TChar $ init $ tail s
getToken t _ _ = return (Just t)

-- getTOpToken :: Token -> Action
-- getTOpToken _ _ val = return (Just TOp val)

beginComment :: Action
beginComment _ _ = do
  s <- get
  put s {lexSC = commentSC,
         commentDepth = (commentDepth s)+1}
  return Nothing

endComment :: Action
endComment _ _ = do
  s <- get
  let cd = commentDepth s
  let sc' = if cd==1 then 0 else commentSC
  put s {lexSC=sc',commentDepth=cd-1}
  return Nothing

readToken::P Token
readToken = do
  s <- get
  case alexScan (input s) (lexSC s) of
    AlexEOF -> return TEOF
    AlexError inp' -> error $ "Lexical error on line "++(show $ ailineno inp')      
    AlexSkip inp' _ -> do    
      put s{input = inp'}
      readToken
    AlexToken inp' n act -> do 
      let (AlexInput{airest=buf}) = input s
      put s{input = inp'}
      res <- act n (take n buf)
      case res of
        Nothing -> readToken
        Just t -> return t

lexer::(Token->P a)->P a
lexer cont = do
  tok <- readToken
  cont tok


lexDummy :: P [Token]
lexDummy = do
    tok <- readToken
    if tok == TEOF
        then do let toks = []
                return (tok : toks)
        else do toks <- lexDummy
                return (tok : toks)

runner :: String -> [Token]
runner s = evalState lexDummy (initialState s)

}
