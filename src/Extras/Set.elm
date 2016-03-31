module Extras.Set where

import BoundingBox exposing (BoundingBox)
import Axis.Orient exposing (Orient)
import Scale.Type exposing (ScaleType)

type alias Set = { start : Float, end : Float }
-- TODO These may not be useful now
type alias Domain = Set
type alias Range = Set
type alias Extent = Set

create : Float -> Float -> Set
create start end =
  { start = start
  , end = end
  }

createFromTuple : (Float, Float) -> Set
createFromTuple set =
  create (fst set) (snd set)

extentOf : Set -> Set
extentOf set =
  if isAscending set then
    set
  else
    reverse set

span : Set -> Float
span set =
  abs (set.end - set.start)

isAscending : Set -> Bool
isAscending set =
  set.start < set.end

isDescending : Set -> Bool
isDescending set =
  set.start > set.end

reverse : Set -> Set
reverse set =
  create set.end set.start

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
    extent = extentOf set
    calc =
      if sType == Scale.Type.XScale then
        create (max extent.start bBox.xStart) (min extent.end bBox.xEnd)
      else
        create (max extent.start bBox.yStart) (min extent.end bBox.yEnd)
  in
    if isDescending set then
      reverse calc
    else
      calc
