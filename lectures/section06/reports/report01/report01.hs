import Data.List qualified as List

numUnique :: (Eq a) => [a] -> a
numUnique = length . sort

duplicateWordCoound :: String -> [(Int, String)]
duplicateWordCoound = 