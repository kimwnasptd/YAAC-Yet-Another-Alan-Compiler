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

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21
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
	| HappyAbsSyn12 t12
	| HappyAbsSyn13 t13
	| HappyAbsSyn14 t14
	| HappyAbsSyn15 t15
	| HappyAbsSyn16 t16
	| HappyAbsSyn17 t17
	| HappyAbsSyn18 t18
	| HappyAbsSyn19 t19
	| HappyAbsSyn20 t20
	| HappyAbsSyn21 t21

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,290) ([0,0,0,1024,0,0,0,128,0,0,0,0,0,512,0,0,0,0,0,0,0,0,0,0,0,18,0,0,2048,0,0,0,0,0,4,0,0,0,0,0,4,0,0,784,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,324,0,0,0,0,2,0,0,0,0,0,8704,0,0,0,0,32,2048,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32768,2,0,0,0,0,0,0,0,2,0,0,0,0,0,4352,0,0,0,12544,50,3072,0,0,0,0,0,0,0,0,0,256,0,0,0,8192,0,0,0,8,0,0,32768,49153,960,0,8192,0,0,0,0,0,0,0,0,0,0,0,528,0,0,0,0,0,0,8192,8,0,0,0,0,0,0,0,32768,0,0,0,0,0,0,4,3843,0,34832,24576,496,0,0,0,0,0,256,3968,0,0,0,0,0,0,0,0,0,0,49153,960,0,8192,6144,120,0,1024,768,15,0,0,0,0,0,0,0,0,8256,32770,1985,0,16384,12288,240,0,0,0,0,0,128,1984,0,0,57344,255,0,0,8,96,0,0,0,0,0,0,0,0,16384,544,49536,7,2048,68,63536,0,0,0,0,0,0,0,0,0,16384,63488,0,0,0,0,0,0,128,57440,1,0,16,15372,0,0,32770,1921,0,16384,12288,240,0,2048,1536,30,0,512,6144,0,0,2048,248,0,0,72,0,0,0,32,0,0,2048,0,0,0,0,0,0,0,64,61488,0,0,0,0,0,35904,4,768,0,8708,6144,124,32768,1088,33536,15,0,0,0,0,0,0,0,0,0,0,0,0,0,49152,1,0,0,14336,0,0,0,0,0,0,0,0,0,0,64520,31,0,0,1,12,0,18628,0,48,0,512,33152,7,0,64,61488,0,0,8,7686,0,0,49153,960,0,8192,6144,120,0,1024,768,15,0,0,0,0,0,0,124,0,0,32768,15,0,0,61440,1,0,0,15872,0,0,0,1984,0,0,0,248,0,0,0,0,0,0,0,0,0,0,32768,0,0,0,0,0,0,0,0,0,0,0,62,0,0,0,0,0,37256,0,96,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_basicParser","Program","Func_Def","L_Def_List","FPar_List","FPar_Def","Data_Type","Type","R_Type","Local_Def","Var_Def","Stmt","Comp_Stmt","Stmt_List","Func_Call","Expr_List","Expr","L_Value","Cond","byte","else","false","if","int","proc","reference","return","while","true","\".\"","\":\"","\";\"","\"(\"","\")\"","\"{\"","\"}\"","\",\"","\"[\"","\"]\"","\"=\"","\"==\"","\"!=\"","\">=\"","\"<=\"","\">\"","\"<\"","\"+\"","\"-\"","\"*\"","\"/\"","\"%\"","\"&\"","\"|\"","\"!\"","char","int_literal","var","string_literal","%eof"]
        bit_start = st * 61
        bit_end = (st + 1) * 61
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..60]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (59) = happyShift action_3
action_0 (4) = happyGoto action_4
action_0 (5) = happyGoto action_2
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (59) = happyShift action_3
action_1 (5) = happyGoto action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (35) = happyShift action_5
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (61) = happyAccept
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (7) = happyGoto action_6
action_5 _ = happyReduce_5

action_6 (36) = happyShift action_7
action_6 (39) = happyShift action_8
action_6 _ = happyFail (happyExpListPerState 6)

action_7 (33) = happyShift action_11
action_7 _ = happyFail (happyExpListPerState 7)

action_8 (59) = happyShift action_10
action_8 (8) = happyGoto action_9
action_8 _ = happyFail (happyExpListPerState 8)

action_9 _ = happyReduce_6

action_10 (33) = happyShift action_17
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (22) = happyShift action_14
action_11 (26) = happyShift action_15
action_11 (27) = happyShift action_16
action_11 (9) = happyGoto action_12
action_11 (11) = happyGoto action_13
action_11 _ = happyFail (happyExpListPerState 11)

action_12 _ = happyReduce_13

action_13 (6) = happyGoto action_21
action_13 _ = happyReduce_3

