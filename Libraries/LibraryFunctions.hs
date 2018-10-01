{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module LibraryFunctions where

import SymbolTableTypes
import CodegenUtilities(externf)
import LLVM.AST
import LLVM.AST.Type

lib_fns :: [FunInfo]
lib_fns = [
    ----------------------------------------------------------------------------
    -- Write functions
    ----------------------------------------------------------------------------
    -- writeInteger(n : int) : proc
    FunInfo {
          fn_name = "writeInteger"
        , result_type = ProcType
        , fun_operand = Just $ externf (Name $ toShort "writeInteger") void [i32]
        , fn_args = [("n", IntType, False, False)]
    },
    -- writeString(s : reference byte[]) : proc
    FunInfo {
          fn_name = "writeByte"
        , result_type = ProcType
        , fun_operand = Just $ externf (Name $ toShort "writeByte") void [i8]
        , fn_args = [("b", ByteType, False, False)]
    },
    -- writeString(s : reference byte[]) : proc
    FunInfo {
          fn_name = "writeChar"
        , result_type = ProcType
        , fun_operand = Just $ externf (Name $ toShort "writeChar") void [i8]
        , fn_args = [("b", ByteType, False, False)]
    },
    -- writeString(s : reference byte[]) : proc
    FunInfo {
          fn_name = "writeString"
        , result_type = ProcType
        , fun_operand = Just $ externf (Name $ toShort "writeString") void [ptr i8]
        , fn_args = [("s", TableByteType, True, True)]
    },
    ----------------------------------------------------------------------------
    -- Read functions
    ----------------------------------------------------------------------------
    -- readInteger() : int
    FunInfo {
          fn_name = "readInteger"
        , result_type = IntType
        , fun_operand = Just $ externf (Name $ toShort "readInteger") i32 []
        , fn_args = []
    },
    -- readByte() : byte
    FunInfo {
          fn_name = "readByte"
        , result_type = ByteType
        , fun_operand = Just $ externf (Name $ toShort "readByte") i8 []
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
    },
    ----------------------------------------------------------------------------
    -- String functions
    ----------------------------------------------------------------------------
    -- strlen(s:reference byte[]) : int
    FunInfo {
          fn_name = "strlen"
        , result_type = IntType
        , fun_operand = Just $ externf (Name $ toShort "strlen") i32 [ptr i8]
        , fn_args = [("s", TableByteType, True, True)]
    },
    -- strcmp(s1:reference byte[], s2:reference byte[]) : int
    FunInfo {
          fn_name = "strcmp"
        , result_type = IntType
        , fun_operand = Just $ externf (Name $ toShort "strcmp") i32 [ptr i8, ptr i8]
        , fn_args = [("s1", TableByteType, True, True), ("s2", TableByteType, True, True)]
    },
    -- strcpy(trg:reference byte[], src:reference byte[]) : proc
    FunInfo {
          fn_name = "strcpy"
        , result_type = ProcType
        , fun_operand = Just $ externf (Name $ toShort "strcpy") void [ptr i8, ptr i8]
        , fn_args = [("trg", TableByteType, True, True), ("src", TableByteType, True, True)]
    },
    -- strcat(s1:reference byte[], s2:reference byte[]) : int
    FunInfo {
          fn_name = "strcat"
        , result_type = ProcType
        , fun_operand = Just $ externf (Name $ toShort "strcat") void [ptr i8, ptr i8]
        , fn_args = [("trg", TableByteType, True, True), ("src", TableByteType, True, True)]
    },
    ----------------------------------------------------------------------------
    -- Extra functions
    ----------------------------------------------------------------------------
    -- extend(b:byte) : int
    FunInfo {
          fn_name = "extend"
        , result_type = IntType
        , fun_operand = Just $ externf (Name $ toShort "extend") i32 [i8]
        , fn_args = [("b", ByteType, False, False)]
    },
    -- shrink(i:int) : byte
    FunInfo {
          fn_name = "shrink"
        , result_type = ByteType
        , fun_operand = Just $ externf (Name $ toShort "shrink") i8 [i32]
        , fn_args = [("i", IntType, False, False)]
    }]
