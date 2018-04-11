{-# OPTIONS_GHC -w #-}
module Parser where

import AlexInterface
import Tokens
import Lexer
import ASTTypes
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.9

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5
	| HappyAbsSyn6 t6
	| HappyAbsSyn7 t7
	| HappyAbsSyn8 t8
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,255) ([16384,1164,0,3,1024,0,0,0,0,0,0,0,0,0,0,0,0,64,0,0,0,2,0,8192,0,0,32768,0,0,0,8,0,0,0,0,0,16896,0,0,0,0,0,0,0,0,0,4,3843,34816,401,24576,8192,272,57536,3,0,0,0,17416,12288,248,0,32770,1921,0,0,0,0,0,0,0,512,7936,0,0,0,0,0,49153,960,0,8,7686,0,64,61488,0,0,0,0,0,0,0,0,65408,3,0,8,96,0,0,0,0,0,0,0,2177,1536,31,17416,12288,248,0,4,48,0,0,0,0,0,0,0,0,7937,0,16384,2,0,0,0,0,0,8,7686,0,0,0,0,512,33152,7,4096,3072,60,32768,24576,480,0,4,3843,0,32,30744,16384,1164,0,3,2177,1536,31,17416,12288,248,0,0,0,0,61472,127,0,256,3072,0,4657,0,12,8192,6144,120,0,49153,960,0,8,7686,0,64,61488,0,512,33152,7,4096,3072,60,0,0,0,0,0,0,0,64,248,0,0,0,0,0,0,0,0,61440,1,0,32768,15,0,0,124,0,0,992,0,0,7936,0,0,63488,0,0,0,0,0,0,0,0,0,512,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1792,0,0,14336,0,0,61440,1,6272,9,1536,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_basicParser","Stmt","Comp_Stmt","Stmt_List","Func_Call","Expr_List","Expr","L_Value","Cond","byte","else","false","if","int","proc","reference","return","while","true","\".\"","\":\"","\";\"","\"(\"","\")\"","\"{\"","\"}\"","\",\"","\"[\"","\"]\"","\"=\"","\"==\"","\"!=\"","\">=\"","\"<=\"","\">\"","\"<\"","\"+\"","\"-\"","\"*\"","\"/\"","\"%\"","\"&\"","\"|\"","\"!\"","char","int_literal","var","string_literal","%eof"]
        bit_start = st * 51
        bit_end = (st + 1) * 51
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..50]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (15) = happyShift action_7
action_0 (19) = happyShift action_8
action_0 (20) = happyShift action_9
action_0 (24) = happyShift action_2
action_0 (27) = happyShift action_10
action_0 (49) = happyShift action_11
action_0 (50) = happyShift action_12
action_0 (4) = happyGoto action_3
action_0 (5) = happyGoto action_4
action_0 (7) = happyGoto action_5
action_0 (10) = happyGoto action_6
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (24) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (51) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 _ = happyReduce_3

action_5 (24) = happyShift action_20
action_5 _ = happyFail (happyExpListPerState 5)

action_6 (32) = happyShift action_19
action_6 _ = happyFail (happyExpListPerState 6)

action_7 (25) = happyShift action_18
action_7 _ = happyFail (happyExpListPerState 7)

action_8 (24) = happyShift action_17
action_8 _ = happyFail (happyExpListPerState 8)

action_9 (25) = happyShift action_16
action_9 _ = happyFail (happyExpListPerState 9)

action_10 (6) = happyGoto action_15
action_10 _ = happyReduce_10

action_11 (25) = happyShift action_13
action_11 (30) = happyShift action_14
action_11 _ = happyReduce_27

action_12 _ = happyReduce_29

action_13 (8) = happyGoto action_39
action_13 _ = happyReduce_13

