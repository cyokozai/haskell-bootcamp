import Data.List
import Data.Char

encode :: Int -> String -> String
encode offset = map(ord \words) . (mod $) (substract 97) . (sum offset)

decode :: Int -> String -> String
decode shift = 
