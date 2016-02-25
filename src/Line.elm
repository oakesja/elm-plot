module Line where

import Private.Models exposing (Points, Interpolation, Line)
import Scale.Scale exposing (Scale)
import Points
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, stroke, strokeWidth, fill)

transform : Scale a -> Scale b -> Line a b -> Line Float Float
transform xScale yScale line =
  Points.transformIntoPoints xScale yScale line

toSvg : Interpolation -> List Svg.Attribute -> Points Float Float -> Svg
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
