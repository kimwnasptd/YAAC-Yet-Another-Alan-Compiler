module ASTTypes where
import Tokens


data Program = Prog Func_Def
             deriving (Eq, Show)


data Func_Def = F_Def String FPar_List R_Type L_Def_List Comp_Stmt
              deriving (Eq, Show)

-- It doesn't need a custom data type
type Stmt_List = [ Stmt ]


type L_Def_List = [ Local_Def ]             -- Local Functions or variables
 -- deriving (Eq, Show)

data Comp_Stmt = C_Stmt Stmt_List
 deriving (Eq, Show)


type FPar_List = [ FPar_Def ]


data FPar_Def = FPar_Def_Ref String Type
              | FPar_Def_NR String Type
               deriving (Eq, Show)

data Data_Type = D_Type Token   -- Parser takes care of us,
          deriving (Eq, Show)   -- only Token Int and Token Byte can reach this point

data Type = S_Type Data_Type
          | Table_Type Data_Type
          deriving (Eq, Show)


data R_Type = R_Type_DT Data_Type
            | R_Type_Proc
            deriving (Eq, Show)

data Local_Def = Loc_Def_Fun Func_Def
               | Loc_Def_Var Var_Def
               deriving (Eq, Show)

data Var_Def = VDef String Data_Type
             | VDef_T String Data_Type Int
             deriving (Eq, Show)

data Func_Call = Func_Call String Expr_List
               deriving (Eq, Show)


-- It doesn't need a custom data type -> I am sorry.
type Expr_List = [ Expr ]
               -- deriving (Eq, Show)


data Expr = Expr_Add Expr Expr   --
          | Expr_Sub Expr Expr  --
          | Expr_Tms Expr Expr  --
          | Expr_Div Expr Expr  --
          | Expr_Mod Expr Expr  --
          | Expr_Pos Expr
          | Expr_Neg Expr
          | Expr_Fcall Func_Call
          | Expr_Brack Expr   --
          | Expr_Lval L_Value   --
          | Expr_Char String
          | Expr_Int  Int    --
          deriving (Eq, Show)

data L_Value = LV_Var String --
             | LV_Tbl String Expr  --
             | LV_Lit String --
             deriving (Eq, Show)


data Stmt = Stmt_Semi  --
          | Stmt_Eq L_Value Expr  --
          | Stmt_Cmp Comp_Stmt
          | Stmt_FCall Func_Call
          | Stmt_If Cond Stmt
          | Stmt_IFE Cond Stmt Stmt
          | Stmt_Wh Cond Stmt
          | Stmt_Ret
          | Stmt_Ret_Expr Expr
          deriving (Eq, Show)



data Cond = Cond_True           -- done
          | Cond_False          -- done
          | Cond_Br Cond        -- done
          | Cond_Bang Cond
          | Cond_Eq Expr Expr   -- done
          | Cond_Neq Expr Expr  -- done
          | Cond_L Expr Expr    -- done
          | Cond_G Expr Expr    -- done
          | Cond_LE Expr Expr   -- done
          | Cond_GE Expr Expr   -- done
          | Cond_And Cond Cond  -- done
          | Cond_Or Cond Cond   -- done 
          deriving (Eq, Show)
