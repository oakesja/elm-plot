module Scale.Linear (scale, ticks) where

import FloatExtra exposing (ln, roundTo)

scale : (Float, Float) -> (Float, Float) -> Float -> Float
scale domain range x =
  if fst domain == snd domain then
    fst range
  else
    (((x - fst domain) * (snd range - fst range)) / (snd domain - fst domain)) + fst range

-- https://github.com/mbostock/d3/blob/78ce531f79e82275fe50f975e784ee2be097226b/src/scale/linear.js#L96
ticks : (Float, Float) -> Int -> List Float
ticks domain numTicks =
  let
    extent = extentOf domain
    step = stepSize extent (toFloat numTicks)
    min = (toFloat (ceiling (fst extent / step))) * step
    max = (toFloat (floor (snd extent / step))) * step + step * 0.5
  in
    makeTicks min max step
      |> List.map (\t -> roundTo t (significantDigits step))

stepSize : (Float, Float) -> Float -> Float
stepSize extent numTicks =
  let
    span = snd extent - fst extent
    step = toFloat (10 ^ (floor((ln (span/ numTicks) /ln 10))))
    err = numTicks / span * step
  in
    if err <= 0.15 then
      step * 10
    else if err < 0.35 then
      step * 5
    else if err < 0.75 then
      step * 2
    else
      step

extentOf : (Float, Float) -> (Float, Float)
extentOf domain =
  if fst domain < snd domain then
    domain
  else
    (snd domain, fst domain)

makeTicks : Float -> Float -> Float -> List Float
makeTicks min max step =
  if min >= max then
    []
  else
    [min] ++ makeTicks (min + step) max step

significantDigits : Float -> Int
significantDigits step =
  negate (floor ((ln step) / (ln 10) + 0.01))
