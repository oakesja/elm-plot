module Plot.Scale where

import Private.Scale.Linear as LinearScale
import Private.Scale.OrdinalPoints as OrdinalPoints
import Private.Scale.OrdinalBands as OrdinalBands
import Private.Extras.Set as Set exposing (Set)
import Plot.Zoom as Zoom
import Private.Scale exposing (Scale)

type alias LinearScale = Scale Set Float
type alias OrdinalScale = Scale (List String) String

linear : (Float, Float) -> (Float, Float) -> Int -> LinearScale
linear domain range numTicks =
  { domain = Set.createFromTuple domain
  , range = Set.createFromTuple range
  , interpolate = LinearScale.interpolate
  , uninterpolate = LinearScale.uninterpolate
  , createTicks = LinearScale.createTicks numTicks
  , inDomain = LinearScale.inDomain
  }

ordinalPoints : List String -> (Float, Float) -> Int -> OrdinalScale
ordinalPoints domain range padding =
  let
    mapping = OrdinalPoints.createMapping padding
  in
    { domain = domain
    , range = Set.createFromTuple range
    , interpolate = OrdinalPoints.interpolate mapping
    , uninterpolate = OrdinalPoints.uninterpolate mapping
    , createTicks = OrdinalPoints.createTicks mapping
    , inDomain = OrdinalPoints.inDomain
    }

ordinalBands : List String -> (Float, Float) -> Float -> Float -> OrdinalScale
ordinalBands domain range padding outerPadding =
  let
    mapping = OrdinalBands.createMapping padding outerPadding
  in
    { domain = domain
    , range = Set.createFromTuple range
    , interpolate = OrdinalBands.interpolate mapping
    , uninterpolate = OrdinalBands.uninterpolate mapping
    , createTicks = OrdinalBands.createTicks mapping
    , inDomain = OrdinalBands.inDomain
    }

zoom : Scale Set Float -> Float -> Zoom.Direction ->  Scale Set Float
zoom scale percentChange direction =
  { scale | domain = LinearScale.zoom scale.domain percentChange direction }

pan : Scale Set Float -> Float -> Scale Set Float
pan scale change =
  { scale | domain = LinearScale.pan scale.domain change }

panInPixels : Scale Set Float -> Float -> Scale Set Float
panInPixels scale change =
  { scale | domain = LinearScale.panInPixels scale.domain scale.range change }