action_14 _ = happyReduce_10

action_15 _ = happyReduce_9

action_16 _ = happyReduce_14

action_17 (22) = happyShift action_14
action_17 (26) = happyShift action_15
action_17 (28) = happyShift action_20
action_17 (9) = happyGoto action_18
action_17 (10) = happyGoto action_19
action_17 _ = happyFail (happyExpListPerState 17)

action_18 (40) = happyShift action_29
action_18 _ = happyReduce_11

action_19 _ = happyReduce_8

action_20 (22) = happyShift action_14
action_20 (26) = happyShift action_15
action_20 (9) = happyGoto action_18
action_20 (10) = happyGoto action_28
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (37) = happyShift action_26
action_21 (59) = happyShift action_27
action_21 (5) = happyGoto action_22
action_21 (12) = happyGoto action_23
action_21 (13) = happyGoto action_24
action_21 (15) = happyGoto action_25
action_21 _ = happyFail (happyExpListPerState 21)

action_22 _ = happyReduce_15

action_23 _ = happyReduce_4

action_24 _ = happyReduce_16

action_25 _ = happyReduce_2

action_26 (16) = happyGoto action_32
action_26 _ = happyReduce_29

action_27 (33) = happyShift action_31
action_27 (35) = happyShift action_5
action_27 _ = happyFail (happyExpListPerState 27)

action_28 _ = happyReduce_7

action_29 (41) = happyShift action_30
action_29 _ = happyFail (happyExpListPerState 29)

action_30 _ = happyReduce_12

action_31 (22) = happyShift action_14
action_31 (26) = happyShift action_15
action_31 (9) = happyGoto action_44
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (25) = happyShift action_37
action_32 (29) = happyShift action_38
action_32 (30) = happyShift action_39
action_32 (34) = happyShift action_40
action_32 (37) = happyShift action_26
action_32 (38) = happyShift action_41
action_32 (59) = happyShift action_42
action_32 (60) = happyShift action_43
action_32 (14) = happyGoto action_33
action_32 (15) = happyGoto action_34
action_32 (17) = happyGoto action_35
action_32 (20) = happyGoto action_36
action_32 _ = happyFail (happyExpListPerState 32)

action_33 _ = happyReduce_30

action_34 _ = happyReduce_21

action_35 (34) = happyShift action_61
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (42) = happyShift action_60
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (35) = happyShift action_59
action_37 _ = happyFail (happyExpListPerState 37)

action_38 (34) = happyShift action_53
action_38 (35) = happyShift action_54
action_38 (49) = happyShift action_55
action_38 (50) = happyShift action_56
action_38 (57) = happyShift action_57
action_38 (58) = happyShift action_58
action_38 (59) = happyShift action_42
action_38 (60) = happyShift action_43
action_38 (17) = happyGoto action_50
action_38 (19) = happyGoto action_51
action_38 (20) = happyGoto action_52
action_38 _ = happyFail (happyExpListPerState 38)

action_39 (35) = happyShift action_49
action_39 _ = happyFail (happyExpListPerState 39)

action_40 _ = happyReduce_19

action_41 _ = happyReduce_28

action_42 (35) = happyShift action_47
action_42 (40) = happyShift action_48
action_42 _ = happyReduce_46

action_43 _ = happyReduce_48

action_44 (34) = happyShift action_45
action_44 (40) = happyShift action_46
action_44 _ = happyFail (happyExpListPerState 44)

action_45 _ = happyReduce_17

action_46 (58) = happyShift action_81
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (18) = happyGoto action_80
action_47 _ = happyReduce_32

action_48 (35) = happyShift action_54
action_48 (49) = happyShift action_55
action_48 (50) = happyShift action_56
action_48 (57) = happyShift action_57
action_48 (58) = happyShift action_58
action_48 (59) = happyShift action_42
action_48 (60) = happyShift action_43
action_48 (17) = happyGoto action_50
action_48 (19) = happyGoto action_79
action_48 (20) = happyGoto action_52
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (24) = happyShift action_65
action_49 (31) = happyShift action_66
action_49 (35) = happyShift action_67
action_49 (49) = happyShift action_55
action_49 (50) = happyShift action_56
action_49 (56) = happyShift action_68
action_49 (57) = happyShift action_57
action_49 (58) = happyShift action_58
action_49 (59) = happyShift action_42
action_49 (60) = happyShift action_43
action_49 (17) = happyGoto action_50
action_49 (19) = happyGoto action_63
action_49 (20) = happyGoto action_52
action_49 (21) = happyGoto action_78
action_49 _ = happyFail (happyExpListPerState 49)

action_50 _ = happyReduce_38

