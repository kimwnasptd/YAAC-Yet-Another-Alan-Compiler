{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module LibraryFunctions where

import SymbolTableTypes
import CodegenUtilities(externf)
import LLVM.AST
import LLVM.AST.Type

lib_fns :: [FunInfo]
lib_fns = [
    -- writeInteger(n : int) : proc
    FunInfo {
          fn_name = "writeInteger"
        , result_type = ProcType
        , fun_operand = Just $ externf (Name $ toShort "writeInteger") void [i32]
        , fn_args = [("n", IntType, False, False)]
    },
    -- writeString(s : reference byte[]) : proc
    FunInfo {
          fn_name = "writeString"
        , result_type = ProcType
        , fun_operand = Just $ externf (Name $ toShort "writeString") void [ptr i8]
        , fn_args = [("s", TableByteType, True, True)]
    },
    -- readInteger() : int
    FunInfo {
          fn_name = "readInteger"
        , result_type = IntType
        , fun_operand = Just $ externf (Name $ toShort "readInteger") i32 []
        , fn_args = []
    },
    -- readChar() : byte
    FunInfo {
          fn_name = "readChar"
        , result_type = ByteType
        , fun_operand = Just $ externf (Name $ toShort "readChar") i8 []
        , fn_args = []
    },
    -- readString(n:int, s:reference byte[]) : proc
    FunInfo {
          fn_name = "readString"
        , result_type = ProcType
        , fun_operand = Just $ externf (Name $ toShort "readString") void [i32, ptr i8]
        , fn_args = [("n", IntType, False, False), ("s", TableByteType, True, True)]
    }]
