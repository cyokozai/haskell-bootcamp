import Data.List

infixHeadIndexList :: Eq a => [a] -> [a] -> [Int]
infixHeadIndexList word words = findIndices(`elem` word) words

isIn :: (Eq a) => [a] -> [a] -> Bool
isIn word = any (isPrefixOf word) . tails