action_14 (25) = happyShift action_24
action_14 (39) = happyShift action_25
action_14 (40) = happyShift action_26
action_14 (47) = happyShift action_27
action_14 (48) = happyShift action_28
action_14 (49) = happyShift action_11
action_14 (50) = happyShift action_12
action_14 (7) = happyGoto action_21
action_14 (9) = happyGoto action_38
action_14 (10) = happyGoto action_23
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (15) = happyShift action_7
action_15 (19) = happyShift action_8
action_15 (20) = happyShift action_9
action_15 (24) = happyShift action_2
action_15 (27) = happyShift action_10
action_15 (28) = happyShift action_37
action_15 (49) = happyShift action_11
action_15 (50) = happyShift action_12
action_15 (4) = happyGoto action_36
action_15 (5) = happyGoto action_4
action_15 (7) = happyGoto action_5
action_15 (10) = happyGoto action_6
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (14) = happyShift action_31
action_16 (21) = happyShift action_32
action_16 (25) = happyShift action_33
action_16 (39) = happyShift action_25
action_16 (40) = happyShift action_26
action_16 (46) = happyShift action_34
action_16 (47) = happyShift action_27
action_16 (48) = happyShift action_28
action_16 (49) = happyShift action_11
action_16 (50) = happyShift action_12
action_16 (7) = happyGoto action_21
action_16 (9) = happyGoto action_29
action_16 (10) = happyGoto action_23
action_16 (11) = happyGoto action_35
action_16 _ = happyFail (happyExpListPerState 16)

action_17 _ = happyReduce_8

action_18 (14) = happyShift action_31
action_18 (21) = happyShift action_32
action_18 (25) = happyShift action_33
action_18 (39) = happyShift action_25
action_18 (40) = happyShift action_26
action_18 (46) = happyShift action_34
action_18 (47) = happyShift action_27
action_18 (48) = happyShift action_28
action_18 (49) = happyShift action_11
action_18 (50) = happyShift action_12
action_18 (7) = happyGoto action_21
action_18 (9) = happyGoto action_29
action_18 (10) = happyGoto action_23
action_18 (11) = happyGoto action_30
action_18 _ = happyFail (happyExpListPerState 18)

action_19 (25) = happyShift action_24
action_19 (39) = happyShift action_25
action_19 (40) = happyShift action_26
action_19 (47) = happyShift action_27
action_19 (48) = happyShift action_28
action_19 (49) = happyShift action_11
action_19 (50) = happyShift action_12
action_19 (7) = happyGoto action_21
action_19 (9) = happyGoto action_22
action_19 (10) = happyGoto action_23
action_19 _ = happyFail (happyExpListPerState 19)

action_20 _ = happyReduce_4

action_21 _ = happyReduce_19

action_22 (24) = happyShift action_64
action_22 (39) = happyShift action_43
action_22 (40) = happyShift action_44
action_22 (41) = happyShift action_45
action_22 (42) = happyShift action_46
action_22 (43) = happyShift action_47
action_22 _ = happyFail (happyExpListPerState 22)

action_23 _ = happyReduce_17

action_24 (25) = happyShift action_24
action_24 (39) = happyShift action_25
action_24 (40) = happyShift action_26
action_24 (47) = happyShift action_27
action_24 (48) = happyShift action_28
action_24 (49) = happyShift action_11
action_24 (50) = happyShift action_12
action_24 (7) = happyGoto action_21
action_24 (9) = happyGoto action_63
action_24 (10) = happyGoto action_23
action_24 _ = happyFail (happyExpListPerState 24)

action_25 (25) = happyShift action_24
action_25 (39) = happyShift action_25
action_25 (40) = happyShift action_26
action_25 (47) = happyShift action_27
action_25 (48) = happyShift action_28
action_25 (49) = happyShift action_11
action_25 (50) = happyShift action_12
action_25 (7) = happyGoto action_21
action_25 (9) = happyGoto action_62
action_25 (10) = happyGoto action_23
action_25 _ = happyFail (happyExpListPerState 25)

action_26 (25) = happyShift action_24
action_26 (39) = happyShift action_25
action_26 (40) = happyShift action_26
action_26 (47) = happyShift action_27
action_26 (48) = happyShift action_28
action_26 (49) = happyShift action_11
action_26 (50) = happyShift action_12
action_26 (7) = happyGoto action_21
action_26 (9) = happyGoto action_61
action_26 (10) = happyGoto action_23
action_26 _ = happyFail (happyExpListPerState 26)

