-- TODO: Operators (all)    Missing only ( ! )
--       Fix missing escape characters  Medium
--       Comments   NP Hard xD

{
module Lexer where
}

%wrapper "basic"

$digit = 0-9            -- digits
$alpha = [a-zA-Z]       -- alphabetic characters
$hexdig = [0-9A-Fa-f]
$special = [\.\;\,\$\|\*\+\?\#\~\-\{\}\(\)\[\]\^\/]
$esc_seq    = [\n \t \r \0 \\ \' \xnn \"  ]   -- DOES THIS PLAY???

@string     = \" ($printable | \" | $esc_seq)* \"         -- Printable contains $white
@chars      = \' ($alpha | $digit | $esc_seq | special) \'  -- Missing some characters
@name       = $alpha[$alpha $digit \_]*

tokens :-

  $white+               ;
  "byte"                { \s -> TByte }
  "else"                { \s -> TElse }
  "false"               { \s -> TFalse }
  "if"                  { \s -> TIf }
  "int"                 { \s -> TInt }
  "proc"                { \s -> TProc }
  "reference"           { \s -> TReference }
  "return"              { \s -> TReturn }
  "while"               { \s -> TWhile }
  "true"                { \s -> TTrue }

  $esc_seq              ;
  \-\-.*\n              ;

  [\+\-\*\/]            { \s -> TOp  s }
  "&"                   { \s -> TOp  s }
  "|"                   { \s -> TOp  s }
  "%"                   { \s -> TOp  s }

  "="                   { \s -> TAssign }
  "=="                  { \s -> TComOp s }
  "!="                  { \s -> TComOp s }
  ">="                  { \s -> TComOp s }
  "<="                  { \s -> TComOp s }
  ">"                   { \s -> TComOp s }
  "<"                   { \s -> TComOp s }

  "."                   { \s -> TPeriod }
  ";"                   { \s -> TSemiColon }
  "("                   { \s -> TLeftParen }
  ")"                   { \s -> TRightParen }
  "{"                   { \s -> TLeftBrace }
  "}"                   { \s -> TRightBrace }
  ","                   { \s -> TComma }
  "["                   { \s -> TLeftBrack }
  "]"                   { \s -> TRightBrack }

  @chars                { \s -> TChar (init (tail s)) }
  $digit+               { \s -> TIntLiteral (read s) }
  @name                 { \s -> TName s }
  @string               { \s -> TStringLiteral  $ init $ tail  s  }    -- remove the leading " and trailing "
  .                     { \s -> TErrorSymbol s }

{
-- Each action has type :: String -> Token

-- The token type:
data Token =
    TByte                   |
    TElse                   |
    TFalse                  |
    TIf                     |
    TInt                    |
    TProc                   |
    TReference              |
    TReturn                 |
    TWhile                  |
    TTrue                   |
    TPeriod                 |
    TSemiColon              |
    TLeftParen              |
    TRightParen             |
    TComma                  |
    TLeftBrack              |
    TRightBrack             |
    TLeftBrace              |
    TRightBrace             |
    TStringLiteral  String  |
    TName           String  |
    TIntLiteral     Int     |
    TChar           String  |
    TOp             String  |
    TComOp          String  |
    TErrorSymbol    String  |
    TAssign
    deriving (Eq,Show)

-- main = do
--   s <- getContents
--   print (alexScanTokens s)

}
