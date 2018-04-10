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
    "="                  {  TAssign     }


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


%%

-- It works up to here

Data_Type: int                           { D_Type $1      }
         | byte                          { D_Type $1      }

Type: Data_Type                          { S_Type      $1 }
    | Data_Type "[" "]"                  { Table_Type  $1 }

R_Type: Data_Type                        { R_Type_DT   $1 }
      | proc                             { R_Type_Proc    }


Func_Call: var "(" Expr_List ")"         { Func_Call_Par $1 $3 }
         | var "(" ")"                   { Func_Call_Void  $1  }

Expr_List: Expr                          {    [ $1 ]      }
         | Expr_List "," Expr            {    $3 : $1     }

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


Program: Func_Def                        { Prog   $1      }

Func_Def: var "(" ")" ":" R_Type L_Def_List Comp_Stmt           { F_Def_Vd $1 $5 $6 $7 }
        | var "(" FPar_List ")" ":" R_Type L_Def_List Comp_Stmt { F_Def_Par $1 $3 $6 $7 $8 }

L_Def_List:                              {       []       }
          | L_Def_List Local_Def         {     $2 : $1    }


FPar_List: FPar_Def                      {      [$1]      }
         | FPar_List "," FPar_Def        {     $3 : $1    }

FPar_Def: var ":" reference Type         { FPar_Def_Ref $1 $4}
        | var ":" Type                   { FPar_Def_NR $1 $3 }


Local_Def: Func_Def                      { Loc_Def_Fun $1 }
         | Var_Def                       { Loc_Def_Var $1 }

Stmt: ";"                                { Stmt_Semi      }
    | L_Value "=" Expr ";"               { Stmt_Eq  $1 $3 }
    | Comp_Stmt                          { Stmt_Cmp  $1   }
    | Func_Call ";"                      { Stmt_FCall $1  }
    | if "(" Cond ")" Stmt               { Stmt_If  $3 $5 }
    | if "(" Cond ")" Stmt else Stmt     { Stmt_IFE $3 $5 $7}
    | while "(" Cond ")" Stmt            { Stmt_Wh  $3 $5 }
    | return ";"                         { Stmt_Ret       }

Comp_Stmt: "{" Stmt_List "}"             { C_Stmt $2      }

Stmt_List: {-Nothing -}                  {       []       }
         | Stmt_List Stmt                {     $2 : $1    }  -- Probaby ALL LISTS NEED AMENDING


Var_Def: var ":" Data_Type ";"                      { VDef    $1 $3 }
       | var ":" Data_Type "[" int_literal "]" ";"  { VDef_T  $1 $3 $5   }

Cond: true                               { Cond_True      }
    | false                              { Cond_False     }
    | "(" Cond ")"                       { Cond_Br   $2   }
    | "!" Cond %prec BANG                { Cond_Bang $2   }
    | Expr "==" Expr                     { Cond_Eq  $1 $3 }
    | Expr "!=" Expr                     { Cond_Neq $1 $3 }
    | Expr "<"  Expr                     { Cond_L   $1 $3 }
    | Expr ">"  Expr                     { Cond_G   $1 $3 }
    | Expr "<=" Expr                     { Cond_LE  $1 $3 }
    | Expr ">=" Expr                     { Cond_GE  $1 $3 }
    | Cond "&"  Cond                     { Cond_And $1 $3 }
    | Cond "|"  Cond                     { Cond_Or  $1 $3 }



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
