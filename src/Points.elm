module Points where

import Private.Models exposing (Points, InterpolatedPoint, PointValue)
import Scale.Scale exposing (Scale)
import Point
import Svg exposing (Svg, rect)

interpolate : Scale x a -> Scale y b -> Points a b -> List (InterpolatedPoint a b)
interpolate xScale yScale points =
  List.map (Point.interpolate xScale yScale) points

toSvg : (Float -> Float -> Svg) -> List (InterpolatedPoint a b) -> List Svg
toSvg pointToSvg points =
  List.map (\p -> pointToSvg p.x.value p.y.value) points
