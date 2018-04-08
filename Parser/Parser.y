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
%monad {P}
%lexer {lexer} {TEOF}


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
    ":"                  {  TColon      }
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
    "!"                  {  TOp    "!"  }


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

-- It works up to here

Data_Type: int                           { D_Type $1    } 
         | byte                          { D_Type $1    }

Type: Data_Type                          { S_Type      $1 }
    | Data_Type "[" "]"                  { Table_Type  $1 }

R_Type: Data_Type                        { R_Type_DT   $1 }
      | proc                             { R_Type_Proc    }

Var_Def: var ":" Data_Type ";"                      { VDef    $1 $3 }
       | var ":" Data_Type "[" int_literal "]" ";"  { VDef_T  $1 $3 $5   }

Func_Call: var "(" Expr_List ")"         { Func_Call_Par $1 $3 }
         | var "(" ")"                   { Func_Call_Void  $1  }

Expr_List: Expr                          { E_List_D $1    }
         | Expr_List "," Expr            { E_List_L $1 $3 }

Expr : int_literal                       { Expr_Int   $1  }
     | char                              { Expr_Char  $1  }
     | L_Value                           { Expr_Lval  $1  }
     | "(" Expr ")"                      { Expr_Brack $2  }
     | Func_Call                         { Expr_Fcall $1  }
     | "+" Expr %prec POS                { Expr_Pos   $2  }
     | "-" Expr %prec NEG                { Expr_Neg   $2  }
     | Expr "+" Expr                     { Expr_Add $1 $3 }
     | Expr "-" Expr                     { Expr_Sub $1 $3 }
     | Expr "*" Expr                     { Expr_Tms $1 $3 }
     | Expr "/" Expr                     { Expr_Div $1 $3 }
     | Expr "%" Expr                     { Expr_Mod $1 $3 }

L_Value: var                             { LV_Var  $1     }
       | var "[" Expr "]"                { LV_Tbl  $1 $3  }
       | string_literal                  { LV_Lit  $1     }


{

-- Basic Error Messages
-- parseError:: [Token]  -> a
-- parseError _ = error "oopsie daisy "

parseError _ = do
  lno <- getLineNo
  error $ "Parse error on line "++ show lno

-- parse::String->[(String,Int)]
parse s = evalP basicParser s

}
