module Private.Bars where

import Private.Point exposing (InterpolatedPoint)
import Private.BoundingBox exposing (BoundingBox)
import Svg exposing (Svg, rect)
import Private.Extras.SvgAttributes exposing (x, y, height, width)

type Orient = Vertical | Horizontal
type alias PosInfo = {x: Float, y: Float, width: Float, height: Float}

toSvg : BoundingBox -> Orient -> List Svg.Attribute -> List (InterpolatedPoint a b) -> List Svg
toSvg bBox orient additionalAttrs points =
  List.map (createBar bBox orient additionalAttrs) points

createBar : BoundingBox -> Orient -> List Svg.Attribute -> InterpolatedPoint a b -> Svg
createBar bBox orient additionalAttrs point =
  rect
    (barAttrs bBox orient additionalAttrs point)
    []

barAttrs : BoundingBox -> Orient -> List Svg.Attribute -> InterpolatedPoint a b -> List Svg.Attribute
barAttrs bBox orient additionalAttrs point =
  let
    pos = posInfo bBox orient point
  in
    [ x pos.x
    , y pos.y
    , width pos.width
    , height pos.height
    ] ++ additionalAttrs

posInfo : BoundingBox -> Orient -> InterpolatedPoint a b -> PosInfo
posInfo bBox orient point =
  case orient of
    Vertical ->
      { x = point.x.value
      , y = point.y.value
      , width = point.x.width
      , height = bBox.yEnd - point.y.value
      }
    Horizontal ->
      { x = bBox.xStart
      , y = point.y.value
      , width = point.x.value - bBox.xStart
      , height = point.y.width
      }