action_27 _ = happyReduce_16

action_28 _ = happyReduce_15

action_29 (33) = happyShift action_55
action_29 (34) = happyShift action_56
action_29 (35) = happyShift action_57
action_29 (36) = happyShift action_58
action_29 (37) = happyShift action_59
action_29 (38) = happyShift action_60
action_29 (39) = happyShift action_43
action_29 (40) = happyShift action_44
action_29 (41) = happyShift action_45
action_29 (42) = happyShift action_46
action_29 (43) = happyShift action_47
action_29 _ = happyFail (happyExpListPerState 29)

action_30 (26) = happyShift action_54
action_30 (44) = happyShift action_49
action_30 (45) = happyShift action_50
action_30 _ = happyFail (happyExpListPerState 30)

action_31 _ = happyReduce_31

action_32 _ = happyReduce_30

action_33 (14) = happyShift action_31
action_33 (21) = happyShift action_32
action_33 (25) = happyShift action_33
action_33 (39) = happyShift action_25
action_33 (40) = happyShift action_26
action_33 (46) = happyShift action_34
action_33 (47) = happyShift action_27
action_33 (48) = happyShift action_28
action_33 (49) = happyShift action_11
action_33 (50) = happyShift action_12
action_33 (7) = happyGoto action_21
action_33 (9) = happyGoto action_52
action_33 (10) = happyGoto action_23
action_33 (11) = happyGoto action_53
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (14) = happyShift action_31
action_34 (21) = happyShift action_32
action_34 (25) = happyShift action_33
action_34 (39) = happyShift action_25
action_34 (40) = happyShift action_26
action_34 (46) = happyShift action_34
action_34 (47) = happyShift action_27
action_34 (48) = happyShift action_28
action_34 (49) = happyShift action_11
action_34 (50) = happyShift action_12
action_34 (7) = happyGoto action_21
action_34 (9) = happyGoto action_29
action_34 (10) = happyGoto action_23
action_34 (11) = happyGoto action_51
action_34 _ = happyFail (happyExpListPerState 34)

action_35 (26) = happyShift action_48
action_35 (44) = happyShift action_49
action_35 (45) = happyShift action_50
action_35 _ = happyFail (happyExpListPerState 35)

action_36 _ = happyReduce_11

action_37 _ = happyReduce_9

action_38 (31) = happyShift action_42
action_38 (39) = happyShift action_43
action_38 (40) = happyShift action_44
action_38 (41) = happyShift action_45
action_38 (42) = happyShift action_46
action_38 (43) = happyShift action_47
action_38 _ = happyFail (happyExpListPerState 38)

action_39 (26) = happyShift action_40
action_39 (29) = happyShift action_41
action_39 _ = happyFail (happyExpListPerState 39)

action_40 _ = happyReduce_12

action_41 (25) = happyShift action_24
action_41 (39) = happyShift action_25
action_41 (40) = happyShift action_26
action_41 (47) = happyShift action_27
action_41 (48) = happyShift action_28
action_41 (49) = happyShift action_11
action_41 (50) = happyShift action_12
action_41 (7) = happyGoto action_21
action_41 (9) = happyGoto action_82
action_41 (10) = happyGoto action_23
action_41 _ = happyFail (happyExpListPerState 41)

action_42 _ = happyReduce_28

action_43 (25) = happyShift action_24
action_43 (39) = happyShift action_25
action_43 (40) = happyShift action_26
action_43 (47) = happyShift action_27
action_43 (48) = happyShift action_28
action_43 (49) = happyShift action_11
action_43 (50) = happyShift action_12
action_43 (7) = happyGoto action_21
action_43 (9) = happyGoto action_81
action_43 (10) = happyGoto action_23
action_43 _ = happyFail (happyExpListPerState 43)

