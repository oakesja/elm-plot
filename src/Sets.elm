module Sets where

import Private.Models exposing (BoundingBox)
import Axis.Orient exposing (Orient)
import Scale.Type exposing (ScaleType)

type alias Set = (Float, Float)
type alias Domain = Set
type alias Range = Set
type alias Extent = Set

extentOf : Set -> Set
extentOf set =
  if fst set < snd set then
    set
  else
    (snd set, fst set)

calculateAxisExtent : BoundingBox -> Orient -> Set -> Set
calculateAxisExtent bBox orient range =
  let
    sType =
      if orient == Axis.Orient.Top || orient == Axis.Orient.Bottom then
        Scale.Type.XScale
      else
        Scale.Type.YScale
  in
    extentOf (calculateExtent bBox sType range)

calculateExtent : BoundingBox -> ScaleType -> Set -> Set
calculateExtent bBox sType set =
  let
    reverse = fst set > snd set
    extent = extentOf set
    calc =
      if sType == Scale.Type.XScale then
        (max (fst extent) bBox.xStart, min (snd extent) bBox.xEnd)
      else
        (max (fst extent) bBox.yStart, min (snd extent) bBox.yEnd)
  in
    if reverse then
      (snd calc, fst calc)
    else
      calc
