gamma :: Double -> Double
gamma z
  | z < 0.5   = pi / (sin (pi * z) * gamma (1 - z))
  | otherwise = sqrt (2 * pi) * (t ** (z' + 0.5)) * exp (-t) * x
  where
  
  g :: Double
  g = 5
  
  p :: [Double]
  p = [  1.000000000190015, 
        76.18009172947146,
       -86.50532032941677,
        24.01409824083091,
        -1.231739572450155,
         0.1208650973866179e-2,
        -0.5395239384953e-5
      ]
      
  z' = z - 1
  x = head p + sum [pi_ / (z' + fromIntegral i) | (i, pi_) <- zip [1..] (tail p)]
  
  t = z' + g + 0.5


factorialNoInt :: Double -> Double
factorialNoInt n = gamma (n + 1)
