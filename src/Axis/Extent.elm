module Axis.Extent where

import Private.Models exposing (Extent, BoundingBox)
import Axis.Orient exposing (Orient)
import Utils exposing (extentOf)

calculateExtent : BoundingBox -> Orient -> (Float, Float) -> Extent
calculateExtent bBox orient range =
  let
    extent = extentOf range
  in
    if orient == Axis.Orient.Top || orient == Axis.Orient.Bottom then
      { start = max (fst extent) bBox.xStart
      , stop = min (snd extent) bBox.xEnd
      }
    else
      { start = max (fst extent) bBox.yStart
      , stop = min (snd extent) bBox.yEnd
      }

createExtent : Float -> Float -> Extent
createExtent start stop =
  { start = start, stop = stop }
