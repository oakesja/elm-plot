module Scale where

import Scale.Linear
import Scale.OrdinalPoints
import Scale.OrdinalBands
import Private.Models exposing (PointValue)
import Tick exposing (Tick)
import BoundingBox exposing (BoundingBox)
import Scale.Scale exposing (Scale)
import Scale.Type exposing (ScaleType)
import Extras.Set as Set exposing (Set, calculateExtent)
import Zoom

-- TODO consider a more functional approach to this

linear : (Float, Float) -> (Float, Float) -> Int -> Scale Set Float
linear domain range numTicks =
  { domain = Set.createFromTuple domain
  , range = Set.createFromTuple range
  , interpolate = Scale.Linear.interpolate
  , uninterpolate = Scale.Linear.uninterpolate
  , createTicks = Scale.Linear.createTicks numTicks
  , inDomain = Scale.Linear.inDomain
  }

ordinalPoints : List String -> (Float, Float) -> Int -> Scale (List String) String
ordinalPoints domain range padding =
  let
    mapping = Scale.OrdinalPoints.createMapping padding
  in
    { domain = domain
    , range = Set.createFromTuple range
    , interpolate = Scale.OrdinalPoints.interpolate mapping
    , uninterpolate = Scale.OrdinalPoints.uninterpolate mapping
    , createTicks = Scale.OrdinalPoints.createTicks mapping
    , inDomain = Scale.OrdinalPoints.inDomain
    }

ordinalBands : List String -> (Float, Float) -> Float -> Float -> Scale (List String) String
ordinalBands domain range padding outerPadding =
  let
    mapping = Scale.OrdinalBands.createMapping padding outerPadding
  in
    { domain = domain
    , range = Set.createFromTuple range
    , interpolate = Scale.OrdinalBands.interpolate mapping
    , uninterpolate = Scale.OrdinalBands.uninterpolate mapping
    , createTicks = Scale.OrdinalBands.createTicks mapping
    , inDomain = Scale.OrdinalBands.inDomain
    }

zoom : Scale Set Float -> Float -> Zoom.Direction ->  Scale Set Float
zoom scale percentChange direction =
  { scale | domain = Scale.Linear.zoom scale.domain percentChange direction }

pan : Scale Set Float -> Float -> Scale Set Float
pan scale change =
  { scale | domain = Scale.Linear.pan scale.domain change }

panInPixels : Scale Set Float -> Float -> Scale Set Float
panInPixels scale change =
  { scale | domain = Scale.Linear.panInPixels scale.domain scale.range change }

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

rescaleX : BoundingBox -> Scale a b -> Scale a b
rescaleX bBox scale =
  rescale bBox Scale.Type.XScale scale

rescaleY : BoundingBox -> Scale a b -> Scale a b
rescaleY bBox scale =
  rescale bBox Scale.Type.YScale scale

inDomain : Scale a b -> b -> Bool
inDomain scale point =
  scale.inDomain scale.domain point