action_51 (34) = happyShift action_72
action_51 (49) = happyShift action_73
action_51 (50) = happyShift action_74
action_51 (51) = happyShift action_75
action_51 (52) = happyShift action_76
action_51 (53) = happyShift action_77
action_51 _ = happyFail (happyExpListPerState 51)

action_52 _ = happyReduce_36

action_53 _ = happyReduce_26

action_54 (35) = happyShift action_54
action_54 (49) = happyShift action_55
action_54 (50) = happyShift action_56
action_54 (57) = happyShift action_57
action_54 (58) = happyShift action_58
action_54 (59) = happyShift action_42
action_54 (60) = happyShift action_43
action_54 (17) = happyGoto action_50
action_54 (19) = happyGoto action_71
action_54 (20) = happyGoto action_52
action_54 _ = happyFail (happyExpListPerState 54)

action_55 (35) = happyShift action_54
action_55 (49) = happyShift action_55
action_55 (50) = happyShift action_56
action_55 (57) = happyShift action_57
action_55 (58) = happyShift action_58
action_55 (59) = happyShift action_42
action_55 (60) = happyShift action_43
action_55 (17) = happyGoto action_50
action_55 (19) = happyGoto action_70
action_55 (20) = happyGoto action_52
action_55 _ = happyFail (happyExpListPerState 55)

action_56 (35) = happyShift action_54
action_56 (49) = happyShift action_55
action_56 (50) = happyShift action_56
action_56 (57) = happyShift action_57
action_56 (58) = happyShift action_58
action_56 (59) = happyShift action_42
action_56 (60) = happyShift action_43
action_56 (17) = happyGoto action_50
action_56 (19) = happyGoto action_69
action_56 (20) = happyGoto action_52
action_56 _ = happyFail (happyExpListPerState 56)

action_57 _ = happyReduce_35

action_58 _ = happyReduce_34

action_59 (24) = happyShift action_65
action_59 (31) = happyShift action_66
action_59 (35) = happyShift action_67
action_59 (49) = happyShift action_55
action_59 (50) = happyShift action_56
action_59 (56) = happyShift action_68
action_59 (57) = happyShift action_57
action_59 (58) = happyShift action_58
action_59 (59) = happyShift action_42
action_59 (60) = happyShift action_43
action_59 (17) = happyGoto action_50
action_59 (19) = happyGoto action_63
action_59 (20) = happyGoto action_52
action_59 (21) = happyGoto action_64
action_59 _ = happyFail (happyExpListPerState 59)

action_60 (35) = happyShift action_54
action_60 (49) = happyShift action_55
action_60 (50) = happyShift action_56
action_60 (57) = happyShift action_57
action_60 (58) = happyShift action_58
action_60 (59) = happyShift action_42
action_60 (60) = happyShift action_43
action_60 (17) = happyGoto action_50
action_60 (19) = happyGoto action_62
action_60 (20) = happyGoto action_52
action_60 _ = happyFail (happyExpListPerState 60)

action_61 _ = happyReduce_22

action_62 (34) = happyShift action_105
action_62 (49) = happyShift action_73
action_62 (50) = happyShift action_74
action_62 (51) = happyShift action_75
action_62 (52) = happyShift action_76
action_62 (53) = happyShift action_77
action_62 _ = happyFail (happyExpListPerState 62)

action_63 (43) = happyShift action_99
action_63 (44) = happyShift action_100
action_63 (45) = happyShift action_101
action_63 (46) = happyShift action_102
action_63 (47) = happyShift action_103
action_63 (48) = happyShift action_104
action_63 (49) = happyShift action_73
action_63 (50) = happyShift action_74
action_63 (51) = happyShift action_75
action_63 (52) = happyShift action_76
action_63 (53) = happyShift action_77
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (36) = happyShift action_98
action_64 (54) = happyShift action_87
action_64 (55) = happyShift action_88
action_64 _ = happyFail (happyExpListPerState 64)

action_65 _ = happyReduce_50

action_66 _ = happyReduce_49

action_67 (24) = happyShift action_65
action_67 (31) = happyShift action_66
action_67 (35) = happyShift action_67
action_67 (49) = happyShift action_55
action_67 (50) = happyShift action_56
action_67 (56) = happyShift action_68
action_67 (57) = happyShift action_57
action_67 (58) = happyShift action_58
action_67 (59) = happyShift action_42
action_67 (60) = happyShift action_43
action_67 (17) = happyGoto action_50
action_67 (19) = happyGoto action_96
action_67 (20) = happyGoto action_52
action_67 (21) = happyGoto action_97
action_67 _ = happyFail (happyExpListPerState 67)

