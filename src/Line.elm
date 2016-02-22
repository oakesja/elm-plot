module Line where

import Line.Interpolation exposing (Interpolation)
import Points exposing (Points, TransformedPoints)
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, stroke, strokeWidth, fill)
import Scale exposing (Scale)

type alias Line a b = Points a b

rescale : Scale a -> Scale b -> Line a b -> TransformedPoints
rescale xScale yScale line =
  Points.rescale xScale yScale line

toSvg : Interpolation -> List Svg.Attribute -> TransformedPoints -> Svg
toSvg interpolate attrs line =
  let
    attributes =
      if List.length attrs == 0 then
        [ stroke "blue"
        , strokeWidth "2"
        , fill "none"
        ]
      else
        attrs
  in
  path
    ((d <| "M" ++ interpolate line) :: attributes)
    []
