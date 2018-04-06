{
module Parser where

import AlexInterface
import Tokens
import Lexer
import ASTTypes
}


%name basicParser
%tokentype { Token }
%error { parseError }

%token
    byte                 {  TByte       }
    else                 {  TElse       }
    false                {  TFalse      }
    if                   {  TIf         }
    int                  {  TInt        }
    proc                 {  TProc       }
    reference            {  TReference  }
    return               {  TReturn     }
    while                {  TWhile      }
    true                 {  TTrue       }


    "."                  {  TPeriod     }
    ";"                  {  TSemiColon  }
    "("                  {  TLeftParen  }
    ")"                  {  TRightParen }
    "{"                  {  TLeftBrace  }
    "}"                  {  TRightBrace }
    ","                  {  TComma      }
    "["                  {  TLeftBrack  }
    "]"                  {  TRightBrack }


    "=="                 {  TComOp "==" }
    "!="                 {  TComOp "!=" }
    ">="                 {  TComOp "("  }
    "<="                 {  TComOp ")"  }
    ">"                  {  TComOp ">"  }
    "<"                  {  TComOp "<"  }

    "+"                  {  TOp    "+"  }
    "-"                  {  TOp    "-"  }
    "*"                  {  TOp    "*"  }
    "/"                  {  TOp    "/"  }
    "%"                  {  TOp    "%"  }
    "&"                  {  TOp    "&"  }
    "|"                  {  TOp    "|"  }


    char                { TChar           $$  }
    int_literal         { TIntLiteral     $$  }
    var                 { TName           $$  }
    string_literal      { TStringLiteral  $$  }



%left "|"
%left "&"
%nonassoc "<" ">" "<=" ">=" "==" "!="
%left "+" "-"
%left "*" "/" "%"
%left "!" NEG POS BANG
%nonassoc "(" ")"

%%

-- Something weird happens, if I compile only with Expr or L_Value rule (not both
-- at the same time, then Parser-bin works for that rule. But if I have them at the
-- same time then the same input will produce an error. Does this mean that both of
-- them create an ambiguity to the grammar the way we have implemented it? )

Expr : int_literal                       { Expr_Int   $1  }
     | char                              { Expr_Char  $1  }
     | L_Value                           { Expr_Lval  $1  }
     | "(" Expr ")"                      { Expr_Brack $2  }
     -- | Func_Call                         { Expr_Fcall $1  }
     | "+" Expr %prec POS                { Expr_Pos   $2  }
     | "-" Expr %prec NEG                { Expr_Neg   $2  }
     | Expr "+" Expr                     { Expr_Add $1 $3 }
     | Expr "-" Expr                     { Expr_Sub $1 $3 }
     | Expr "*" Expr                     { Expr_Tms $1 $3 }
     | Expr "/" Expr                     { Expr_Div $1 $3 }
     | Expr "%" Expr                     { Expr_Mod $1 $3 }

L_Value: var                             { LV_Var  $1     }
       -- | var "[" Expr "]"                { LV_Tbl  $1 $3  }
       | string_literal                  { LV_Lit  $1     }


{

parseError:: [Token]  -> a
parseError _ = error "oopsie daisy "

}
