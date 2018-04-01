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

-- Program: Func_Def

-- Func_Def: 
--     var "(" ")" ":" R_Type L_Def_List Comp_Stmt           {- Empty -}     
--   | var "(" Fpar_List ")" ":" R_Type L_Def_List Comp_Stmt 

-- L_Def_List: {- Empty -}             { [] }
--           | L_Def_List Local_Def    { $2 : $1 }


-- Fpar_List: Fpar_Def
--          | Fpar_List "," Fpar_Def

-- Fpar_Def: var ":" reference Type
--         | var ":" Type

-- Data_Type: int
--          | byte

-- Type: Data_Type
--     | Data_Type "[" "]"

-- R_Type: Data_Type
--       | proc

-- Local_Def: Func_Def
--          | Var_Def

-- Var_Def: var ":" Data_Type ";"
--        | var: Data_Type "[" int_literal "]" ";"

-- Stmt: ;
--     | L_Value "=" Expr ";"
--     | Comp_Stmt
--     | Func_Call ";"
--     | if "(" Cond ")" Stmt
--     | if "(" Cond ")" Stmt else Stmt
--     | while "(" Cond ")" Stmt
--     | return ";"

Comp_Stmt: "{" Stmt_List "}"    { $2 }

Stmt_List: {-Nothing -}         { [] }
         | Stmt_List Stmt       { $2 : $1 }


Expr : int_literal
     | char
     | L_Value
     | "(" Expr ")"
     | Func_Call
     | "+" Expr %prec POS
     | "-" Expr %prec NEG
     | Expr "+" Expr
     | Expr "-" Expr
     | Expr "*" Expr
     | Expr "/" Expr
     | Expr "%" Expr

L_Value: var
       | "[" Expr "]"
       | string_literal


Cond: "true"
    | "false"
    | "(" Cond ")"
    | "!" Cond %prec BANG
    | Expr "==" Expr
    | Expr "!=" Expr
    | Expr "<"  Expr
    | Expr ">"  Expr
    | Expr "<=" Expr
    | Expr ">=" Expr
    | Cond "&"  Cond
    | Cond "|"  Cond

Func_Call: var "(" Expr_List ")"
         | var "(" ")"

Expr_List: Expr
         | Expr_List "," Expr


{

parseError:: [Token]  -> a
parseError _ = error "oopsie daisy "

-- parseError :: [Token] -> a
-- parseError tokenList = let pos = tokenPosn(head(tokenList)) 
--   in 
--   error ("parse error at line " ++ show(getLineNum(pos)) ++ " and column " ++ show(getColumnNum(pos)))

}
