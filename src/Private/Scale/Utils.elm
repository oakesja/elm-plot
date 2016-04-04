module Private.Scale.Utils where

import Private.Scale exposing (Scale)
import Private.PointValue exposing (PointValue)
import Private.Tick exposing (Tick)
import Private.BoundingBox exposing (BoundingBox)
import Private.Extras.Set as Set exposing (Set, Set)

type ScaleType = XScale | YScale

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
  rescale bBox XScale scale

rescaleY : BoundingBox -> Scale a b -> Scale a b
rescaleY bBox scale =
  rescale bBox YScale scale

inDomain : Scale a b -> b -> Bool
inDomain scale point =
  scale.inDomain scale.domain point

calculateExtent : BoundingBox -> ScaleType -> Set -> Set
calculateExtent bBox sType set =
  let
    extent = Set.extentOf set
    calc =
      if sType == XScale then
        Set.create (max extent.start bBox.xStart) (min extent.end bBox.xEnd)
      else
        Set.create (max extent.start bBox.yStart) (min extent.end bBox.yEnd)
  in
    if Set.isDescending set then
      Set.reverse calc
    else
      calc