action_68 (24) = happyShift action_65
action_68 (31) = happyShift action_66
action_68 (35) = happyShift action_67
action_68 (49) = happyShift action_55
action_68 (50) = happyShift action_56
action_68 (56) = happyShift action_68
action_68 (57) = happyShift action_57
action_68 (58) = happyShift action_58
action_68 (59) = happyShift action_42
action_68 (60) = happyShift action_43
action_68 (17) = happyGoto action_50
action_68 (19) = happyGoto action_63
action_68 (20) = happyGoto action_52
action_68 (21) = happyGoto action_95
action_68 _ = happyFail (happyExpListPerState 68)

action_69 _ = happyReduce_40

action_70 _ = happyReduce_39

action_71 (36) = happyShift action_94
action_71 (49) = happyShift action_73
action_71 (50) = happyShift action_74
action_71 (51) = happyShift action_75
action_71 (52) = happyShift action_76
action_71 (53) = happyShift action_77
action_71 _ = happyFail (happyExpListPerState 71)

action_72 _ = happyReduce_27

action_73 (35) = happyShift action_54
action_73 (49) = happyShift action_55
action_73 (50) = happyShift action_56
action_73 (57) = happyShift action_57
action_73 (58) = happyShift action_58
action_73 (59) = happyShift action_42
action_73 (60) = happyShift action_43
action_73 (17) = happyGoto action_50
action_73 (19) = happyGoto action_93
action_73 (20) = happyGoto action_52
action_73 _ = happyFail (happyExpListPerState 73)

action_74 (35) = happyShift action_54
action_74 (49) = happyShift action_55
action_74 (50) = happyShift action_56
action_74 (57) = happyShift action_57
action_74 (58) = happyShift action_58
action_74 (59) = happyShift action_42
action_74 (60) = happyShift action_43
action_74 (17) = happyGoto action_50
action_74 (19) = happyGoto action_92
action_74 (20) = happyGoto action_52
action_74 _ = happyFail (happyExpListPerState 74)

action_75 (35) = happyShift action_54
action_75 (49) = happyShift action_55
action_75 (50) = happyShift action_56
action_75 (57) = happyShift action_57
action_75 (58) = happyShift action_58
action_75 (59) = happyShift action_42
action_75 (60) = happyShift action_43
action_75 (17) = happyGoto action_50
action_75 (19) = happyGoto action_91
action_75 (20) = happyGoto action_52
action_75 _ = happyFail (happyExpListPerState 75)

action_76 (35) = happyShift action_54
action_76 (49) = happyShift action_55
action_76 (50) = happyShift action_56
action_76 (57) = happyShift action_57
action_76 (58) = happyShift action_58
action_76 (59) = happyShift action_42
action_76 (60) = happyShift action_43
action_76 (17) = happyGoto action_50
action_76 (19) = happyGoto action_90
action_76 (20) = happyGoto action_52
action_76 _ = happyFail (happyExpListPerState 76)

action_77 (35) = happyShift action_54
action_77 (49) = happyShift action_55
action_77 (50) = happyShift action_56
action_77 (57) = happyShift action_57
action_77 (58) = happyShift action_58
action_77 (59) = happyShift action_42
action_77 (60) = happyShift action_43
action_77 (17) = happyGoto action_50
action_77 (19) = happyGoto action_89
action_77 (20) = happyGoto action_52
action_77 _ = happyFail (happyExpListPerState 77)

action_78 (36) = happyShift action_86
action_78 (54) = happyShift action_87
action_78 (55) = happyShift action_88
action_78 _ = happyFail (happyExpListPerState 78)

action_79 (41) = happyShift action_85
action_79 (49) = happyShift action_73
action_79 (50) = happyShift action_74
action_79 (51) = happyShift action_75
action_79 (52) = happyShift action_76
action_79 (53) = happyShift action_77
action_79 _ = happyFail (happyExpListPerState 79)

action_80 (36) = happyShift action_83
action_80 (39) = happyShift action_84
action_80 _ = happyFail (happyExpListPerState 80)

action_81 (41) = happyShift action_82
action_81 _ = happyFail (happyExpListPerState 81)

action_82 (34) = happyShift action_118
action_82 _ = happyFail (happyExpListPerState 82)

action_83 _ = happyReduce_31

action_84 (35) = happyShift action_54
action_84 (49) = happyShift action_55
action_84 (50) = happyShift action_56
action_84 (57) = happyShift action_57
action_84 (58) = happyShift action_58
action_84 (59) = happyShift action_42
action_84 (60) = happyShift action_43
action_84 (17) = happyGoto action_50
action_84 (19) = happyGoto action_117
action_84 (20) = happyGoto action_52
action_84 _ = happyFail (happyExpListPerState 84)

action_85 _ = happyReduce_47

