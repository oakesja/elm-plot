module Line where

import Private.Models exposing (Points, Interpolation, Line, InterpolatedLine)
import Scale.Scale exposing (Scale)
import Point
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, stroke, strokeWidth, fill)

interpolate : Scale x a -> Scale y b -> Line a b -> InterpolatedLine a b
interpolate xScale yScale line =
  List.map (Point.interpolate xScale yScale) line

toSvg : Interpolation -> List Svg.Attribute -> InterpolatedLine a b -> Svg
toSvg interpolate attrs line =
  let
    attributes =
      if List.length attrs == 0 then
        [ stroke "blue"
        , strokeWidth "2"
        , fill "none"
        ]
      else
        attrs
  in
  path
    ((d <| "M" ++ interpolate (linePositions line)) :: attributes)
    []

linePositions : InterpolatedLine a b -> Points Float Float
linePositions points =
  List.map (\p -> {x = p.x.value, y = p.y.value}) points
