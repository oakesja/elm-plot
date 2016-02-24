module Scale where

import Scale.Linear
import Scale.OrdinalPoints
import Private.Models exposing (PointValue, Tick, Scale)

transform : Scale a -> a -> Float
transform scale x =
  scale.transform scale.range x

createTicks : Scale a -> List Tick
createTicks scale =
  scale.createTicks scale.range

includeMargins : Float -> Float -> Scale a -> Scale a
includeMargins lowM highM scale =
  let
    rLow = (fst scale.range) + lowM
    rHigh = (snd scale.range) - highM
  in
    { scale | range = (rLow, rHigh) }

linear : (Float, Float) -> (Float, Float) -> Int -> Scale Float
linear domain range numTicks =
  { range = range
  , transform = Scale.Linear.transform domain
  , createTicks = Scale.Linear.createTicks domain numTicks
  }

ordinalPoints : List String -> (Float, Float) -> Int -> Scale String
ordinalPoints domain range padding =
  let
    mapping = Scale.OrdinalPoints.createMapping domain padding
  in
    { range = range
    , transform = Scale.OrdinalPoints.transform mapping
    , createTicks = Scale.OrdinalPoints.createTicks mapping
    }
