{
module Main (main) where
}
 
%wrapper "basic"
 
$digit = 0-9            -- digits
$alpha = [a-zA-Z]       -- alphabetic characters
$graphic    = $printable # $white
 
@string     = \" ($graphic # \")* \"
 
 
 
tokens :-
 
  $white+               ;
  "byte"                { \s -> Tbyte }
  "return"              { \s -> TReturn }
  "int"                 { \s -> TInt }
  "if"                  { \s -> TIf }
  "else"                { \s -> TElse }
  "true"                { \s -> TTrue }
  "false"               { \s -> TFalse }
  "while"               { \s -> TWhile }
  "proc"                { \s -> TProc }
  "reference"           { \s -> TReference }

  $digit+               { \s -> TIntLiteral (read s) }
  "&&"                  { \s -> TOp (head s) }
  "!"                   { \s -> TNot }
  [\+\-\*\/]            { \s -> TOp (head s) }
  "<"                   { \s -> TComOp (head s) }
  "="                   { \s -> TEquals }

  $alpha[$alpha $digit \_ \']*  { \s -> TIdent s }
  @string                   { \s -> TStringLiteral (init (tail s)) -- remove the leading " and trailing " }

  "."                   { \s -> TPeriod }
  ";"                   { \s -> TSemiColon }
  "("                   { \s -> TLeftParen }
  ")"                   { \s -> TRightParen } 
  "{"                   { \s -> TLeftBrace }
  "}"                   { \s -> TRightBrace }
  ","                   { \s -> TComma }
  "["                   { \s -> TLeftBrack }
  "]"                   { \s -> TRightBrack }

  "System.out.println"  { \s -> TPrint }
{
-- Each action has type :: String -> Token
 
-- The token type:
data Token =
    TLeftBrace  |
    TRightBrace |
    TProc |
    TReference |
    TComma |
    TLeftBrack |
    TRightBrack |
    TClass |
    TPublic |
    TString |
    TStatic |
    TVoid |
    TMain    |
    TExtend |
    TInt |
    TBool |
    TIf |
    TElse |
    TTrue |
    TFalse |
    TThis |
    TLength |
    TWhile |
    TNew |
    TOp Char |
    TComOp Char |
    TNot |
    TEquals |
    TPeriod |
    TSemiColon |
    TLeftParen |
    TRightParen |
    TIdent String |
    TPrint |
    TIntLiteral Int |
    TStringLiteral String |
    TReturn
    deriving (Eq,Show)
 
main = do
  s <- getContents
  print (alexScanTokens s)
 
}