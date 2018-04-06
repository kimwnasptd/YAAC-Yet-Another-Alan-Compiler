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

data HappyAbsSyn t4 t5
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5

happyExpList :: Happy_Data_Array.Array Int Int
happyExpList = Happy_Data_Array.listArray (0,76) ([0,49154,480,0,0,1,0,0,0,61440,1,0,0,0,8,1923,8192,3072,30,128,30768,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,31,8192,3072,30,128,30768,0,49154,480,2048,33536,7,32,7692,0,0,0,0,0,0,0,0,0,28672,0,0,448,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_basicParser","Expr","L_Value","byte","else","false","if","int","proc","reference","return","while","true","\".\"","\";\"","\"(\"","\")\"","\"{\"","\"}\"","\",\"","\"[\"","\"]\"","\"==\"","\"!=\"","\">=\"","\"<=\"","\">\"","\"<\"","\"+\"","\"-\"","\"*\"","\"/\"","\"%\"","\"&\"","\"|\"","char","int_literal","var","string_literal","%eof"]
        bit_start = st * 42
        bit_end = (st + 1) * 42
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..41]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

action_0 (18) = happyShift action_5
action_0 (31) = happyShift action_6
action_0 (32) = happyShift action_7
action_0 (38) = happyShift action_8
action_0 (39) = happyShift action_2
action_0 (40) = happyShift action_9
action_0 (41) = happyShift action_10
action_0 (4) = happyGoto action_3
action_0 (5) = happyGoto action_4
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (39) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (31) = happyShift action_14
action_3 (32) = happyShift action_15
action_3 (33) = happyShift action_16
action_3 (34) = happyShift action_17
action_3 (35) = happyShift action_18
action_3 (42) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 _ = happyReduce_3

action_5 (18) = happyShift action_5
action_5 (31) = happyShift action_6
action_5 (32) = happyShift action_7
action_5 (38) = happyShift action_8
action_5 (39) = happyShift action_2
action_5 (40) = happyShift action_9
action_5 (41) = happyShift action_10
action_5 (4) = happyGoto action_13
action_5 (5) = happyGoto action_4
action_5 _ = happyFail (happyExpListPerState 5)

action_6 (18) = happyShift action_5
action_6 (31) = happyShift action_6
action_6 (32) = happyShift action_7
action_6 (38) = happyShift action_8
action_6 (39) = happyShift action_2
action_6 (40) = happyShift action_9
action_6 (41) = happyShift action_10
action_6 (4) = happyGoto action_12
action_6 (5) = happyGoto action_4
action_6 _ = happyFail (happyExpListPerState 6)

action_7 (18) = happyShift action_5
action_7 (31) = happyShift action_6
action_7 (32) = happyShift action_7
action_7 (38) = happyShift action_8
action_7 (39) = happyShift action_2
action_7 (40) = happyShift action_9
action_7 (41) = happyShift action_10
action_7 (4) = happyGoto action_11
action_7 (5) = happyGoto action_4
action_7 _ = happyFail (happyExpListPerState 7)

action_8 _ = happyReduce_2

action_9 _ = happyReduce_12

action_10 _ = happyReduce_13

action_11 _ = happyReduce_6

action_12 _ = happyReduce_5

action_13 (19) = happyShift action_24
action_13 (31) = happyShift action_14
action_13 (32) = happyShift action_15
action_13 (33) = happyShift action_16
action_13 (34) = happyShift action_17
action_13 (35) = happyShift action_18
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (18) = happyShift action_5
action_14 (31) = happyShift action_6
action_14 (32) = happyShift action_7
action_14 (38) = happyShift action_8
action_14 (39) = happyShift action_2
action_14 (40) = happyShift action_9
action_14 (41) = happyShift action_10
action_14 (4) = happyGoto action_23
action_14 (5) = happyGoto action_4
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (18) = happyShift action_5
action_15 (31) = happyShift action_6
action_15 (32) = happyShift action_7
action_15 (38) = happyShift action_8
action_15 (39) = happyShift action_2
action_15 (40) = happyShift action_9
action_15 (41) = happyShift action_10
action_15 (4) = happyGoto action_22
action_15 (5) = happyGoto action_4
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (18) = happyShift action_5
action_16 (31) = happyShift action_6
action_16 (32) = happyShift action_7
action_16 (38) = happyShift action_8
action_16 (39) = happyShift action_2
action_16 (40) = happyShift action_9
action_16 (41) = happyShift action_10
action_16 (4) = happyGoto action_21
action_16 (5) = happyGoto action_4
action_16 _ = happyFail (happyExpListPerState 16)

action_17 (18) = happyShift action_5
action_17 (31) = happyShift action_6
action_17 (32) = happyShift action_7
action_17 (38) = happyShift action_8
action_17 (39) = happyShift action_2
action_17 (40) = happyShift action_9
action_17 (41) = happyShift action_10
action_17 (4) = happyGoto action_20
action_17 (5) = happyGoto action_4
action_17 _ = happyFail (happyExpListPerState 17)

