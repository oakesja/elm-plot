module Scale where

import Scale.Linear
import Scale.OrdinalPoints
import Scale.OrdinalBands
import Private.Models exposing (PointValue, Tick)
import Scale.Scale exposing (Scale)
import Sets exposing (Domain, Range)

linear : Domain -> Range -> Int -> Scale Float
linear domain range numTicks =
  { range = range
  , interpolate = Scale.Linear.interpolate domain
  , createTicks = Scale.Linear.createTicks domain numTicks
  }

ordinalPoints : List String -> Range -> Int -> Scale String
ordinalPoints domain range padding =
  let
    mapping = Scale.OrdinalPoints.createMapping domain padding
  in
    { range = range
    , interpolate = Scale.OrdinalPoints.interpolate mapping
    , createTicks = Scale.OrdinalPoints.createTicks mapping
    }

ordinalBands : List String -> Range -> Float -> Float -> Scale String
ordinalBands domain range padding outerPadding =
  let
    mapping = Scale.OrdinalBands.createMapping domain padding outerPadding
  in
    { range = range
    , interpolate = Scale.OrdinalBands.interpolate mapping
    , createTicks = Scale.OrdinalBands.createTicks mapping
    }

-- TODO private move somewhere else
interpolate : Scale a -> a -> PointValue a
interpolate scale x =
  scale.interpolate scale.range x

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
