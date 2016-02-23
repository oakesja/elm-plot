module Scale where

import Scale.Linear
import Scale.OrdinalPoints
import Axis.Tick exposing (Tick)

type alias Scale a =
  { range : (Float, Float)
  , transform : ((Float, Float) -> a -> Float)
  , createTicks : ((Float, Float) -> Int -> List Tick)
  }

transform : Scale a -> a -> Float
transform scale x =
  scale.transform scale.range x

createTicks : Scale a -> Int -> List Tick
createTicks scale numTicks =
  scale.createTicks scale.range numTicks

includeMargins : Float -> Float -> Scale a -> Scale a
includeMargins lowM highM scale =
  let
    rLow = (fst scale.range) + lowM
    rHigh = (snd scale.range) - highM
  in
    { scale | range = (rLow, rHigh) }

linear : (Float, Float) -> (Float, Float) -> Scale Float
linear domain range =
  { range = range
  , transform = Scale.Linear.transform domain
  , createTicks = Scale.Linear.createTicks domain
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