action_44 (25) = happyShift action_24
action_44 (39) = happyShift action_25
action_44 (40) = happyShift action_26
action_44 (47) = happyShift action_27
action_44 (48) = happyShift action_28
action_44 (49) = happyShift action_11
action_44 (50) = happyShift action_12
action_44 (7) = happyGoto action_21
action_44 (9) = happyGoto action_80
action_44 (10) = happyGoto action_23
action_44 _ = happyFail (happyExpListPerState 44)

action_45 (25) = happyShift action_24
action_45 (39) = happyShift action_25
action_45 (40) = happyShift action_26
action_45 (47) = happyShift action_27
action_45 (48) = happyShift action_28
action_45 (49) = happyShift action_11
action_45 (50) = happyShift action_12
action_45 (7) = happyGoto action_21
action_45 (9) = happyGoto action_79
action_45 (10) = happyGoto action_23
action_45 _ = happyFail (happyExpListPerState 45)

action_46 (25) = happyShift action_24
action_46 (39) = happyShift action_25
action_46 (40) = happyShift action_26
action_46 (47) = happyShift action_27
action_46 (48) = happyShift action_28
action_46 (49) = happyShift action_11
action_46 (50) = happyShift action_12
action_46 (7) = happyGoto action_21
action_46 (9) = happyGoto action_78
action_46 (10) = happyGoto action_23
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (25) = happyShift action_24
action_47 (39) = happyShift action_25
action_47 (40) = happyShift action_26
action_47 (47) = happyShift action_27
action_47 (48) = happyShift action_28
action_47 (49) = happyShift action_11
action_47 (50) = happyShift action_12
action_47 (7) = happyGoto action_21
action_47 (9) = happyGoto action_77
action_47 (10) = happyGoto action_23
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (15) = happyShift action_7
action_48 (19) = happyShift action_8
action_48 (20) = happyShift action_9
action_48 (24) = happyShift action_2
action_48 (27) = happyShift action_10
action_48 (49) = happyShift action_11
action_48 (50) = happyShift action_12
action_48 (4) = happyGoto action_76
action_48 (5) = happyGoto action_4
action_48 (7) = happyGoto action_5
action_48 (10) = happyGoto action_6
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (14) = happyShift action_31
action_49 (21) = happyShift action_32
action_49 (25) = happyShift action_33
action_49 (39) = happyShift action_25
action_49 (40) = happyShift action_26
action_49 (46) = happyShift action_34
action_49 (47) = happyShift action_27
action_49 (48) = happyShift action_28
action_49 (49) = happyShift action_11
action_49 (50) = happyShift action_12
action_49 (7) = happyGoto action_21
action_49 (9) = happyGoto action_29
action_49 (10) = happyGoto action_23
action_49 (11) = happyGoto action_75
action_49 _ = happyFail (happyExpListPerState 49)

action_50 (14) = happyShift action_31
action_50 (21) = happyShift action_32
action_50 (25) = happyShift action_33
action_50 (39) = happyShift action_25
action_50 (40) = happyShift action_26
action_50 (46) = happyShift action_34
action_50 (47) = happyShift action_27
action_50 (48) = happyShift action_28
action_50 (49) = happyShift action_11
action_50 (50) = happyShift action_12
action_50 (7) = happyGoto action_21
action_50 (9) = happyGoto action_29
action_50 (10) = happyGoto action_23
action_50 (11) = happyGoto action_74
action_50 _ = happyFail (happyExpListPerState 50)

action_51 _ = happyReduce_33

action_52 (26) = happyShift action_65
action_52 (33) = happyShift action_55
action_52 (34) = happyShift action_56
action_52 (35) = happyShift action_57
action_52 (36) = happyShift action_58
action_52 (37) = happyShift action_59
action_52 (38) = happyShift action_60
action_52 (39) = happyShift action_43
action_52 (40) = happyShift action_44
action_52 (41) = happyShift action_45
action_52 (42) = happyShift action_46
action_52 (43) = happyShift action_47
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (26) = happyShift action_73
action_53 (44) = happyShift action_49
action_53 (45) = happyShift action_50
action_53 _ = happyFail (happyExpListPerState 53)

