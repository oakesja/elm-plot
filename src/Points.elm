module Points where

import Point exposing (Point, TransformedPoint)
import Scale exposing (Scale)
import Svg exposing (Svg)

type alias Points a b = List (Point a b)
type alias TransformedPoints = List TransformedPoint

rescale : Scale a -> Scale b -> Points a b -> TransformedPoints
rescale xScale yScale points =
  List.map (Point.rescale xScale yScale) points

toSvg : (Float -> Float -> Svg) -> TransformedPoints -> List Svg
toSvg pointToSvg points =
  List.map (\p -> pointToSvg p.x p.y) points
