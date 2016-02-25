module Area where

import Private.Models exposing (Interpolation, Area, AreaPoint)
import Scale.Scale exposing (Scale)
import Scale
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, stroke, strokeWidth)

transform : Scale a -> Scale b -> Area a b -> Area Float Float
transform xScale yScale area =
  List.map (rescaleAreaPoint xScale yScale) area

rescaleAreaPoint : Scale a -> Scale b -> AreaPoint a b -> AreaPoint Float Float
rescaleAreaPoint xScale yScale point =
  { x = .value <| Scale.transform xScale point.x
  , y = .value <| Scale.transform yScale point.y
  , y2 = .value <| Scale.transform yScale point.y2
  }

toSvg : Interpolation -> List Svg.Attribute -> Area Float Float-> Svg
toSvg interpolation attrs area =
  path
    ((d <| pathString interpolation area) :: attrs)
    []

pathString : Interpolation -> Area Float Float -> String
pathString int area =
  let
    points0 = List.map (\a -> {x = a.x, y = a.y }) area
    points1 = List.map (\a -> {x = a.x, y = a.y2 }) area
  in
    "M" ++ (int points0) ++ "L" ++ (int points1) ++ "Z"
