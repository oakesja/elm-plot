module Area where

import Private.Models exposing (Interpolation, Scale, Area, TransformedArea, TransformedAreaPoint, AreaPoint)
import Scale
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, stroke, strokeWidth)

transform : Scale a -> Scale b -> Area a b -> TransformedArea
transform xScale yScale area =
  List.map (rescaleAreaPoint xScale yScale) area

rescaleAreaPoint : Scale a -> Scale b -> AreaPoint a b -> TransformedAreaPoint
rescaleAreaPoint xScale yScale point =
  { x = Scale.transform xScale point.x
  , y = Scale.transform yScale point.y
  , y2 = Scale.transform yScale point.y2
  }

toSvg : Interpolation -> List Svg.Attribute -> TransformedArea-> Svg
toSvg interpolation attrs area =
  path
    ((d <| pathString interpolation area) :: attrs)
    []

pathString : Interpolation -> TransformedArea -> String
pathString int area =
  let
    points0 = List.map (\a -> {x = a.x, y = a.y }) area
    points1 = List.map (\a -> {x = a.x, y = a.y2 }) area
  in
    "M" ++ (int points0) ++ "L" ++ (int points1) ++ "Z"
