module Private.Extras.Float where

ln : Float -> Float
ln x =
  logBase 10 x / logBase 10 e

roundTo : Float -> Int -> Float
roundTo x numPlaces =
  if numPlaces > 0 then
    toFloat (round (x * 10 ^ numPlaces)) / 10 ^ numPlaces
  else
    x