action_54 (15) = happyShift action_7
action_54 (19) = happyShift action_8
action_54 (20) = happyShift action_9
action_54 (24) = happyShift action_2
action_54 (27) = happyShift action_10
action_54 (49) = happyShift action_11
action_54 (50) = happyShift action_12
action_54 (4) = happyGoto action_72
action_54 (5) = happyGoto action_4
action_54 (7) = happyGoto action_5
action_54 (10) = happyGoto action_6
action_54 _ = happyFail (happyExpListPerState 54)

action_55 (25) = happyShift action_24
action_55 (39) = happyShift action_25
action_55 (40) = happyShift action_26
action_55 (47) = happyShift action_27
action_55 (48) = happyShift action_28
action_55 (49) = happyShift action_11
action_55 (50) = happyShift action_12
action_55 (7) = happyGoto action_21
action_55 (9) = happyGoto action_71
action_55 (10) = happyGoto action_23
action_55 _ = happyFail (happyExpListPerState 55)

action_56 (25) = happyShift action_24
action_56 (39) = happyShift action_25
action_56 (40) = happyShift action_26
action_56 (47) = happyShift action_27
action_56 (48) = happyShift action_28
action_56 (49) = happyShift action_11
action_56 (50) = happyShift action_12
action_56 (7) = happyGoto action_21
action_56 (9) = happyGoto action_70
action_56 (10) = happyGoto action_23
action_56 _ = happyFail (happyExpListPerState 56)

action_57 (25) = happyShift action_24
action_57 (39) = happyShift action_25
action_57 (40) = happyShift action_26
action_57 (47) = happyShift action_27
action_57 (48) = happyShift action_28
action_57 (49) = happyShift action_11
action_57 (50) = happyShift action_12
action_57 (7) = happyGoto action_21
action_57 (9) = happyGoto action_69
action_57 (10) = happyGoto action_23
action_57 _ = happyFail (happyExpListPerState 57)

action_58 (25) = happyShift action_24
action_58 (39) = happyShift action_25
action_58 (40) = happyShift action_26
action_58 (47) = happyShift action_27
action_58 (48) = happyShift action_28
action_58 (49) = happyShift action_11
action_58 (50) = happyShift action_12
action_58 (7) = happyGoto action_21
action_58 (9) = happyGoto action_68
action_58 (10) = happyGoto action_23
action_58 _ = happyFail (happyExpListPerState 58)

action_59 (25) = happyShift action_24
action_59 (39) = happyShift action_25
action_59 (40) = happyShift action_26
action_59 (47) = happyShift action_27
action_59 (48) = happyShift action_28
action_59 (49) = happyShift action_11
action_59 (50) = happyShift action_12
action_59 (7) = happyGoto action_21
action_59 (9) = happyGoto action_67
action_59 (10) = happyGoto action_23
action_59 _ = happyFail (happyExpListPerState 59)

action_60 (25) = happyShift action_24
action_60 (39) = happyShift action_25
action_60 (40) = happyShift action_26
action_60 (47) = happyShift action_27
action_60 (48) = happyShift action_28
action_60 (49) = happyShift action_11
action_60 (50) = happyShift action_12
action_60 (7) = happyGoto action_21
action_60 (9) = happyGoto action_66
action_60 (10) = happyGoto action_23
action_60 _ = happyFail (happyExpListPerState 60)

action_61 _ = happyReduce_21

action_62 _ = happyReduce_20

action_63 (26) = happyShift action_65
action_63 (39) = happyShift action_43
action_63 (40) = happyShift action_44
action_63 (41) = happyShift action_45
action_63 (42) = happyShift action_46
action_63 (43) = happyShift action_47
action_63 _ = happyFail (happyExpListPerState 63)

action_64 _ = happyReduce_2

action_65 _ = happyReduce_18

action_66 (39) = happyShift action_43
action_66 (40) = happyShift action_44
action_66 (41) = happyShift action_45
action_66 (42) = happyShift action_46
action_66 (43) = happyShift action_47
action_66 _ = happyReduce_36

