module Line where

import Line.InterpolationModes exposing (InterpolationMode)
import Points exposing (Points)
import Html exposing (Html)
import Svg exposing (path)
import Svg.Attributes exposing (d, stroke, strokeWidth, fill)
import Scale exposing (Scale)

type alias Line = {points : Points, mode : InterpolationMode}

rescale : Scale -> Scale -> Line -> Line
rescale xScale yScale line =
    { line | points = Points.rescale xScale yScale line.points }

toHtml : Line -> Html
toHtml line =
  path
    [ d <| line.mode line.points
    , stroke "blue"
    , strokeWidth "2"
    , fill "none"
    ]
    []
