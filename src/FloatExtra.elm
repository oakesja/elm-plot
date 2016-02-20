module FloatExtra where

ln : Float -> Float
ln x =
  logBase 10 x / logBase 10 e

roundTo : Float -> Int -> Float
roundTo x numPlaces =
  let
    offset = 10 ^ numPlaces
  in
    toFloat (round (x * offset)) / offset