action_86 (25) = happyShift action_37
action_86 (29) = happyShift action_38
action_86 (30) = happyShift action_39
action_86 (34) = happyShift action_40
action_86 (37) = happyShift action_26
action_86 (59) = happyShift action_42
action_86 (60) = happyShift action_43
action_86 (14) = happyGoto action_116
action_86 (15) = happyGoto action_34
action_86 (17) = happyGoto action_35
action_86 (20) = happyGoto action_36
action_86 _ = happyFail (happyExpListPerState 86)

action_87 (24) = happyShift action_65
action_87 (31) = happyShift action_66
action_87 (35) = happyShift action_67
action_87 (49) = happyShift action_55
action_87 (50) = happyShift action_56
action_87 (56) = happyShift action_68
action_87 (57) = happyShift action_57
action_87 (58) = happyShift action_58
action_87 (59) = happyShift action_42
action_87 (60) = happyShift action_43
action_87 (17) = happyGoto action_50
action_87 (19) = happyGoto action_63
action_87 (20) = happyGoto action_52
action_87 (21) = happyGoto action_115
action_87 _ = happyFail (happyExpListPerState 87)

action_88 (24) = happyShift action_65
action_88 (31) = happyShift action_66
action_88 (35) = happyShift action_67
action_88 (49) = happyShift action_55
action_88 (50) = happyShift action_56
action_88 (56) = happyShift action_68
action_88 (57) = happyShift action_57
action_88 (58) = happyShift action_58
action_88 (59) = happyShift action_42
action_88 (60) = happyShift action_43
action_88 (17) = happyGoto action_50
action_88 (19) = happyGoto action_63
action_88 (20) = happyGoto action_52
action_88 (21) = happyGoto action_114
action_88 _ = happyFail (happyExpListPerState 88)

action_89 _ = happyReduce_45

action_90 _ = happyReduce_44

action_91 _ = happyReduce_43

action_92 (51) = happyShift action_75
action_92 (52) = happyShift action_76
action_92 (53) = happyShift action_77
action_92 _ = happyReduce_42

action_93 (51) = happyShift action_75
action_93 (52) = happyShift action_76
action_93 (53) = happyShift action_77
action_93 _ = happyReduce_41

action_94 _ = happyReduce_37

action_95 _ = happyReduce_52

action_96 (36) = happyShift action_94
action_96 (43) = happyShift action_99
action_96 (44) = happyShift action_100
action_96 (45) = happyShift action_101
action_96 (46) = happyShift action_102
action_96 (47) = happyShift action_103
action_96 (48) = happyShift action_104
action_96 (49) = happyShift action_73
action_96 (50) = happyShift action_74
action_96 (51) = happyShift action_75
action_96 (52) = happyShift action_76
action_96 (53) = happyShift action_77
action_96 _ = happyFail (happyExpListPerState 96)

action_97 (36) = happyShift action_113
action_97 (54) = happyShift action_87
action_97 (55) = happyShift action_88
action_97 _ = happyFail (happyExpListPerState 97)

action_98 (25) = happyShift action_37
action_98 (29) = happyShift action_38
action_98 (30) = happyShift action_39
action_98 (34) = happyShift action_40
action_98 (37) = happyShift action_26
action_98 (59) = happyShift action_42
action_98 (60) = happyShift action_43
action_98 (14) = happyGoto action_112
action_98 (15) = happyGoto action_34
action_98 (17) = happyGoto action_35
action_98 (20) = happyGoto action_36
action_98 _ = happyFail (happyExpListPerState 98)

action_99 (35) = happyShift action_54
action_99 (49) = happyShift action_55
action_99 (50) = happyShift action_56
action_99 (57) = happyShift action_57
action_99 (58) = happyShift action_58
action_99 (59) = happyShift action_42
action_99 (60) = happyShift action_43
action_99 (17) = happyGoto action_50
action_99 (19) = happyGoto action_111
action_99 (20) = happyGoto action_52
action_99 _ = happyFail (happyExpListPerState 99)

action_100 (35) = happyShift action_54
action_100 (49) = happyShift action_55
action_100 (50) = happyShift action_56
action_100 (57) = happyShift action_57
action_100 (58) = happyShift action_58
action_100 (59) = happyShift action_42
action_100 (60) = happyShift action_43
action_100 (17) = happyGoto action_50
action_100 (19) = happyGoto action_110
action_100 (20) = happyGoto action_52
action_100 _ = happyFail (happyExpListPerState 100)

action_101 (35) = happyShift action_54
action_101 (49) = happyShift action_55
action_101 (50) = happyShift action_56
action_101 (57) = happyShift action_57
action_101 (58) = happyShift action_58
action_101 (59) = happyShift action_42
action_101 (60) = happyShift action_43
action_101 (17) = happyGoto action_50
action_101 (19) = happyGoto action_109
action_101 (20) = happyGoto action_52
action_101 _ = happyFail (happyExpListPerState 101)

