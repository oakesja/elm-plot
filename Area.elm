module Area where

import Line.InterpolationModes exposing (InterpolationMode)
import Scale exposing (Scale)
import Html exposing (Html)
import Svg exposing (path)
import Svg.Attributes exposing (d, stroke, strokeWidth)

type alias AreaPoint = { x : Float, y0 : Float, y1 : Float }
type alias Area = { points : List AreaPoint, mode : InterpolationMode }

rescale : Scale -> Scale -> Area -> Area
rescale xScale yScale area =
  { area
  | points = List.map (rescaleAreaPoint xScale yScale) area.points
  }

rescaleAreaPoint : Scale -> Scale -> AreaPoint -> AreaPoint
rescaleAreaPoint xScale yScale point =
  { x = xScale.rescale point.x
  , y0 = yScale.rescale point.y0
  , y1 = yScale.rescale point.y1
  }

toHtml : Area -> Html
toHtml area =
  path
    [ d <| pathString area
    ]
    []

pathString : Area -> String
pathString area =
  let
    points0 = List.map (\a -> {x = a.x, y = a.y0 }) area.points
    points1 = List.map (\a -> {x = a.x, y = a.y1 }) area.points
  in
    "M" ++ (area.mode points0) ++ "L" ++ (area.mode points1) ++ "Z"
