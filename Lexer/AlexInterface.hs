module AlexInterface where

import Control.Monad.State
import Control.Monad
import Data.Word
import Codec.Binary.UTF8.String (encode)

-- The functions that must be provided to Alex's basic interface
-- The input: last character, unused bytes, remaining string
data AlexInput
  = AlexInput {
    aiprev    :: Char,              -- Last char
    aibytes   :: [Word8],           -- Unused bytes
    airest    :: String,            -- Remaining string
    ailineno  :: Int}               -- Line number
  deriving ( Eq,Show )

alexGetByte :: AlexInput -> Maybe (Word8,AlexInput)          -- Returns the next byte, AlexInput
alexGetByte ai
  = case (aibytes ai) of
    (b:bs) -> Just (b,ai{aibytes=bs})
    [] -> case (airest ai) of
      [] -> Nothing
      (c:cs) -> let n = (ailineno ai)                      -- Amends the next line, if it must
                    n' = if c=='\n' then n+1 else n
                    (b:bs) = encode [c] in
                Just (b,AlexInput {aiprev=c, -- first b
                                   aibytes=bs, --bs
                                   airest=cs,
                                   ailineno=n'})


alexInputPrevChar :: AlexInput -> Char
alexInputPrevChar (AlexInput {aiprev=c}) = c

data ParseState =
     ParseState {input::AlexInput,
                 lexSC::Int,       --Lexer start code
                 commentDepth::Int,--Comment depth
                 stringBuf::String --Temporary storage for strings
                }
     deriving (Eq,Show)

initialState::String -> ParseState                  -- Sets the parsers initial state, according to the given string
initialState s = ParseState {   input = AlexInput {aiprev='\n',
                                                   aibytes=[],
                                                   airest=s,
                                                   ailineno = 1},
                                lexSC = 0,
                                commentDepth = 0,
                                stringBuf = ""
                                }

-- Our Parser monad
type P a = State ParseState a

getLineNo::P Int                  -- Looks at our parser state monad
getLineNo = do                    -- takes the alexinput state from inside the monad
  s <- get                        -- and returns the line  number that was wrapped in that data type
  return . ailineno . input $ s

evalP::P a -> String -> a               -- Just pack the intial string inside a parsestate,
evalP m s = evalState m (initialState s)   -- run the corresponding monad, and return the result
