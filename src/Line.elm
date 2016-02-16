module Line where

import Line.InterpolationModes exposing (InterpolationMode)
import Points exposing (Points)
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, stroke, strokeWidth, fill)
import Scale exposing (Scale)

type alias Line = {points : Points, mode : InterpolationMode}

rescale : Scale -> Scale -> Line -> Line
rescale xScale yScale line =
    { line | points = Points.rescale xScale yScale line.points }

toHtml : Line -> Svg
toHtml line =
  path
    [ d <| "M" ++ line.mode line.points
    , stroke "blue"
    , strokeWidth "2"
    , fill "none"
    ]
    []
