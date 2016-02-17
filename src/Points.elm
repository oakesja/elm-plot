module Points where

import Point exposing (Point)
import Scale exposing (Scale)
import Svg exposing (Svg)

type alias Points = List Point

rescale : Scale -> Scale -> Points -> Points
rescale xScale yScale points =
  List.map (Point.rescale xScale yScale) points

toSvg : (Float -> Float -> Svg) -> Points -> List Svg
toSvg pointToSvg points =
  List.map (\p -> pointToSvg p.x p.y) points