action_18 (18) = happyShift action_5
action_18 (31) = happyShift action_6
action_18 (32) = happyShift action_7
action_18 (38) = happyShift action_8
action_18 (39) = happyShift action_2
action_18 (40) = happyShift action_9
action_18 (41) = happyShift action_10
action_18 (4) = happyGoto action_19
action_18 (5) = happyGoto action_4
action_18 _ = happyFail (happyExpListPerState 18)

action_19 _ = happyReduce_11

action_20 _ = happyReduce_10

action_21 _ = happyReduce_9

action_22 (33) = happyShift action_16
action_22 (34) = happyShift action_17
action_22 (35) = happyShift action_18
action_22 _ = happyReduce_8

action_23 (33) = happyShift action_16
action_23 (34) = happyShift action_17
action_23 (35) = happyShift action_18
action_23 _ = happyReduce_7

action_24 _ = happyReduce_4

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyTerminal (TIntLiteral     happy_var_1))
	 =  HappyAbsSyn4
		 (Expr_Int   happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  4 happyReduction_2
happyReduction_2 (HappyTerminal (TChar           happy_var_1))
	 =  HappyAbsSyn4
		 (Expr_Char  happy_var_1
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_1  4 happyReduction_3
happyReduction_3 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (Expr_Lval  happy_var_1
	)
happyReduction_3 _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_3  4 happyReduction_4
happyReduction_4 _
	(HappyAbsSyn4  happy_var_2)
	_
	 =  HappyAbsSyn4
		 (Expr_Brack happy_var_2
	)
happyReduction_4 _ _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  4 happyReduction_5
happyReduction_5 (HappyAbsSyn4  happy_var_2)
	_
	 =  HappyAbsSyn4
		 (Expr_Pos   happy_var_2
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_2  4 happyReduction_6
happyReduction_6 (HappyAbsSyn4  happy_var_2)
	_
	 =  HappyAbsSyn4
		 (Expr_Neg   happy_var_2
	)
happyReduction_6 _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  4 happyReduction_7
happyReduction_7 (HappyAbsSyn4  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (Expr_Add happy_var_1 happy_var_3
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_3  4 happyReduction_8
happyReduction_8 (HappyAbsSyn4  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (Expr_Sub happy_var_1 happy_var_3
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  4 happyReduction_9
happyReduction_9 (HappyAbsSyn4  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (Expr_Tms happy_var_1 happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_3  4 happyReduction_10
happyReduction_10 (HappyAbsSyn4  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (Expr_Div happy_var_1 happy_var_3
	)
happyReduction_10 _ _ _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_3  4 happyReduction_11
happyReduction_11 (HappyAbsSyn4  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (Expr_Mod happy_var_1 happy_var_3
	)
happyReduction_11 _ _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_1  5 happyReduction_12
happyReduction_12 (HappyTerminal (TName           happy_var_1))
	 =  HappyAbsSyn5
		 (LV_Var  happy_var_1
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_1  5 happyReduction_13
happyReduction_13 (HappyTerminal (TStringLiteral  happy_var_1))
	 =  HappyAbsSyn5
		 (LV_Lit  happy_var_1
	)
happyReduction_13 _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 42 42 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TByte -> cont 6;
	TElse -> cont 7;
	TFalse -> cont 8;
	TIf -> cont 9;
	TInt -> cont 10;
	TProc -> cont 11;
	TReference -> cont 12;
	TReturn -> cont 13;
	TWhile -> cont 14;
	TTrue -> cont 15;
	TPeriod -> cont 16;
	TSemiColon -> cont 17;
	TLeftParen -> cont 18;
	TRightParen -> cont 19;
	TLeftBrace -> cont 20;
	TRightBrace -> cont 21;
	TComma -> cont 22;
	TLeftBrack -> cont 23;
	TRightBrack -> cont 24;
	TComOp "==" -> cont 25;
	TComOp "!=" -> cont 26;
	TComOp "(" -> cont 27;
	TComOp ")" -> cont 28;
	TComOp ">" -> cont 29;
	TComOp "<" -> cont 30;
	TOp    "+" -> cont 31;
	TOp    "-" -> cont 32;
	TOp    "*" -> cont 33;
	TOp    "/" -> cont 34;
	TOp    "%" -> cont 35;
	TOp    "&" -> cont 36;
	TOp    "|" -> cont 37;
	TChar           happy_dollar_dollar -> cont 38;
	TIntLiteral     happy_dollar_dollar -> cont 39;
	TName           happy_dollar_dollar -> cont 40;
	TStringLiteral  happy_dollar_dollar -> cont 41;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 42 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = HappyIdentity
    (<*>) = ap
instance Monad HappyIdentity where
    return = pure
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (return)
happyThen1 m k tks = (>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (return) a
happyError' :: () => ([(Token)], [String]) -> HappyIdentity a
happyError' = HappyIdentity . (\(tokens, _) -> parseError tokens)
basicParser tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError:: [Token]  -> a
parseError _ = error "oopsie daisy "
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
