module Scale where

import Scale.Linear
import Scale.OrdinalPoints
import Scale.OrdinalBands
import Private.Models exposing (PointValue, Tick)
import Scale.Scale exposing (Scale)
import Sets exposing (Domain, Range)

linear : (Float, Float) -> Range -> Int -> Scale (Float, Float) Float
linear domain range numTicks =
  { domain = domain
  , range = range
  , interpolate = Scale.Linear.interpolate
  , uninterpolate = Scale.Linear.uninterpolate
  , createTicks = Scale.Linear.createTicks numTicks
  }

ordinalPoints : List String -> Range -> Int -> Scale (List String) String
ordinalPoints domain range padding =
  let
    mapping = Scale.OrdinalPoints.createMapping padding
  in
    { domain = domain
    , range = range
    , interpolate = Scale.OrdinalPoints.interpolate mapping
    , uninterpolate = Scale.OrdinalPoints.uninterpolate mapping
    , createTicks = Scale.OrdinalPoints.createTicks mapping
    }

ordinalBands : List String -> Range -> Float -> Float -> Scale (List String) String
ordinalBands domain range padding outerPadding =
  let
    mapping = Scale.OrdinalBands.createMapping padding outerPadding
  in
    { domain = domain
    , range = range
    , interpolate = Scale.OrdinalBands.interpolate mapping
    , uninterpolate = Scale.OrdinalBands.uninterpolate mapping
    , createTicks = Scale.OrdinalBands.createTicks mapping
    }

-- TODO private move somewhere else
interpolate : Scale a b -> b -> PointValue b
interpolate scale x =
  scale.interpolate scale.domain scale.range x

uninterpolate : Scale a b -> Float -> b
uninterpolate scale x =
  scale.uninterpolate scale.domain scale.range x

createTicks : Scale a b -> List Tick
createTicks scale =
  scale.createTicks scale.domain scale.range

-- TODO does not work for reversed ranges
includeMargins : Float -> Float -> Scale a b -> Scale a b
includeMargins lowM highM scale =
  let
    rLow = (fst scale.range) + lowM
    rHigh = (snd scale.range) - highM
  in
    { scale | range = (rLow, rHigh) }
