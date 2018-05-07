module Tokens where

-- The token type:
data Token
  = TByte
  | TElse
  | TFalse
  | TIf
  | TInt
  | TProc
  | TReference
  | TReturn
  | TWhile
  | TTrue
  | TPeriod
  | TSemiColon
  | TColon
  | TLeftParen
  | TRightParen
  | TComma
  | TLeftBrack
  | TRightBrack
  | TLeftBrace
  | TRightBrace
  | TStringLiteral  String
  | TName           String
  | TIntLiteral     Int
  | TChar           String
  | TOp             String
  | TComOp          String
  | TErrorSymbol    String
  | TAssign
  | TEOF
    deriving (Eq,Show)


data LineToken
  = LineToken {
    token   ::  Token ,             -- An enhanced token, containing a simple token, and
    line    :: Int                  -- The line at which the token was found
  }
  deriving ( Eq,Show )              -- SO that the next stages of analysis can print the line of the error 
