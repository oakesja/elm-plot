module Line where

import Line.Interpolation exposing (Interpolation)
import Points exposing (Points)
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, stroke, strokeWidth, fill)
import Scale exposing (Scale)

type alias Line = Points

rescale : Scale -> Scale -> Line -> Line
rescale xScale yScale line =
  Points.rescale xScale yScale line

toSvg : Interpolation -> Line -> Svg
toSvg interpolate line =
  path
    [ d <| "M" ++ interpolate line
    , stroke "blue"
    , strokeWidth "2"
    , fill "none"
    ]
    []
