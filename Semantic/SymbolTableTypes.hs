-- The Types for the Symbol Table Entries
import qualified Data.Map as Map
     
-- Declare type Synonims for better understanding
type VarName = String
type VarType = String
type MethodName = String
type SymbolName = String

-- The Symbol Table
type SymbolTable = Map.Map SymbolName TableSymbol
-- But shouldn't it be something  more like a stack?

data TableSymbol = 
    MethodSymbol {
      name       :: MethodName
    , returnType :: String
    , args       :: Map.Map VarName VarType            -- The arguments of the function
    , methods    :: Map.Map MethodName MethodSymbol    -- This will most probably change
    } 
  
  | ScopeSymnol {
      vars       :: Map.Map VarName VarType
    }

    deriving (Show, Eq)

-- instance Show MethodSymbol where 
--     show (MethodSymbol method_name rType method_args its_methods) = (show name)
-- Didn't work :'(

-- Ex: 
-- let first_symbol = MethodSymbol "main" "int" Map.empty Map.empty