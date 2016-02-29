module Points (interpolate, toSvg) where

import Private.Models exposing (Points, InterpolatedPoint, PointValue, Point)
import Scale.Scale exposing (Scale)
import Scale
import Point
import Svg exposing (Svg, rect)

interpolate : Scale x a -> Scale y b -> Points a b -> List (InterpolatedPoint a b)
interpolate xScale yScale points =
  List.map
    (Point.interpolate xScale yScale)
    (filterPointsOutOfDomain xScale yScale points)

toSvg : (Float -> Float -> Svg) -> List (InterpolatedPoint a b) -> List Svg
toSvg pointToSvg points =
  List.map (\p -> pointToSvg p.x.value p.y.value) points

filterPointsOutOfDomain : Scale x a -> Scale y b -> Points a b -> Points a b
filterPointsOutOfDomain xScale yScale points =
  case points of
    [] ->
      points
    hd :: tail ->
      if insideDomain xScale yScale hd then
        hd :: filterPointsOutOfDomain xScale yScale tail
      else
        filterPointsOutOfDomain xScale yScale tail

insideDomain : Scale x a -> Scale y b -> Point a b -> Bool
insideDomain xScale yScale point =
  Scale.inDomain xScale point.x && Scale.inDomain yScale point.y
