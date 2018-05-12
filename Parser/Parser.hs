{-# OPTIONS_GHC -w #-}
module Parser where

import AlexInterface
import Tokens
import Lexer
import ASTTypes
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.5

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

action_0 (59) = happyShift action_3
action_0 (4) = happyGoto action_4
action_0 (5) = happyGoto action_2
action_0 _ = happyFail

action_1 (59) = happyShift action_3
action_1 (5) = happyGoto action_2
action_1 _ = happyFail

action_2 _ = happyReduce_1

action_3 (35) = happyShift action_5
action_3 _ = happyFail

action_4 (61) = happyAccept
action_4 _ = happyFail

action_5 (59) = happyShift action_8
action_5 (7) = happyGoto action_6
action_5 (8) = happyGoto action_7
action_5 _ = happyReduce_5

action_6 (36) = happyShift action_10
action_6 (39) = happyShift action_11
action_6 _ = happyFail

action_7 _ = happyReduce_6

action_8 (33) = happyShift action_9
action_8 _ = happyFail

action_9 (22) = happyShift action_16
action_9 (26) = happyShift action_17
action_9 (28) = happyShift action_18
action_9 (9) = happyGoto action_14
action_9 (10) = happyGoto action_15
action_9 _ = happyFail

action_10 (33) = happyShift action_13
action_10 _ = happyFail

action_11 (59) = happyShift action_8
action_11 (8) = happyGoto action_12
action_11 _ = happyFail

action_12 _ = happyReduce_7

action_13 (22) = happyShift action_16
action_13 (26) = happyShift action_17
action_13 (27) = happyShift action_23
action_13 (9) = happyGoto action_21
action_13 (11) = happyGoto action_22
action_13 _ = happyFail

action_14 (40) = happyShift action_20
action_14 _ = happyReduce_12

action_15 _ = happyReduce_9

action_16 _ = happyReduce_11

action_17 _ = happyReduce_10

action_18 (22) = happyShift action_16
action_18 (26) = happyShift action_17
action_18 (9) = happyGoto action_14
action_18 (10) = happyGoto action_19
action_18 _ = happyFail

action_19 _ = happyReduce_8

action_20 (41) = happyShift action_25
action_20 _ = happyFail

action_21 _ = happyReduce_14

action_22 (6) = happyGoto action_24
action_22 _ = happyReduce_3

action_23 _ = happyReduce_15

action_24 (37) = happyShift action_30
action_24 (59) = happyShift action_31
action_24 (5) = happyGoto action_26
action_24 (12) = happyGoto action_27
action_24 (13) = happyGoto action_28
action_24 (15) = happyGoto action_29
action_24 _ = happyFail

action_25 _ = happyReduce_13

action_26 _ = happyReduce_16

action_27 _ = happyReduce_4

action_28 _ = happyReduce_17

action_29 _ = happyReduce_2

action_30 (16) = happyGoto action_33
action_30 _ = happyReduce_30

action_31 (33) = happyShift action_32
action_31 (35) = happyShift action_5
action_31 _ = happyFail

action_32 (22) = happyShift action_16
action_32 (26) = happyShift action_17
action_32 (9) = happyGoto action_45
action_32 _ = happyFail

action_33 (25) = happyShift action_38
action_33 (29) = happyShift action_39
action_33 (30) = happyShift action_40
action_33 (34) = happyShift action_41
action_33 (37) = happyShift action_30
action_33 (38) = happyShift action_42
action_33 (59) = happyShift action_43
action_33 (60) = happyShift action_44
action_33 (14) = happyGoto action_34
action_33 (15) = happyGoto action_35
action_33 (17) = happyGoto action_36
action_33 (20) = happyGoto action_37
action_33 _ = happyFail

action_34 _ = happyReduce_31

action_35 _ = happyReduce_22

action_36 (34) = happyShift action_62
action_36 _ = happyFail

action_37 (42) = happyShift action_61
action_37 _ = happyFail

action_38 (35) = happyShift action_60
action_38 _ = happyFail

action_39 (34) = happyShift action_54
action_39 (35) = happyShift action_55
action_39 (49) = happyShift action_56
action_39 (50) = happyShift action_57
action_39 (57) = happyShift action_58
action_39 (58) = happyShift action_59
action_39 (59) = happyShift action_43
action_39 (60) = happyShift action_44
action_39 (17) = happyGoto action_51
action_39 (19) = happyGoto action_52
action_39 (20) = happyGoto action_53
action_39 _ = happyFail

action_40 (35) = happyShift action_50
action_40 _ = happyFail

action_41 _ = happyReduce_20

action_42 _ = happyReduce_29

action_43 (35) = happyShift action_48
action_43 (40) = happyShift action_49
action_43 _ = happyReduce_48

action_44 _ = happyReduce_50

action_45 (34) = happyShift action_46
action_45 (40) = happyShift action_47
action_45 _ = happyFail

action_46 _ = happyReduce_18

action_47 (58) = happyShift action_83
action_47 _ = happyFail

action_48 (35) = happyShift action_55
action_48 (49) = happyShift action_56
action_48 (50) = happyShift action_57
action_48 (57) = happyShift action_58
action_48 (58) = happyShift action_59
action_48 (59) = happyShift action_43
action_48 (60) = happyShift action_44
action_48 (17) = happyGoto action_51
action_48 (18) = happyGoto action_81
action_48 (19) = happyGoto action_82
action_48 (20) = happyGoto action_53
action_48 _ = happyReduce_33

action_49 (35) = happyShift action_55
action_49 (49) = happyShift action_56
action_49 (50) = happyShift action_57
action_49 (57) = happyShift action_58
action_49 (58) = happyShift action_59
action_49 (59) = happyShift action_43
action_49 (60) = happyShift action_44
action_49 (17) = happyGoto action_51
action_49 (19) = happyGoto action_80
action_49 (20) = happyGoto action_53
action_49 _ = happyFail

action_50 (24) = happyShift action_66
action_50 (31) = happyShift action_67
action_50 (35) = happyShift action_68
action_50 (49) = happyShift action_56
action_50 (50) = happyShift action_57
action_50 (56) = happyShift action_69
action_50 (57) = happyShift action_58
action_50 (58) = happyShift action_59
action_50 (59) = happyShift action_43
action_50 (60) = happyShift action_44
action_50 (17) = happyGoto action_51
action_50 (19) = happyGoto action_64
action_50 (20) = happyGoto action_53
action_50 (21) = happyGoto action_79
action_50 _ = happyFail

action_51 _ = happyReduce_40

action_52 (34) = happyShift action_73
action_52 (49) = happyShift action_74
action_52 (50) = happyShift action_75
action_52 (51) = happyShift action_76
action_52 (52) = happyShift action_77
action_52 (53) = happyShift action_78
action_52 _ = happyFail

action_53 _ = happyReduce_38

action_54 _ = happyReduce_27

action_55 (35) = happyShift action_55
action_55 (49) = happyShift action_56
action_55 (50) = happyShift action_57
action_55 (57) = happyShift action_58
action_55 (58) = happyShift action_59
action_55 (59) = happyShift action_43
action_55 (60) = happyShift action_44
action_55 (17) = happyGoto action_51
action_55 (19) = happyGoto action_72
action_55 (20) = happyGoto action_53
action_55 _ = happyFail

action_56 (35) = happyShift action_55
action_56 (49) = happyShift action_56
action_56 (50) = happyShift action_57
action_56 (57) = happyShift action_58
action_56 (58) = happyShift action_59
action_56 (59) = happyShift action_43
action_56 (60) = happyShift action_44
action_56 (17) = happyGoto action_51
action_56 (19) = happyGoto action_71
action_56 (20) = happyGoto action_53
action_56 _ = happyFail

action_57 (35) = happyShift action_55
action_57 (49) = happyShift action_56
action_57 (50) = happyShift action_57
action_57 (57) = happyShift action_58
action_57 (58) = happyShift action_59
action_57 (59) = happyShift action_43
action_57 (60) = happyShift action_44
action_57 (17) = happyGoto action_51
action_57 (19) = happyGoto action_70
action_57 (20) = happyGoto action_53
action_57 _ = happyFail

action_58 _ = happyReduce_37

action_59 _ = happyReduce_36

action_60 (24) = happyShift action_66
action_60 (31) = happyShift action_67
action_60 (35) = happyShift action_68
action_60 (49) = happyShift action_56
action_60 (50) = happyShift action_57
action_60 (56) = happyShift action_69
action_60 (57) = happyShift action_58
action_60 (58) = happyShift action_59
action_60 (59) = happyShift action_43
action_60 (60) = happyShift action_44
action_60 (17) = happyGoto action_51
action_60 (19) = happyGoto action_64
action_60 (20) = happyGoto action_53
action_60 (21) = happyGoto action_65
action_60 _ = happyFail

action_61 (35) = happyShift action_55
action_61 (49) = happyShift action_56
action_61 (50) = happyShift action_57
action_61 (57) = happyShift action_58
action_61 (58) = happyShift action_59
action_61 (59) = happyShift action_43
action_61 (60) = happyShift action_44
action_61 (17) = happyGoto action_51
action_61 (19) = happyGoto action_63
action_61 (20) = happyGoto action_53
action_61 _ = happyFail

action_62 _ = happyReduce_23

action_63 (34) = happyShift action_107
action_63 (49) = happyShift action_74
action_63 (50) = happyShift action_75
action_63 (51) = happyShift action_76
action_63 (52) = happyShift action_77
action_63 (53) = happyShift action_78
action_63 _ = happyFail

action_64 (43) = happyShift action_101
action_64 (44) = happyShift action_102
action_64 (45) = happyShift action_103
action_64 (46) = happyShift action_104
action_64 (47) = happyShift action_105
action_64 (48) = happyShift action_106
action_64 (49) = happyShift action_74
action_64 (50) = happyShift action_75
action_64 (51) = happyShift action_76
action_64 (52) = happyShift action_77
action_64 (53) = happyShift action_78
action_64 _ = happyFail

action_65 (36) = happyShift action_100
action_65 (54) = happyShift action_89
action_65 (55) = happyShift action_90
action_65 _ = happyFail

action_66 _ = happyReduce_52

action_67 _ = happyReduce_51

action_68 (24) = happyShift action_66
action_68 (31) = happyShift action_67
action_68 (35) = happyShift action_68
action_68 (49) = happyShift action_56
action_68 (50) = happyShift action_57
action_68 (56) = happyShift action_69
action_68 (57) = happyShift action_58
action_68 (58) = happyShift action_59
action_68 (59) = happyShift action_43
action_68 (60) = happyShift action_44
action_68 (17) = happyGoto action_51
action_68 (19) = happyGoto action_98
action_68 (20) = happyGoto action_53
action_68 (21) = happyGoto action_99
action_68 _ = happyFail

action_69 (24) = happyShift action_66
action_69 (31) = happyShift action_67
action_69 (35) = happyShift action_68
action_69 (49) = happyShift action_56
action_69 (50) = happyShift action_57
action_69 (56) = happyShift action_69
action_69 (57) = happyShift action_58
action_69 (58) = happyShift action_59
action_69 (59) = happyShift action_43
action_69 (60) = happyShift action_44
action_69 (17) = happyGoto action_51
action_69 (19) = happyGoto action_64
action_69 (20) = happyGoto action_53
action_69 (21) = happyGoto action_97
action_69 _ = happyFail

action_70 _ = happyReduce_42

action_71 _ = happyReduce_41

action_72 (36) = happyShift action_96
action_72 (49) = happyShift action_74
action_72 (50) = happyShift action_75
action_72 (51) = happyShift action_76
action_72 (52) = happyShift action_77
action_72 (53) = happyShift action_78
action_72 _ = happyFail

action_73 _ = happyReduce_28

action_74 (35) = happyShift action_55
action_74 (49) = happyShift action_56
action_74 (50) = happyShift action_57
action_74 (57) = happyShift action_58
action_74 (58) = happyShift action_59
action_74 (59) = happyShift action_43
action_74 (60) = happyShift action_44
action_74 (17) = happyGoto action_51
action_74 (19) = happyGoto action_95
action_74 (20) = happyGoto action_53
action_74 _ = happyFail

action_75 (35) = happyShift action_55
action_75 (49) = happyShift action_56
action_75 (50) = happyShift action_57
action_75 (57) = happyShift action_58
action_75 (58) = happyShift action_59
action_75 (59) = happyShift action_43
action_75 (60) = happyShift action_44
action_75 (17) = happyGoto action_51
action_75 (19) = happyGoto action_94
action_75 (20) = happyGoto action_53
action_75 _ = happyFail

action_76 (35) = happyShift action_55
action_76 (49) = happyShift action_56
action_76 (50) = happyShift action_57
action_76 (57) = happyShift action_58
action_76 (58) = happyShift action_59
action_76 (59) = happyShift action_43
action_76 (60) = happyShift action_44
action_76 (17) = happyGoto action_51
action_76 (19) = happyGoto action_93
action_76 (20) = happyGoto action_53
action_76 _ = happyFail

action_77 (35) = happyShift action_55
action_77 (49) = happyShift action_56
action_77 (50) = happyShift action_57
action_77 (57) = happyShift action_58
action_77 (58) = happyShift action_59
action_77 (59) = happyShift action_43
action_77 (60) = happyShift action_44
action_77 (17) = happyGoto action_51
action_77 (19) = happyGoto action_92
action_77 (20) = happyGoto action_53
action_77 _ = happyFail

action_78 (35) = happyShift action_55
action_78 (49) = happyShift action_56
action_78 (50) = happyShift action_57
action_78 (57) = happyShift action_58
action_78 (58) = happyShift action_59
action_78 (59) = happyShift action_43
action_78 (60) = happyShift action_44
action_78 (17) = happyGoto action_51
action_78 (19) = happyGoto action_91
action_78 (20) = happyGoto action_53
action_78 _ = happyFail

action_79 (36) = happyShift action_88
action_79 (54) = happyShift action_89
action_79 (55) = happyShift action_90
action_79 _ = happyFail

action_80 (41) = happyShift action_87
action_80 (49) = happyShift action_74
action_80 (50) = happyShift action_75
action_80 (51) = happyShift action_76
action_80 (52) = happyShift action_77
action_80 (53) = happyShift action_78
action_80 _ = happyFail

action_81 (36) = happyShift action_85
action_81 (39) = happyShift action_86
action_81 _ = happyFail

action_82 (49) = happyShift action_74
action_82 (50) = happyShift action_75
action_82 (51) = happyShift action_76
action_82 (52) = happyShift action_77
action_82 (53) = happyShift action_78
action_82 _ = happyReduce_34

action_83 (41) = happyShift action_84
action_83 _ = happyFail

action_84 (34) = happyShift action_120
action_84 _ = happyFail

action_85 _ = happyReduce_32

action_86 (35) = happyShift action_55
action_86 (49) = happyShift action_56
action_86 (50) = happyShift action_57
action_86 (57) = happyShift action_58
action_86 (58) = happyShift action_59
action_86 (59) = happyShift action_43
action_86 (60) = happyShift action_44
action_86 (17) = happyGoto action_51
action_86 (19) = happyGoto action_119
action_86 (20) = happyGoto action_53
action_86 _ = happyFail

action_87 _ = happyReduce_49

action_88 (25) = happyShift action_38
action_88 (29) = happyShift action_39
action_88 (30) = happyShift action_40
action_88 (34) = happyShift action_41
action_88 (37) = happyShift action_30
action_88 (59) = happyShift action_43
action_88 (60) = happyShift action_44
action_88 (14) = happyGoto action_118
action_88 (15) = happyGoto action_35
action_88 (17) = happyGoto action_36
action_88 (20) = happyGoto action_37
action_88 _ = happyFail

action_89 (24) = happyShift action_66
action_89 (31) = happyShift action_67
action_89 (35) = happyShift action_68
action_89 (49) = happyShift action_56
action_89 (50) = happyShift action_57
action_89 (56) = happyShift action_69
action_89 (57) = happyShift action_58
action_89 (58) = happyShift action_59
action_89 (59) = happyShift action_43
action_89 (60) = happyShift action_44
action_89 (17) = happyGoto action_51
action_89 (19) = happyGoto action_64
action_89 (20) = happyGoto action_53
action_89 (21) = happyGoto action_117
action_89 _ = happyFail

action_90 (24) = happyShift action_66
action_90 (31) = happyShift action_67
action_90 (35) = happyShift action_68
action_90 (49) = happyShift action_56
action_90 (50) = happyShift action_57
action_90 (56) = happyShift action_69
action_90 (57) = happyShift action_58
action_90 (58) = happyShift action_59
action_90 (59) = happyShift action_43
action_90 (60) = happyShift action_44
action_90 (17) = happyGoto action_51
action_90 (19) = happyGoto action_64
action_90 (20) = happyGoto action_53
action_90 (21) = happyGoto action_116
action_90 _ = happyFail

action_91 _ = happyReduce_47

action_92 _ = happyReduce_46

action_93 _ = happyReduce_45

action_94 (51) = happyShift action_76
action_94 (52) = happyShift action_77
action_94 (53) = happyShift action_78
action_94 _ = happyReduce_44

action_95 (51) = happyShift action_76
action_95 (52) = happyShift action_77
action_95 (53) = happyShift action_78
action_95 _ = happyReduce_43

action_96 _ = happyReduce_39

action_97 _ = happyReduce_54

action_98 (36) = happyShift action_96
action_98 (43) = happyShift action_101
action_98 (44) = happyShift action_102
action_98 (45) = happyShift action_103
action_98 (46) = happyShift action_104
action_98 (47) = happyShift action_105
action_98 (48) = happyShift action_106
action_98 (49) = happyShift action_74
action_98 (50) = happyShift action_75
action_98 (51) = happyShift action_76
action_98 (52) = happyShift action_77
action_98 (53) = happyShift action_78
action_98 _ = happyFail

action_99 (36) = happyShift action_115
action_99 (54) = happyShift action_89
action_99 (55) = happyShift action_90
action_99 _ = happyFail

action_100 (25) = happyShift action_38
action_100 (29) = happyShift action_39
action_100 (30) = happyShift action_40
action_100 (34) = happyShift action_41
action_100 (37) = happyShift action_30
action_100 (59) = happyShift action_43
action_100 (60) = happyShift action_44
action_100 (14) = happyGoto action_114
action_100 (15) = happyGoto action_35
action_100 (17) = happyGoto action_36
action_100 (20) = happyGoto action_37
action_100 _ = happyFail

action_101 (35) = happyShift action_55
action_101 (49) = happyShift action_56
action_101 (50) = happyShift action_57
action_101 (57) = happyShift action_58
action_101 (58) = happyShift action_59
action_101 (59) = happyShift action_43
action_101 (60) = happyShift action_44
action_101 (17) = happyGoto action_51
action_101 (19) = happyGoto action_113
action_101 (20) = happyGoto action_53
action_101 _ = happyFail

action_102 (35) = happyShift action_55
action_102 (49) = happyShift action_56
action_102 (50) = happyShift action_57
action_102 (57) = happyShift action_58
action_102 (58) = happyShift action_59
action_102 (59) = happyShift action_43
action_102 (60) = happyShift action_44
action_102 (17) = happyGoto action_51
action_102 (19) = happyGoto action_112
action_102 (20) = happyGoto action_53
action_102 _ = happyFail

action_103 (35) = happyShift action_55
action_103 (49) = happyShift action_56
action_103 (50) = happyShift action_57
action_103 (57) = happyShift action_58
action_103 (58) = happyShift action_59
action_103 (59) = happyShift action_43
action_103 (60) = happyShift action_44
action_103 (17) = happyGoto action_51
action_103 (19) = happyGoto action_111
action_103 (20) = happyGoto action_53
action_103 _ = happyFail

action_104 (35) = happyShift action_55
action_104 (49) = happyShift action_56
action_104 (50) = happyShift action_57
action_104 (57) = happyShift action_58
action_104 (58) = happyShift action_59
action_104 (59) = happyShift action_43
action_104 (60) = happyShift action_44
action_104 (17) = happyGoto action_51
action_104 (19) = happyGoto action_110
action_104 (20) = happyGoto action_53
action_104 _ = happyFail

action_105 (35) = happyShift action_55
action_105 (49) = happyShift action_56
action_105 (50) = happyShift action_57
action_105 (57) = happyShift action_58
action_105 (58) = happyShift action_59
action_105 (59) = happyShift action_43
action_105 (60) = happyShift action_44
action_105 (17) = happyGoto action_51
action_105 (19) = happyGoto action_109
action_105 (20) = happyGoto action_53
action_105 _ = happyFail

action_106 (35) = happyShift action_55
action_106 (49) = happyShift action_56
action_106 (50) = happyShift action_57
action_106 (57) = happyShift action_58
action_106 (58) = happyShift action_59
action_106 (59) = happyShift action_43
action_106 (60) = happyShift action_44
action_106 (17) = happyGoto action_51
action_106 (19) = happyGoto action_108
action_106 (20) = happyGoto action_53
action_106 _ = happyFail

action_107 _ = happyReduce_21

action_108 (49) = happyShift action_74
action_108 (50) = happyShift action_75
action_108 (51) = happyShift action_76
action_108 (52) = happyShift action_77
action_108 (53) = happyShift action_78
action_108 _ = happyReduce_57

action_109 (49) = happyShift action_74
action_109 (50) = happyShift action_75
action_109 (51) = happyShift action_76
action_109 (52) = happyShift action_77
action_109 (53) = happyShift action_78
action_109 _ = happyReduce_58

action_110 (49) = happyShift action_74
action_110 (50) = happyShift action_75
action_110 (51) = happyShift action_76
action_110 (52) = happyShift action_77
action_110 (53) = happyShift action_78
action_110 _ = happyReduce_59

action_111 (49) = happyShift action_74
action_111 (50) = happyShift action_75
action_111 (51) = happyShift action_76
action_111 (52) = happyShift action_77
action_111 (53) = happyShift action_78
action_111 _ = happyReduce_60

action_112 (49) = happyShift action_74
action_112 (50) = happyShift action_75
action_112 (51) = happyShift action_76
action_112 (52) = happyShift action_77
action_112 (53) = happyShift action_78
action_112 _ = happyReduce_56

action_113 (49) = happyShift action_74
action_113 (50) = happyShift action_75
action_113 (51) = happyShift action_76
action_113 (52) = happyShift action_77
action_113 (53) = happyShift action_78
action_113 _ = happyReduce_55

action_114 (23) = happyShift action_121
action_114 _ = happyReduce_24

action_115 _ = happyReduce_53

action_116 (54) = happyShift action_89
action_116 _ = happyReduce_62

action_117 _ = happyReduce_61

action_118 _ = happyReduce_26

action_119 (49) = happyShift action_74
action_119 (50) = happyShift action_75
action_119 (51) = happyShift action_76
action_119 (52) = happyShift action_77
action_119 (53) = happyShift action_78
action_119 _ = happyReduce_35

action_120 _ = happyReduce_19

action_121 (25) = happyShift action_38
action_121 (29) = happyShift action_39
action_121 (30) = happyShift action_40
action_121 (34) = happyShift action_41
action_121 (37) = happyShift action_30
action_121 (59) = happyShift action_43
action_121 (60) = happyShift action_44
action_121 (14) = happyGoto action_122
action_121 (15) = happyGoto action_35
action_121 (17) = happyGoto action_36
action_121 (20) = happyGoto action_37
action_121 _ = happyFail

action_122 _ = happyReduce_25

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

happyReduce_6 = happySpecReduce_1  7 happyReduction_6
happyReduction_6 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn7
		 ([happy_var_1]
	)
happyReduction_6 _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  7 happyReduction_7
happyReduction_7 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_3 : happy_var_1
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happyReduce 4 8 happyReduction_8
happyReduction_8 ((HappyAbsSyn10  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName           happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (FPar_Def_Ref happy_var_1 happy_var_4
	) `HappyStk` happyRest

happyReduce_9 = happySpecReduce_3  8 happyReduction_9
happyReduction_9 (HappyAbsSyn10  happy_var_3)
	_
	(HappyTerminal (TName           happy_var_1))
	 =  HappyAbsSyn8
		 (FPar_Def_NR happy_var_1 happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  9 happyReduction_10
happyReduction_10 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn9
		 (D_Type happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  9 happyReduction_11
happyReduction_11 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn9
		 (D_Type happy_var_1
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_1  10 happyReduction_12
happyReduction_12 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn10
		 (S_Type      happy_var_1
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  10 happyReduction_13
happyReduction_13 _
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn10
		 (Table_Type  happy_var_1
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_1  11 happyReduction_14
happyReduction_14 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn11
		 (R_Type_DT   happy_var_1
	)
happyReduction_14 _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_1  11 happyReduction_15
happyReduction_15 _
	 =  HappyAbsSyn11
		 (R_Type_Proc
	)

happyReduce_16 = happySpecReduce_1  12 happyReduction_16
happyReduction_16 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn12
		 (Loc_Def_Fun happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  12 happyReduction_17
happyReduction_17 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 (Loc_Def_Var happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happyReduce 4 13 happyReduction_18
happyReduction_18 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName           happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 (VDef    happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_19 = happyReduce 7 13 happyReduction_19
happyReduction_19 (_ `HappyStk`
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

happyReduce_20 = happySpecReduce_1  14 happyReduction_20
happyReduction_20 _
	 =  HappyAbsSyn14
		 (Stmt_Semi
	)

happyReduce_21 = happyReduce 4 14 happyReduction_21
happyReduction_21 (_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn20  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Stmt_Eq  happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_22 = happySpecReduce_1  14 happyReduction_22
happyReduction_22 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (Stmt_Cmp  happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_2  14 happyReduction_23
happyReduction_23 _
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn14
		 (Stmt_FCall happy_var_1
	)
happyReduction_23 _ _  = notHappyAtAll 

happyReduce_24 = happyReduce 5 14 happyReduction_24
happyReduction_24 ((HappyAbsSyn14  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Stmt_If  happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_25 = happyReduce 7 14 happyReduction_25
happyReduction_25 ((HappyAbsSyn14  happy_var_7) `HappyStk`
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

happyReduce_26 = happyReduce 5 14 happyReduction_26
happyReduction_26 ((HappyAbsSyn14  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn21  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Stmt_Wh  happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_27 = happySpecReduce_2  14 happyReduction_27
happyReduction_27 _
	_
	 =  HappyAbsSyn14
		 (Stmt_Ret
	)

happyReduce_28 = happySpecReduce_3  14 happyReduction_28
happyReduction_28 _
	(HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn14
		 (Stmt_Ret_Expr happy_var_2
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_3  15 happyReduction_29
happyReduction_29 _
	(HappyAbsSyn16  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (C_Stmt happy_var_2
	)
happyReduction_29 _ _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_0  16 happyReduction_30
happyReduction_30  =  HappyAbsSyn16
		 ([]
	)

happyReduce_31 = happySpecReduce_2  16 happyReduction_31
happyReduction_31 (HappyAbsSyn14  happy_var_2)
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_2 : happy_var_1
	)
happyReduction_31 _ _  = notHappyAtAll 

happyReduce_32 = happyReduce 4 17 happyReduction_32
happyReduction_32 (_ `HappyStk`
	(HappyAbsSyn18  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName           happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 (Func_Call happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_33 = happySpecReduce_0  18 happyReduction_33
happyReduction_33  =  HappyAbsSyn18
		 ([]
	)

happyReduce_34 = happySpecReduce_1  18 happyReduction_34
happyReduction_34 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn18
		 ([happy_var_1]
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  18 happyReduction_35
happyReduction_35 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn18
		 (happy_var_3 : happy_var_1
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  19 happyReduction_36
happyReduction_36 (HappyTerminal (TIntLiteral     happy_var_1))
	 =  HappyAbsSyn19
		 (Expr_Int   happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_1  19 happyReduction_37
happyReduction_37 (HappyTerminal (TChar           happy_var_1))
	 =  HappyAbsSyn19
		 (Expr_Char  happy_var_1
	)
happyReduction_37 _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  19 happyReduction_38
happyReduction_38 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Lval  happy_var_1
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_3  19 happyReduction_39
happyReduction_39 _
	(HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn19
		 (Expr_Brack happy_var_2
	)
happyReduction_39 _ _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_1  19 happyReduction_40
happyReduction_40 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Fcall happy_var_1
	)
happyReduction_40 _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_2  19 happyReduction_41
happyReduction_41 (HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn19
		 (Expr_Pos   happy_var_2
	)
happyReduction_41 _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_2  19 happyReduction_42
happyReduction_42 (HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn19
		 (Expr_Neg   happy_var_2
	)
happyReduction_42 _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_3  19 happyReduction_43
happyReduction_43 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Add happy_var_1 happy_var_3
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  19 happyReduction_44
happyReduction_44 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Sub happy_var_1 happy_var_3
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  19 happyReduction_45
happyReduction_45 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Tms happy_var_1 happy_var_3
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_3  19 happyReduction_46
happyReduction_46 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Div happy_var_1 happy_var_3
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  19 happyReduction_47
happyReduction_47 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Expr_Mod happy_var_1 happy_var_3
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  20 happyReduction_48
happyReduction_48 (HappyTerminal (TName           happy_var_1))
	 =  HappyAbsSyn20
		 (LV_Var  happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happyReduce 4 20 happyReduction_49
happyReduction_49 (_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TName           happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn20
		 (LV_Tbl  happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_50 = happySpecReduce_1  20 happyReduction_50
happyReduction_50 (HappyTerminal (TStringLiteral  happy_var_1))
	 =  HappyAbsSyn20
		 (LV_Lit  happy_var_1
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_1  21 happyReduction_51
happyReduction_51 _
	 =  HappyAbsSyn21
		 (Cond_True
	)

happyReduce_52 = happySpecReduce_1  21 happyReduction_52
happyReduction_52 _
	 =  HappyAbsSyn21
		 (Cond_False
	)

happyReduce_53 = happySpecReduce_3  21 happyReduction_53
happyReduction_53 _
	(HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (Cond_Br   happy_var_2
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_2  21 happyReduction_54
happyReduction_54 (HappyAbsSyn21  happy_var_2)
	_
	 =  HappyAbsSyn21
		 (Cond_Bang happy_var_2
	)
happyReduction_54 _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_3  21 happyReduction_55
happyReduction_55 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_Eq  happy_var_1 happy_var_3
	)
happyReduction_55 _ _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  21 happyReduction_56
happyReduction_56 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_Neq happy_var_1 happy_var_3
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  21 happyReduction_57
happyReduction_57 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_L   happy_var_1 happy_var_3
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_3  21 happyReduction_58
happyReduction_58 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_G   happy_var_1 happy_var_3
	)
happyReduction_58 _ _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_3  21 happyReduction_59
happyReduction_59 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_LE  happy_var_1 happy_var_3
	)
happyReduction_59 _ _ _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  21 happyReduction_60
happyReduction_60 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_GE  happy_var_1 happy_var_3
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_3  21 happyReduction_61
happyReduction_61 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_And happy_var_1 happy_var_3
	)
happyReduction_61 _ _ _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_3  21 happyReduction_62
happyReduction_62 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (Cond_Or  happy_var_1 happy_var_3
	)
happyReduction_62 _ _ _  = notHappyAtAll 

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
	TComOp ">=" -> cont 45;
	TComOp "<=" -> cont 46;
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
	_ -> happyError' tk
	})

happyError_ 61 tk = happyError' tk
happyError_ _ tk = happyError' tk

happyThen :: () => P a -> (a -> P b) -> P b
happyThen = (>>=)
happyReturn :: () => a -> P a
happyReturn = (return)
happyThen1 = happyThen
happyReturn1 :: () => a -> P a
happyReturn1 = happyReturn
happyError' :: () => (Token) -> P a
happyError' tk = parseError tk

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
{-# LINE 8 "<command-line>" #-}
# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4














































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "/usr/lib64/ghc-8.0.2/include/ghcversion.h" #-}

















{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "/tmp/ghca582_0/ghc_2.h" #-}












































































































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 13 "templates/GenericTemplate.hs" #-}

{-# LINE 46 "templates/GenericTemplate.hs" #-}








{-# LINE 67 "templates/GenericTemplate.hs" #-}

{-# LINE 77 "templates/GenericTemplate.hs" #-}

{-# LINE 86 "templates/GenericTemplate.hs" #-}

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

{-# LINE 155 "templates/GenericTemplate.hs" #-}

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
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 256 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ i tk

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
happyFail  i tk (HappyState (action)) sts stk =
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

{-# LINE 322 "templates/GenericTemplate.hs" #-}
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