action_67 (39) = happyShift action_43
action_67 (40) = happyShift action_44
action_67 (41) = happyShift action_45
action_67 (42) = happyShift action_46
action_67 (43) = happyShift action_47
action_67 _ = happyReduce_37

action_68 (39) = happyShift action_43
action_68 (40) = happyShift action_44
action_68 (41) = happyShift action_45
action_68 (42) = happyShift action_46
action_68 (43) = happyShift action_47
action_68 _ = happyReduce_38

action_69 (39) = happyShift action_43
action_69 (40) = happyShift action_44
action_69 (41) = happyShift action_45
action_69 (42) = happyShift action_46
action_69 (43) = happyShift action_47
action_69 _ = happyReduce_39

action_70 (39) = happyShift action_43
action_70 (40) = happyShift action_44
action_70 (41) = happyShift action_45
action_70 (42) = happyShift action_46
action_70 (43) = happyShift action_47
action_70 _ = happyReduce_35

action_71 (39) = happyShift action_43
action_71 (40) = happyShift action_44
action_71 (41) = happyShift action_45
action_71 (42) = happyShift action_46
action_71 (43) = happyShift action_47
action_71 _ = happyReduce_34

action_72 (13) = happyShift action_83
action_72 _ = happyReduce_5

action_73 _ = happyReduce_32

action_74 (44) = happyShift action_49
action_74 _ = happyReduce_41

action_75 _ = happyReduce_40

action_76 _ = happyReduce_7

action_77 _ = happyReduce_26

action_78 _ = happyReduce_25

action_79 _ = happyReduce_24

action_80 (41) = happyShift action_45
action_80 (42) = happyShift action_46
action_80 (43) = happyShift action_47
action_80 _ = happyReduce_23

action_81 (41) = happyShift action_45
action_81 (42) = happyShift action_46
action_81 (43) = happyShift action_47
action_81 _ = happyReduce_22

action_82 (39) = happyShift action_43
action_82 (40) = happyShift action_44
action_82 (41) = happyShift action_45
action_82 (42) = happyShift action_46
action_82 (43) = happyShift action_47
action_82 _ = happyReduce_14

action_83 (15) = happyShift action_7
action_83 (19) = happyShift action_8
action_83 (20) = happyShift action_9
action_83 (24) = happyShift action_2
action_83 (27) = happyShift action_10
action_83 (49) = happyShift action_11
action_83 (50) = happyShift action_12
action_83 (4) = happyGoto action_84
action_83 (5) = happyGoto action_4
action_83 (7) = happyGoto action_5
action_83 (10) = happyGoto action_6
action_83 _ = happyFail (happyExpListPerState 83)

action_84 _ = happyReduce_6

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 _
	 =  HappyAbsSyn4
		 (Stmt_Semi
	)

