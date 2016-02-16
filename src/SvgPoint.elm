module SvgPoint where

import Scale exposing (Scale)
import Point exposing (Point)
import Svg exposing (Svg)

type alias SvgPoint =
  { point : Point
  , toHtml : Float -> Float -> Svg
  }

rescale : Scale -> Scale -> SvgPoint -> SvgPoint
rescale xScale yScale sp =
  { sp | point = Point.rescale xScale yScale sp.point  }

toHtml : SvgPoint -> Svg
toHtml sp =
  sp.toHtml sp.point.x sp.point.y
