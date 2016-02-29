module Line where

import Private.Models exposing (Points, Interpolation, Line, InterpolatedPoint)
import Scale.Scale exposing (Scale)
import Point
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, stroke, strokeWidth, fill)

-- TODO create interpolated line model
interpolate : Scale x a -> Scale y b -> Line a b -> List (InterpolatedPoint a b)
interpolate xScale yScale line =
  List.map (Point.interpolate xScale yScale) line

toSvg : Interpolation -> List Svg.Attribute -> List (InterpolatedPoint a b) -> Svg
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

linePositions : List (InterpolatedPoint a b) -> Points Float Float
linePositions points =
  List.map (\p -> {x = p.x.value, y = p.y.value}) points
