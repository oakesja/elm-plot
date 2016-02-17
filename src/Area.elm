module Area where

import Line.Interpolation exposing (Interpolation)
import Scale exposing (Scale)
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, stroke, strokeWidth)

type alias AreaPoint = { x : Float, y : Float, y2 : Float }
type alias Area = List AreaPoint

rescale : Scale -> Scale -> Area -> Area
rescale xScale yScale area =
  List.map (rescaleAreaPoint xScale yScale) area

rescaleAreaPoint : Scale -> Scale -> AreaPoint -> AreaPoint
rescaleAreaPoint xScale yScale point =
  { x = xScale.rescale point.x
  , y = yScale.rescale point.y
  , y2 = yScale.rescale point.y2
  }

toSvg : Interpolation -> Area -> Svg
toSvg interpolation area =
  path
    [ d <| pathString interpolation area
    ]
    []

pathString : Interpolation -> Area -> String
pathString int area =
  let
    points0 = List.map (\a -> {x = a.x, y = a.y }) area
    points1 = List.map (\a -> {x = a.x, y = a.y2 }) area
  in
    "M" ++ (int points0) ++ "L" ++ (int points1) ++ "Z"
