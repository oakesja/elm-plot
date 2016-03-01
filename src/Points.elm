module Points where

import Private.Models exposing (Points, InterpolatedPoints, PointValue)
import Scale.Scale exposing (Scale)
import Point
import Svg exposing (Svg, rect)

interpolate : Scale x a -> Scale y b -> Points a b -> InterpolatedPoints a b
interpolate xScale yScale points =
  List.map (Point.interpolate xScale yScale) points

toSvg : (Float -> Float -> Svg) -> InterpolatedPoints a b -> List Svg
toSvg pointToSvg points =
  List.map (\p -> pointToSvg p.x.value p.y.value) points
