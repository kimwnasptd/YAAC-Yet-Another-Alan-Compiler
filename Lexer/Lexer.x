-- TODO: Operators (all)    Missing only ( ! )          --> DONE
--       Fix missing escape characters  Medium          --> DONE
--       Comments   NP Hard xD                          --> DONE
--       Feed to the parser a line token, so that we can show
--       Lines on syntactic/ semantic erros


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
$quotable = $printable # \"                                        -- Any printable character except "
$esc_seq = [\n \t \r]

@string_sp  = \\\" | \\\' | \\$quotable | \\x $hexdig $hexdig                              --"
@string     = \" ( $quotable | @string_sp )* \"               -- Printable contains $white  " just fixed all the coments for you <3
@chars      = \' ($alpha | $digit  | @string_sp) \'     -- Missing some characters
@name       = $alpha[$alpha $digit \_]*

tokens :-

<0> {
  $white+               ;
  "byte"                { getToken $ TByte        }
  "else"                { getToken $ TElse        }
  "false"               { getToken $ TFalse       }
  "if"                  { getToken $ TIf          }
  "int"                 { getToken $ TInt         }
  "proc"                { getToken $ TProc        }
  "reference"           { getToken $ TReference   }
  "return"              { getToken $ TReturn      }
  "while"               { getToken $ TWhile       }
  "true"                { getToken $ TTrue        }

  $esc_seq              ;                           -- Pretty sure that's a bad idea.

  [\+\-\*\/]            { getToken $ TOp ""       }
  "&"                   { getToken $ TOp ""       }
  "|"                   { getToken $ TOp ""       }
  "%"                   { getToken $ TOp ""       }
  "!"                   { getToken $ TOp ""       }

  "="                   { getToken $ TAssign      }
  "=="                  { getToken $ TComOp ""    }
  "!="                  { getToken $ TComOp ""    }
  ">="                  { getToken $ TComOp ""    }
  "<="                  { getToken $ TComOp ""    }
  ">"                   { getToken $ TComOp ""    }
  "<"                   { getToken $ TComOp ""    }

  "."                   { getToken $ TPeriod      }
  ":"                   { getToken $ TColon       }
  ";"                   { getToken $ TSemiColon   }
  "("                   { getToken $ TLeftParen   }
  ")"                   { getToken $ TRightParen  }
  "{"                   { getToken $ TLeftBrace   }
  "}"                   { getToken $ TRightBrace  }
  ","                   { getToken $ TComma       }
  "["                   { getToken $ TLeftBrack   }
  "]"                   { getToken $ TRightBrack  }

  \-\-.*                ;                                 -- If we come across a comment of that type, we ignore everything till the end of the line "

  @chars                { getToken $ TChar ""     }       -- "
  $digit+               { getToken $ TIntLiteral 0}
  @name                 { getToken $ TName ""     }
  @string               { getToken $ TStringLiteral  ""  }    -- remove the leading " and trailing "
  -- .                  { getToken $ TErrorSymbol s }
}

-- The rules here apply for all the States of Lexer
-- \-\-.*\n              ;                                   --Nope: That rule should only apply if we are not already in a comment. Check the record.
"(*"                  { beginComment }

-- The 'Comment' State of Lexer
<commentSC> {
  "*)"                { endComment }
  [.\n]               ;  -- The . does not match with \n
}

{


-- Int -> Chars Matched
-- String -> String Matched
-- This is the type that returns every time a string is matched
type Action = Int -> String -> P (Maybe Token)

-- Converts the corresponding Token to Action type for the { }
getToken :: Token -> Action
getToken (TOp _) _ s            = return $ Just $ TOp s
getToken (TComOp _) _ s         = return $ Just $ TComOp s
getToken (TStringLiteral _) _ s = return $ Just $ TStringLiteral $ convEsc (init $ tail s)
getToken (TName _) _ s          = return $ Just $ TName s
getToken (TIntLiteral _) _ s    = return $ Just $ TIntLiteral $ read s
getToken (TChar _) _ s          = return $ Just $ TChar $ convEsc (init $ tail s)
getToken t _ _ = return (Just t)


-- Using get token, returns not only the token, but the corresponding line
getLToken :: Token -> (Action, Int )
getLToken token1 = return ( getToken token1, getLineNo)

-- Convert the mathced weird characters (\\n) to their coresponding ones
convEsc :: String -> String
convEsc ( '\\' : 'n' : s )       = '\n' : convEsc s
convEsc ( '\\' : 't' : s )       = '\t' : convEsc s
convEsc ( '\\' : 'r' : s )       = '\r' : convEsc s
convEsc ( '\\' : '\"' : s )      = '\"' : convEsc s
convEsc ( '\\' : '\'' : s )      = '\'' : convEsc s
convEsc ( '\\' : 'x' : s )       = '\\' : 'x' : convEsc s   -- Here we have to decide what to do with these
convEsc ( a : s )                = a : convEsc s
convEsc []                       = []

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

readToken :: P Token
readToken = do
  s <- get
  case alexScan (input s) (lexSC s) of

    -- End of File duh
    AlexEOF -> return TEOF

    -- We need to talk about this :P   --> I have no idea what I was thinking when I wrote that, sorry
    AlexError inp' -> error $ "Lexical error on line "++ (show $ ailineno inp')      -- ' should be removed '

    -- It's the characters that have as action the ;
    AlexSkip inp' _ -> do
      put s{input = inp'}
      readToken

    -- Found Token, the new input is inp, read n bytes, and got act (Action)
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

-- For testing, creates a list of tokens from the input (Must set the State first)
lexDummy :: P [Token]
lexDummy = do
    tok <- readToken
    if tok == TEOF
        then return [tok]
        else do toks <- lexDummy
                return (tok : toks)

-- A simple runner program for sanity checking
runner :: String -> [Token]
runner s = evalState lexDummy (initialState s)

}
