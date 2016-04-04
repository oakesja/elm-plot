module Plot.Scale where

import Private.Scale.Linear as LinearScale
import Private.Scale.OrdinalPoints as OrdinalPoints
import Private.Scale.OrdinalBands as OrdinalBands
import Private.Models exposing (PointValue)
import Private.Tick exposing (Tick)
import Private.BoundingBox exposing (BoundingBox)
import Private.Scale.Type as ScaleType exposing (ScaleType)
import Private.Extras.Set as Set exposing (Set, Range)
import Plot.Zoom as Zoom
import Private.Scale exposing (Scale)

-- TODO consider a more functional approach to this

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
  rescale bBox ScaleType.XScale scale

rescaleY : BoundingBox -> Scale a b -> Scale a b
rescaleY bBox scale =
  rescale bBox ScaleType.YScale scale

inDomain : Scale a b -> b -> Bool
inDomain scale point =
  scale.inDomain scale.domain point

calculateExtent : BoundingBox -> ScaleType -> Set -> Set
calculateExtent bBox sType set =
  let
    extent = Set.extentOf set
    calc =
      if sType == ScaleType.XScale then
        Set.create (max extent.start bBox.xStart) (min extent.end bBox.xEnd)
      else
        Set.create (max extent.start bBox.yStart) (min extent.end bBox.yEnd)
  in
    if Set.isDescending set then
      Set.reverse calc
    else
      calc
