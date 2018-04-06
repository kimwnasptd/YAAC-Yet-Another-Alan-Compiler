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