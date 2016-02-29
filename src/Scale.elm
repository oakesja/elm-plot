module Scale where

import Scale.Linear
import Scale.OrdinalPoints
import Scale.OrdinalBands
import Private.Models exposing (PointValue, Tick, BoundingBox)
import Scale.Scale exposing (Scale)
import Scale.Type exposing (ScaleType)
import Sets exposing (Domain, Range, calculateExtent)

linear : (Float, Float) -> Range -> Int -> Scale (Float, Float) Float
linear domain range numTicks =
  { domain = domain
  , range = range
  , interpolate = Scale.Linear.interpolate
  , uninterpolate = Scale.Linear.uninterpolate
  , createTicks = Scale.Linear.createTicks numTicks
  , inDomain = Scale.Linear.inDomain
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
    , inDomain = Scale.OrdinalPoints.inDomain
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
    , inDomain = Scale.OrdinalBands.inDomain
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

rescale : BoundingBox -> ScaleType -> Scale a b -> Scale a b
rescale bBox sType scale =
    { scale | range = calculateExtent bBox sType scale.range }

inDomain : Scale a b -> b -> Bool
inDomain scale point =
  scale.inDomain scale.domain point
