module Rules where

import Scale.Scale exposing (Scale)
import Scale
import Private.Models exposing (PointValue, BoundingBox)
import Svg exposing (Svg, line)
import Svg.Attributes exposing (stroke)
import SvgAttributesExtra exposing (x1, x2, y1, y2)

type Direction = Vertical | Horizontal

interpolate : List a -> Scale x a -> List (PointValue a)
interpolate vals scale =
  List.map (Scale.interpolate scale) vals

toSvgs : BoundingBox -> List Svg.Attribute -> Direction -> List (PointValue a) -> List Svg
toSvgs bBox attrs direction points =
  List.map (createRule bBox attrs direction) points

createRule : BoundingBox -> List Svg.Attribute -> Direction -> PointValue a -> Svg
createRule bBox attrs direction point =
  line
    (lineAttrs bBox attrs direction point)
    []

lineAttrs : BoundingBox -> List Svg.Attribute -> Direction -> PointValue a -> List Svg.Attribute
lineAttrs bBox attrs direction point =
  let
    pos = posAttrs bBox direction point
  in
    if List.isEmpty attrs then
      pos ++ [stroke "black"]
    else
      pos ++ attrs

posAttrs : BoundingBox -> Direction -> PointValue a -> List Svg.Attribute
posAttrs bBox direction point =
  case direction of
    Vertical ->
      [ x1 point.value
      , y1 bBox.yStart
      , x2 point.value
      , y2 bBox.yEnd
      ]
    Horizontal ->
      [ x1 bBox.xStart
      , y1 point.value
      , x2 bBox.xEnd
      , y2 point.value
      ]
