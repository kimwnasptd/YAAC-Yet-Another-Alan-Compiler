module ASTTypes where
import Tokens


data Program = Prog Func_Def


data Func_Def = F_Def_Vd String R_Type L_Def_List Comp_Stmt
              | F_Def_Par String FPar_List R_Type L_Def_List Comp_Stmt


data L_Def_List = L_Def_Empty
                | L_Def_L L_Def_List Local_Def



data Stmt_List = StmtL_Empty
               | StmtL Stmt_List Stmt


data Comp_Stmt = C_Stmt Stmt_List


-- FPar_List
data FPar_Def = FPar_Def_Ref String Type
              | FPar_Def_NR String Type

data Data_Type = D_Type Token
          deriving (Eq, Show)

data Type = S_Type Data_Type
          | Table_Type Data_Type
          deriving (Eq, Show)


data R_Type = R_Type_DT Data_Type
            | R_Type_Proc
            deriving (Eq, Show)

data Local_Def = Loc_Def_Fun Func_Def
               | Loc_Def_Var Var_Def

data Var_Def = VDef String Data_Type
             | VDef_T String Data_Type Int
             deriving (Eq, Show)

data Func_Call = Func_Call_Par String Expr_List
               | Func_Call_Void String
               deriving (Eq, Show)


data Expr_List = E_List_D Expr
               | E_List_L Expr_List Expr
               deriving (Eq, Show)


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
          | Expr_Char String
          | Expr_Int  Int
          deriving (Eq, Show)

data L_Value = LV_Var String
             | LV_Tbl String Expr
             | LV_Lit String
             deriving (Eq, Show)


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
