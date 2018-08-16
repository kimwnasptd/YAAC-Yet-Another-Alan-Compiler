{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module DefaultFunctions where

import SymbolTableTypes
import CodegenUtilities(externf)
import LLVM.AST
import LLVM.AST.Type

lib_fns :: [FunInfo]
lib_fns = []
    -- writeInteger(n : int) : proc
    -- FunInfo {
    --       fn_name = "writeInteger"
    --     , result_type = ProcType
    --     , fun_operand = Just $ externf (Name $ toShort "writeInteger") void [i32]
    --     , fn_args = [("n", IntType, False, False)]
    -- } ]--,
    -- FunInfo {
    --       fn_name = "readInteger"
    --     , result_type = IntType
    --     , fun_operand = Just $ externf (Name $ toShort "readInteger") i32 []
    --     , fn_args = []
    -- }]
