module Points where

import Private.Models exposing (Points, PointWithBands, PointValue)
import Scale.Scale exposing (Scale)
import Point
import Svg exposing (Svg, rect)

transformIntoBands : Scale a -> Scale b -> Points a b -> List PointWithBands
transformIntoBands xScale yScale points =
  List.map (Point.transformIntoBand xScale yScale) points

transformIntoPoints : Scale a -> Scale b -> Points a b -> Points Float Float
transformIntoPoints xScale yScale points =
  List.map (Point.transformIntoPoint xScale yScale) points

toSvg : (Float -> Float -> Svg) -> Points Float Float -> List Svg
toSvg pointToSvg points =
  List.map (\p -> pointToSvg p.x p.y) points
