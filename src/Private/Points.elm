module Private.Points (Points, InterpolatedPoints, interpolate, toSvg) where

import Private.Scale.Utils as Scale
import Private.Scale exposing (Scale)
import Private.Point as Point exposing (InterpolatedPoint, Point)
import Svg exposing (Svg, rect)

type alias Points a b = List (Point a b)
type alias InterpolatedPoints a b = List (InterpolatedPoint a b)

interpolate : Scale x a -> Scale y b -> Points a b -> InterpolatedPoints a b
interpolate xScale yScale points =
  List.map
    (Point.interpolate xScale yScale)
    (filterPointsOutOfDomain xScale yScale points)

toSvg : (Float -> Float -> a -> b -> Svg) -> InterpolatedPoints a b -> List Svg
toSvg pointToSvg points =
  List.map (\p -> pointToSvg p.x.value p.y.value p.x.originalValue p.y.originalValue) points

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
