module Bars where

import Private.Models exposing (TransformedPoints, TransformedPoint, BoundingBox)
import Svg exposing (Svg, rect)
import Svg.Attributes exposing (x, y, height, width)

type Orient = Vertical | Horizontal

toSvg : BoundingBox -> Orient -> List Svg.Attribute -> TransformedPoints -> List Svg
toSvg bBox orient additionalAttrs points =
  List.map (createBar bBox orient additionalAttrs) points

createBar : BoundingBox -> Orient -> List Svg.Attribute -> TransformedPoint -> Svg
createBar bBox orient additionalAttrs point =
  rect
    (barAttrs bBox orient additionalAttrs point)
    []

barAttrs : BoundingBox -> Orient -> List Svg.Attribute -> TransformedPoint -> List Svg.Attribute
barAttrs bBox orient additionalAttrs point =
  let
    pos = posInfo bBox orient point
  in
    [ x <| toString pos.x
    , y <| toString pos.y
    , width <| toString pos.width
    , height <| toString pos.height
    ] ++ additionalAttrs

posInfo : BoundingBox -> Orient -> TransformedPoint -> {x: Float, y: Float, width: Float, height: Float}
posInfo bBox orient point =
  case orient of
    Vertical ->
      { x = point.x.value - (point.x.bandWidth / 2)
      , y = point.y.value
      , width = point.x.bandWidth
      , height = bBox.yEnd - point.y.value
      }
    Horizontal ->
      { x = bBox.xStart
      , y = point.y.value - (point.y.bandWidth / 2)
      , width = point.x.value - bBox.xStart
      , height = point.y.bandWidth
      }