happyReduce_2 = happyReduce 4 4 happyReduction_2
happyReduction_2 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (Stmt_Eq  happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_3 = happySpecReduce_1  4 happyReduction_3
happyReduction_3 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (Stmt_Cmp  happy_var_1
	)
happyReduction_3 _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_2  4 happyReduction_4
happyReduction_4 _
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn4
		 (Stmt_FCall happy_var_1
	)
happyReduction_4 _ _  = notHappyAtAll 

happyReduce_5 = happyReduce 5 4 happyReduction_5
happyReduction_5 ((HappyAbsSyn4  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (Stmt_If  happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_6 = happyReduce 7 4 happyReduction_6
happyReduction_6 ((HappyAbsSyn4  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (Stmt_IFE happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_7 = happyReduce 5 4 happyReduction_7
happyReduction_7 ((HappyAbsSyn4  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (Stmt_Wh  happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_8 = happySpecReduce_2  4 happyReduction_8
happyReduction_8 _
	_
	 =  HappyAbsSyn4
		 (Stmt_Ret
	)

happyReduce_9 = happySpecReduce_3  5 happyReduction_9
happyReduction_9 _
	(HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn5
		 (C_Stmt happy_var_2
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_0  6 happyReduction_10
happyReduction_10  =  HappyAbsSyn6
		 ([]
	)

happyReduce_11 = happySpecReduce_2  6 happyReduction_11
happyReduction_11 (HappyAbsSyn4  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_2 : happy_var_1
	)
happyReduction_11 _ _  = notHappyAtAll 

happyReduce_12 = happyReduce 4 7 happyReduction_12
happyReduction_12 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName           happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (Func_Call happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_13 = happySpecReduce_0  8 happyReduction_13
happyReduction_13  =  HappyAbsSyn8
		 ([]
	)

happyReduce_14 = happySpecReduce_3  8 happyReduction_14
happyReduction_14 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_3 : happy_var_1
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_1  9 happyReduction_15
happyReduction_15 (HappyTerminal (TIntLiteral     happy_var_1))
	 =  HappyAbsSyn9
		 (Expr_Int   happy_var_1
	)
happyReduction_15 _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_1  9 happyReduction_16
happyReduction_16 (HappyTerminal (TChar           happy_var_1))
	 =  HappyAbsSyn9
		 (Expr_Char  happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  9 happyReduction_17
happyReduction_17 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 (Expr_Lval  happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  9 happyReduction_18
happyReduction_18 _
	(HappyAbsSyn9  happy_var_2)
	_
	 =  HappyAbsSyn9
		 (Expr_Brack happy_var_2
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_1  9 happyReduction_19
happyReduction_19 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn9
		 (Expr_Fcall happy_var_1
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_2  9 happyReduction_20
happyReduction_20 (HappyAbsSyn9  happy_var_2)
	_
	 =  HappyAbsSyn9
		 (Expr_Pos   happy_var_2
	)
happyReduction_20 _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_2  9 happyReduction_21
happyReduction_21 (HappyAbsSyn9  happy_var_2)
	_
	 =  HappyAbsSyn9
		 (Expr_Neg   happy_var_2
	)
happyReduction_21 _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  9 happyReduction_22
happyReduction_22 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (Expr_Add happy_var_1 happy_var_3
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_3  9 happyReduction_23
happyReduction_23 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (Expr_Sub happy_var_1 happy_var_3
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  9 happyReduction_24
happyReduction_24 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (Expr_Tms happy_var_1 happy_var_3
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_3  9 happyReduction_25
happyReduction_25 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (Expr_Div happy_var_1 happy_var_3
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  9 happyReduction_26
happyReduction_26 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (Expr_Mod happy_var_1 happy_var_3
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  10 happyReduction_27
happyReduction_27 (HappyTerminal (TName           happy_var_1))
	 =  HappyAbsSyn10
		 (LV_Var  happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happyReduce 4 10 happyReduction_28
happyReduction_28 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName           happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (LV_Tbl  happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_29 = happySpecReduce_1  10 happyReduction_29
happyReduction_29 (HappyTerminal (TStringLiteral  happy_var_1))
	 =  HappyAbsSyn10
		 (LV_Lit  happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  11 happyReduction_30
happyReduction_30 _
	 =  HappyAbsSyn11
		 (Cond_True
	)

happyReduce_31 = happySpecReduce_1  11 happyReduction_31
happyReduction_31 _
	 =  HappyAbsSyn11
		 (Cond_False
	)

happyReduce_32 = happySpecReduce_3  11 happyReduction_32
happyReduction_32 _
	(HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (Cond_Br   happy_var_2
	)
happyReduction_32 _ _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_2  11 happyReduction_33
happyReduction_33 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (Cond_Bang happy_var_2
	)
happyReduction_33 _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_3  11 happyReduction_34
happyReduction_34 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn11
		 (Cond_Eq  happy_var_1 happy_var_3
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  11 happyReduction_35
happyReduction_35 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn11
		 (Cond_Neq happy_var_1 happy_var_3
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_3  11 happyReduction_36
happyReduction_36 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn11
		 (Cond_L   happy_var_1 happy_var_3
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  11 happyReduction_37
happyReduction_37 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn11
		 (Cond_G   happy_var_1 happy_var_3
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_3  11 happyReduction_38
happyReduction_38 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn11
		 (Cond_LE  happy_var_1 happy_var_3
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_3  11 happyReduction_39
happyReduction_39 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn11
		 (Cond_GE  happy_var_1 happy_var_3
	)
happyReduction_39 _ _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_3  11 happyReduction_40
happyReduction_40 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (Cond_And happy_var_1 happy_var_3
	)
happyReduction_40 _ _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_3  11 happyReduction_41
happyReduction_41 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (Cond_Or  happy_var_1 happy_var_3
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexer(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	TEOF -> action 51 51 tk (HappyState action) sts stk;
	TByte -> cont 12;
	TElse -> cont 13;
	TFalse -> cont 14;
	TIf -> cont 15;
	TInt -> cont 16;
	TProc -> cont 17;
	TReference -> cont 18;
	TReturn -> cont 19;
	TWhile -> cont 20;
	TTrue -> cont 21;
	TPeriod -> cont 22;
	TColon -> cont 23;
	TSemiColon -> cont 24;
	TLeftParen -> cont 25;
	TRightParen -> cont 26;
	TLeftBrace -> cont 27;
	TRightBrace -> cont 28;
	TComma -> cont 29;
	TLeftBrack -> cont 30;
	TRightBrack -> cont 31;
	TAssign -> cont 32;
	TComOp "==" -> cont 33;
	TComOp "!=" -> cont 34;
	TComOp "(" -> cont 35;
	TComOp ")" -> cont 36;
	TComOp ">" -> cont 37;
	TComOp "<" -> cont 38;
	TOp    "+" -> cont 39;
	TOp    "-" -> cont 40;
	TOp    "*" -> cont 41;
	TOp    "/" -> cont 42;
	TOp    "%" -> cont 43;
	TOp    "&" -> cont 44;
	TOp    "|" -> cont 45;
	TOp    "!" -> cont 46;
	TChar           happy_dollar_dollar -> cont 47;
	TIntLiteral     happy_dollar_dollar -> cont 48;
	TName           happy_dollar_dollar -> cont 49;
	TStringLiteral  happy_dollar_dollar -> cont 50;
	_ -> happyError' (tk, [])
	})

happyError_ explist 51 tk = happyError' (tk, explist)
happyError_ explist _ tk = happyError' (tk, explist)

happyThen :: () => P a -> (a -> P b) -> P b
happyThen = (>>=)
happyReturn :: () => a -> P a
happyReturn = (return)
happyThen1 :: () => P a -> (a -> P b) -> P b
happyThen1 = happyThen
happyReturn1 :: () => a -> P a
happyReturn1 = happyReturn
happyError' :: () => ((Token), [String]) -> P a
happyError' tk = (\(tokens, _) -> parseError tokens) tk
basicParser = happySomeParser where
 happySomeParser = happyThen (happyParse action_0) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


-- Basic Error Messages
-- parseError:: [Token]  -> a
-- parseError _ = error "oopsie daisy "

parseError _ = do
  lno <- getLineNo
  error $ "Parse error on line "++ show lno

-- parse::String->[(String,Int)]
parse s = evalP basicParser s
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}







# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4














































{-# LINE 7 "<command-line>" #-}
{-# LINE 1 "/usr/lib/ghc-8.2.2/include/ghcversion.h" #-}















{-# LINE 7 "<command-line>" #-}
{-# LINE 1 "/tmp/ghc4375_0/ghc_2.h" #-}












































































































































































































































































































































































































































































































































































































































































































{-# LINE 7 "<command-line>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 









{-# LINE 43 "templates/GenericTemplate.hs" #-}

data Happy_IntList = HappyCons Int Happy_IntList







{-# LINE 65 "templates/GenericTemplate.hs" #-}

{-# LINE 75 "templates/GenericTemplate.hs" #-}

{-# LINE 84 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 137 "templates/GenericTemplate.hs" #-}

{-# LINE 147 "templates/GenericTemplate.hs" #-}
indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x < y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `div` 16)) (bit `mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 267 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 333 "templates/GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
