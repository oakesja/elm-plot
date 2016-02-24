module Line where

import Private.Models exposing (Points, TransformedPoints, Interpolation, Scale, Line)
import Points
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, stroke, strokeWidth, fill)

rescale : Scale a -> Scale b -> Line a b -> TransformedPoints
rescale xScale yScale line =
  Points.transform xScale yScale line

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
