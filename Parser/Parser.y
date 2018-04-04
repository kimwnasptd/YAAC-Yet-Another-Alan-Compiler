{
module Parser where
import Lexer
}


%name nucky
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
%left NEG POS BANG




%%

Program: Func_Def                        { Prog   $1      }

Func_Def: var "(" ")" ":" R_Type L_Def_List Comp_Stmt           { F_Def_Vd $1 $5 $6 $7 }
        | var "(" FPar_List ")" ":" R_Type L_Def_List Comp_Stmt { F_Def_Par $1 $3 $6 $7 $8 }

L_Def_List:                              { L_Def_Empty    }
          | L_Def_List Local_Def         { L_Def_L $1 $2  }


FPar_List: FPar_Def                      { FParL_Def   $1 }
         | FPar_List "," FPar_Def        { FParL_Lst $1 $2}

FPar_Def: var ":" reference Type         { FPar_Def_Ref $1 $4}
        | var ":" Type                   { FPar_Def_NR $1 $3 }

Data_Type: int                           { D_Type Int     }
         | byte                          { D_Type Byte    }

Type: Data_Type                          { S_Type      $1 }
    | Data_Type "[" "]"                  { Table_Type  $1 }

R_Type: Data_Type                        { R_Type_DT   $1 }
      | proc                             { R_Type_Proc    }

Local_Def: Func_Def                      { Loc_Def_Fun $1 }
         | Var_Def                       { Loc_Def_Var $1 }

Var_Def: var ":" Data_Type ";"                      { VDef    $1 $3 }
       | var ":" Data_Type "[" int_literal "]" ";"  { VDef_T  $1 $3 $5   }

Stmt: ";"                                { Stmt_Semi      }
    | L_Value "=" Expr ";"               { Stmt_Eq  $1 $3 }
    | Comp_Stmt                          { Stmt_Cmp  $1   }
    | Func_Call ";"                      { Stmt_FCall $1  }
    | if "(" Cond ")" Stmt               { Stmt_If  $3 $5 }
    | if "(" Cond ")" Stmt else Stmt     { Stmt_IFE $3 $5 $7}
    | while "(" Cond ")" Stmt            { Stmt_Wh  $3 $5 }
    | return ";"                         { Stmt_Ret       }

Comp_Stmt: "{" Stmt_List "}"             { C_Stmt $2      }

Stmt_List: {-Nothing -}                  { StmtL_Empty    }
         | Stmt_List Stmt                { StmtL  $1 $2   }  -- Probaby ALL LISTS NEED AMENDING


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
       | "[" Expr "]"                    { LV_Tbl  $2     }
       | string_literal                  { LV_Lit  $1     }


Cond: "true"                             { Cond_True      }
    | "false"                            { Cond_False     }
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

Func_Call: var "(" Expr_List ")"         { Fucn_Call_Par $1 $3 }
         | var "(" ")"                   { Func_Call_Void  $1  }

Expr_List: Expr                          { E_List_D $1    }
         | Expr_List "," Expr            { E_List_L $1 $3 }


{

parseError:: [Token]  -> a
parseError _ = error "oopsie daisy "

-- parseError :: [Token] -> a
-- parseError tokenList = let pos = tokenPosn(head(tokenList))
--   in
--   error ("parse error at line " ++ show(getLineNum(pos)) ++ " and column " ++ show(getColumnNum(pos)))

Expr : int_literal                      { Expr_Int   $1 }
     | char                             { Expr_Char  $1 }
     | L_Value                          { Expr_Lval  $1 }
     | "(" Expr ")"                     { Expr_Brack $2 }
     | Func_Call                        { Expr_Fcall $1 }
     | "+" Expr %prec POS               { Expr_Pos   $2 }
     | "-" Expr %prec NEG               { Expr_Neg   $2 }
     | Expr "+" Expr                    { Expr_Add $1 $3}
     | Expr "-" Expr                    { Expr_Sub $1 $3}
     | Expr "*" Expr                    { Expr_Tms $1 $3}
     | Expr "/" Expr                    { Expr_Div $1 $3}
     | Expr "%" Expr                    { Expr_Mod $1 $3}

data Expr = Expr_Add Expr Expr
          | Expr_Sub Expr Expr
          | Expr_Tms Expr Expr
          | Expr_Div Expr Expr
          | Expr_Mod Expr Expr
          | Expr_Pos Expr
          | Expr_Neg Expr
          | Expr_Fcall Func_Call
          | Expr_Brack Expr
          | Expr_Lval L_Value
          | Expr_Char ???
          | Expr_Int  ???


data Stmt = Stmt_Semi
          | Stmt_Eq L_Value Expr
          | Stmt_Cmp Comp_Stmt
          | Stmt_FCall Func_Call
          | Stmt_If Cond Stmt
          | Stmt_IFE Cond Stmt Stmt
          | Stmt_Wh Cond Stmt
          | Stmt_Ret



data Cond = Cond_True
          | Cond_False
          | Cond_Br Cond
          | Cond_Bang Cond
          | Cond_Eq Expr Expr
          | Cond_Neq Expr Expr
          | Cond_L Expr Expr
          | Cond_G Expr Expr
          | Cond_LE Expr Expr
          | Cond_GE Expr Expr
          | Cond_And Cond Cond
          | Cond_Or Cond Cond


data FPar_List = FParL_Def FPar_Def
               | FParL_Lst FPar_List FPar_Def



FPar_Def: var ":" reference Type         { FPar_Def_Ref $1 $4}
        | var ":" Type                   { FPar_Def_NR $1 $3 }

data FPar_Def = FPar_Def_Ref ???? Type
              | FPar_Def_NR ??? Type


data Data_Type = D_Type Int
               | D_Type Byte

data Type = S_Type Data_Type
          | Table_Type Data_Type

data R_Type = R_Type_DT Data_Type
            | R_Type_Proc

data Local_Def = Loc_Def_Fun Func_Def
               | Loc_Def_Var Var_Def




Func_Call: var "(" Expr_List ")"         { Fucn_Call_Par $1 $3 }
         | var "(" ")"                   { Func_Call_Void  $1  }


data Func_Call = Func_Call_Par ???? Expr_List
               | Func_Call_Void ????



data Expr_List = E_List_D Expr
               | E_List_L Expr_List Expr



data Program = Prog Func_Def


data Func_Def = F_Def_Vd ???? R_Type L_Def_List Comp_Stmt
              | F_Def_Par ???? FPar_List R_Type L_Def_List Comp_Stmt


data L_Def_List = L_Def_Empty
                | L_Def_L L_Def_List Local_Def


L_Value: var                             { LV_Var  $1     }
       | "[" Expr "]"                    { LV_Tbl  $2     }
       | string_literal                  { LV_Lit  $1     }


data L_Value = LV_Var ????
             | LV_Tbl Expr
             | LV_Lit ????


Stmt_List: {-Nothing -}                  { StmtL_Empty    }
         | Stmt_List Stmt                { StmtL  $1 $2   }  -- Probaby ALL LISTS NEED AMENDING

data Stmt_List = StmtL_Empty
               | StmtL Stmt_List Stmt

Var_Def: var ":" Data_Type ";"                      { VDef    $1 $3 }
       | var ":" Data_Type "[" int_literal "]" ";"  { VDef_T  $1 $3 $5   }

data Var_Def = VDef ???? Data_Type
             | VDef_T ???? Data_Type ????


data Comp_Stmt = C_Stmt Stmt_List

}