action_102 (35) = happyShift action_54
action_102 (49) = happyShift action_55
action_102 (50) = happyShift action_56
action_102 (57) = happyShift action_57
action_102 (58) = happyShift action_58
action_102 (59) = happyShift action_42
action_102 (60) = happyShift action_43
action_102 (17) = happyGoto action_50
action_102 (19) = happyGoto action_108
action_102 (20) = happyGoto action_52
action_102 _ = happyFail (happyExpListPerState 102)

action_103 (35) = happyShift action_54
action_103 (49) = happyShift action_55
action_103 (50) = happyShift action_56
action_103 (57) = happyShift action_57
action_103 (58) = happyShift action_58
action_103 (59) = happyShift action_42
action_103 (60) = happyShift action_43
action_103 (17) = happyGoto action_50
action_103 (19) = happyGoto action_107
action_103 (20) = happyGoto action_52
action_103 _ = happyFail (happyExpListPerState 103)

action_104 (35) = happyShift action_54
action_104 (49) = happyShift action_55
action_104 (50) = happyShift action_56
action_104 (57) = happyShift action_57
action_104 (58) = happyShift action_58
action_104 (59) = happyShift action_42
action_104 (60) = happyShift action_43
action_104 (17) = happyGoto action_50
action_104 (19) = happyGoto action_106
action_104 (20) = happyGoto action_52
action_104 _ = happyFail (happyExpListPerState 104)

action_105 _ = happyReduce_20

action_106 (49) = happyShift action_73
action_106 (50) = happyShift action_74
action_106 (51) = happyShift action_75
action_106 (52) = happyShift action_76
action_106 (53) = happyShift action_77
action_106 _ = happyReduce_55

action_107 (49) = happyShift action_73
action_107 (50) = happyShift action_74
action_107 (51) = happyShift action_75
action_107 (52) = happyShift action_76
action_107 (53) = happyShift action_77
action_107 _ = happyReduce_56

action_108 (49) = happyShift action_73
action_108 (50) = happyShift action_74
action_108 (51) = happyShift action_75
action_108 (52) = happyShift action_76
action_108 (53) = happyShift action_77
action_108 _ = happyReduce_57

action_109 (49) = happyShift action_73
action_109 (50) = happyShift action_74
action_109 (51) = happyShift action_75
action_109 (52) = happyShift action_76
action_109 (53) = happyShift action_77
action_109 _ = happyReduce_58

action_110 (49) = happyShift action_73
action_110 (50) = happyShift action_74
action_110 (51) = happyShift action_75
action_110 (52) = happyShift action_76
action_110 (53) = happyShift action_77
action_110 _ = happyReduce_54

action_111 (49) = happyShift action_73
action_111 (50) = happyShift action_74
action_111 (51) = happyShift action_75
action_111 (52) = happyShift action_76
action_111 (53) = happyShift action_77
action_111 _ = happyReduce_53

action_112 (23) = happyShift action_119
action_112 _ = happyReduce_23

action_113 _ = happyReduce_51

action_114 (54) = happyShift action_87
action_114 _ = happyReduce_60

action_115 _ = happyReduce_59

action_116 _ = happyReduce_25

action_117 (49) = happyShift action_73
action_117 (50) = happyShift action_74
action_117 (51) = happyShift action_75
action_117 (52) = happyShift action_76
action_117 (53) = happyShift action_77
action_117 _ = happyReduce_33

action_118 _ = happyReduce_18

action_119 (25) = happyShift action_37
action_119 (29) = happyShift action_38
action_119 (30) = happyShift action_39
action_119 (34) = happyShift action_40
action_119 (37) = happyShift action_26
action_119 (59) = happyShift action_42
action_119 (60) = happyShift action_43
action_119 (14) = happyGoto action_120
action_119 (15) = happyGoto action_34
action_119 (17) = happyGoto action_35
action_119 (20) = happyGoto action_36
action_119 _ = happyFail (happyExpListPerState 119)

