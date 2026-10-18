bmiMessage2 :: Double -> String
bmiMessage2 bmi
  | bmi < underweightThreshold = "痩せ型です"
  | bmi < normalThreshold      = "標準体重です"
  | otherwise                  = "肥満傾向です"
  where
    underweightThreshold = 18.5
    normalThreshold      = 25.0