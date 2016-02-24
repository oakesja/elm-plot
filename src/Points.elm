module Points where

import Private.Models exposing (Points, TransformedPoints, Scale, PointValue)
import Point
import Svg exposing (Svg)

transform : Scale a -> Scale b -> Points a b -> TransformedPoints
transform xScale yScale points =
  List.map (Point.transform xScale yScale) points

toSvg : (Float -> Float -> Svg) -> TransformedPoints -> List Svg
toSvg pointToSvg points =
  List.map (\p -> pointToSvg p.x.value p.y.value) points