action_120 _ = happyReduce_24

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (Prog   happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happyReduce 8 5 happyReduction_2
happyReduction_2 ((HappyAbsSyn15  happy_var_8) `HappyStk`
	(HappyAbsSyn6  happy_var_7) `HappyStk`
	(HappyAbsSyn11  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName           happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 (F_Def happy_var_1 happy_var_3 happy_var_6 happy_var_7 happy_var_8
	) `HappyStk` happyRest

happyReduce_3 = happySpecReduce_0  6 happyReduction_3
happyReduction_3  =  HappyAbsSyn6
		 ([]
	)

happyReduce_4 = happySpecReduce_2  6 happyReduction_4
happyReduction_4 (HappyAbsSyn12  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_2 : happy_var_1
	)
happyReduction_4 _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_0  7 happyReduction_5
happyReduction_5  =  HappyAbsSyn7
		 ([]
	)

happyReduce_6 = happySpecReduce_3  7 happyReduction_6
happyReduction_6 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_3 : happy_var_1
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happyReduce 4 8 happyReduction_7
happyReduction_7 ((HappyAbsSyn10  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName           happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (FPar_Def_Ref happy_var_1 happy_var_4
	) `HappyStk` happyRest

happyReduce_8 = happySpecReduce_3  8 happyReduction_8
happyReduction_8 (HappyAbsSyn10  happy_var_3)
	_
	(HappyTerminal (TName           happy_var_1))
	 =  HappyAbsSyn8
		 (FPar_Def_NR happy_var_1 happy_var_3
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_1  9 happyReduction_9
happyReduction_9 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn9
		 (D_Type happy_var_1
	)
happyReduction_9 _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  9 happyReduction_10
happyReduction_10 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn9
		 (D_Type happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  10 happyReduction_11
happyReduction_11 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn10
		 (S_Type      happy_var_1
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  10 happyReduction_12
happyReduction_12 _
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn10
		 (Table_Type  happy_var_1
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_1  11 happyReduction_13
happyReduction_13 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn11
		 (R_Type_DT   happy_var_1
	)
happyReduction_13 _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_1  11 happyReduction_14
happyReduction_14 _
	 =  HappyAbsSyn11
		 (R_Type_Proc
	)

happyReduce_15 = happySpecReduce_1  12 happyReduction_15
happyReduction_15 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn12
		 (Loc_Def_Fun happy_var_1
	)
happyReduction_15 _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_1  12 happyReduction_16
happyReduction_16 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 (Loc_Def_Var happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happyReduce 4 13 happyReduction_17
happyReduction_17 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName           happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (VDef    happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_18 = happyReduce 7 13 happyReduction_18
happyReduction_18 (_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TIntLiteral     happy_var_5)) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName           happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (VDef_T  happy_var_1 happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_19 = happySpecReduce_1  14 happyReduction_19
happyReduction_19 _
	 =  HappyAbsSyn14
		 (Stmt_Semi
	)

happyReduce_20 = happyReduce 4 14 happyReduction_20
happyReduction_20 (_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Stmt_Eq  happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_21 = happySpecReduce_1  14 happyReduction_21
happyReduction_21 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (Stmt_Cmp  happy_var_1
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_2  14 happyReduction_22
happyReduction_22 _
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn14
		 (Stmt_FCall happy_var_1
	)
happyReduction_22 _ _  = notHappyAtAll 

happyReduce_23 = happyReduce 5 14 happyReduction_23
happyReduction_23 ((HappyAbsSyn14  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Stmt_If  happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_24 = happyReduce 7 14 happyReduction_24
happyReduction_24 ((HappyAbsSyn14  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn14  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Stmt_IFE happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_25 = happyReduce 5 14 happyReduction_25
happyReduction_25 ((HappyAbsSyn14  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Stmt_Wh  happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_26 = happySpecReduce_2  14 happyReduction_26
happyReduction_26 _
	_
	 =  HappyAbsSyn14
		 (Stmt_Ret
	)

happyReduce_27 = happySpecReduce_3  14 happyReduction_27
happyReduction_27 _
	(HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn14
		 (Stmt_Ret_Expr happy_var_2
	)
happyReduction_27 _ _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_3  15 happyReduction_28
happyReduction_28 _
	(HappyAbsSyn16  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (C_Stmt happy_var_2
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_0  16 happyReduction_29
happyReduction_29  =  HappyAbsSyn16
		 ([]
	)

happyReduce_30 = happySpecReduce_2  16 happyReduction_30
happyReduction_30 (HappyAbsSyn14  happy_var_2)
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_2 : happy_var_1
	)
happyReduction_30 _ _  = notHappyAtAll 

happyReduce_31 = happyReduce 4 17 happyReduction_31
happyReduction_31 (_ `HappyStk`
	(HappyAbsSyn18  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName           happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (Func_Call happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_32 = happySpecReduce_0  18 happyReduction_32
happyReduction_32  =  HappyAbsSyn18
		 ([]
	)

happyReduce_33 = happySpecReduce_3  18 happyReduction_33
happyReduction_33 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn18
		 (happy_var_3 : happy_var_1
	)
happyReduction_33 _ _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  19 happyReduction_34
happyReduction_34 (HappyTerminal (TIntLiteral     happy_var_1))
	 =  HappyAbsSyn19
		 (Expr_Int   happy_var_1
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_1  19 happyReduction_35
happyReduction_35 (HappyTerminal (TChar           happy_var_1))
	 =  HappyAbsSyn19
		 (Expr_Char  happy_var_1
	)
happyReduction_35 _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  19 happyReduction_36
happyReduction_36 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Lval  happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  19 happyReduction_37
happyReduction_37 _
	(HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn19
		 (Expr_Brack happy_var_2
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  19 happyReduction_38
happyReduction_38 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Fcall happy_var_1
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_2  19 happyReduction_39
happyReduction_39 (HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn19
		 (Expr_Pos   happy_var_2
	)
happyReduction_39 _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_2  19 happyReduction_40
happyReduction_40 (HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn19
		 (Expr_Neg   happy_var_2
	)
happyReduction_40 _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_3  19 happyReduction_41
happyReduction_41 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Add happy_var_1 happy_var_3
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  19 happyReduction_42
happyReduction_42 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Sub happy_var_1 happy_var_3
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_3  19 happyReduction_43
happyReduction_43 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Tms happy_var_1 happy_var_3
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  19 happyReduction_44
happyReduction_44 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Div happy_var_1 happy_var_3
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  19 happyReduction_45
happyReduction_45 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Mod happy_var_1 happy_var_3
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_1  20 happyReduction_46
happyReduction_46 (HappyTerminal (TName           happy_var_1))
	 =  HappyAbsSyn20
		 (LV_Var  happy_var_1
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happyReduce 4 20 happyReduction_47
happyReduction_47 (_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName           happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (LV_Tbl  happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_48 = happySpecReduce_1  20 happyReduction_48
happyReduction_48 (HappyTerminal (TStringLiteral  happy_var_1))
	 =  HappyAbsSyn20
		 (LV_Lit  happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  21 happyReduction_49
happyReduction_49 _
	 =  HappyAbsSyn21
		 (Cond_True
	)

happyReduce_50 = happySpecReduce_1  21 happyReduction_50
happyReduction_50 _
	 =  HappyAbsSyn21
		 (Cond_False
	)

happyReduce_51 = happySpecReduce_3  21 happyReduction_51
happyReduction_51 _
	(HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (Cond_Br   happy_var_2
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_2  21 happyReduction_52
happyReduction_52 (HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (Cond_Bang happy_var_2
	)
happyReduction_52 _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  21 happyReduction_53
happyReduction_53 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_Eq  happy_var_1 happy_var_3
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  21 happyReduction_54
happyReduction_54 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_Neq happy_var_1 happy_var_3
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_3  21 happyReduction_55
happyReduction_55 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_L   happy_var_1 happy_var_3
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  21 happyReduction_56
happyReduction_56 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_G   happy_var_1 happy_var_3
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  21 happyReduction_57
happyReduction_57 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_LE  happy_var_1 happy_var_3
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  21 happyReduction_58
happyReduction_58 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_GE  happy_var_1 happy_var_3
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  21 happyReduction_59
happyReduction_59 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_And happy_var_1 happy_var_3
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  21 happyReduction_60
happyReduction_60 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_Or  happy_var_1 happy_var_3
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexer(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	TEOF -> action 61 61 tk (HappyState action) sts stk;
	TByte -> cont 22;
	TElse -> cont 23;
	TFalse -> cont 24;
	TIf -> cont 25;
	TInt -> cont 26;
	TProc -> cont 27;
	TReference -> cont 28;
	TReturn -> cont 29;
	TWhile -> cont 30;
	TTrue -> cont 31;
	TPeriod -> cont 32;
	TColon -> cont 33;
	TSemiColon -> cont 34;
	TLeftParen -> cont 35;
	TRightParen -> cont 36;
	TLeftBrace -> cont 37;
	TRightBrace -> cont 38;
	TComma -> cont 39;
	TLeftBrack -> cont 40;
	TRightBrack -> cont 41;
	TAssign -> cont 42;
	TComOp "==" -> cont 43;
	TComOp "!=" -> cont 44;
	TComOp "(" -> cont 45;
	TComOp ")" -> cont 46;
	TComOp ">" -> cont 47;
	TComOp "<" -> cont 48;
	TOp    "+" -> cont 49;
	TOp    "-" -> cont 50;
	TOp    "*" -> cont 51;
	TOp    "/" -> cont 52;
	TOp    "%" -> cont 53;
	TOp    "&" -> cont 54;
	TOp    "|" -> cont 55;
	TOp    "!" -> cont 56;
	TChar           happy_dollar_dollar -> cont 57;
	TIntLiteral     happy_dollar_dollar -> cont 58;
	TName           happy_dollar_dollar -> cont 59;
	TStringLiteral  happy_dollar_dollar -> cont 60;
	_ -> happyError' (tk, [])
	})

happyError_ explist 61 tk = happyError' (tk, explist)
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
