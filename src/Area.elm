module Area where

import Line.Interpolation exposing (Interpolation)
import Scale exposing (Scale)
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, stroke, strokeWidth)

type alias AreaPoint a b = { x : a, y : b, y2 : b }
type alias TransformedAreaPoint = { x : Float, y : Float, y2 : Float }
type alias Area a b = List (AreaPoint a b)
type alias TransformedArea = List TransformedAreaPoint

rescale : Scale a -> Scale b -> Area a b -> TransformedArea
rescale xScale yScale area =
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
