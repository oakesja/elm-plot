module Area where

import Private.Models exposing (Interpolation, Area, AreaPoint)
import Scale.Scale exposing (Scale)
import Scale
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, stroke, strokeWidth)

interpolate : Scale x a -> Scale y b -> Area a b -> Area Float Float
interpolate xScale yScale area =
  List.map (rescaleAreaPoint xScale yScale) area

rescaleAreaPoint : Scale x a -> Scale y b -> AreaPoint a b -> AreaPoint Float Float
rescaleAreaPoint xScale yScale point =
  { x = .value <| Scale.interpolate xScale point.x
  , y = .value <| Scale.interpolate yScale point.y
  , y2 = .value <| Scale.interpolate yScale point.y2
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
