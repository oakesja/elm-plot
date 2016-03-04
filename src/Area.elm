module Area where

import Private.Models exposing (Interpolation, Area, Point, BoundingBox, AreaPoint)
import Scale.Scale exposing (Scale)
import Scale
import Svg exposing (Svg, path, g)
import Svg.Attributes exposing (d, stroke, strokeWidth)
import Polygon exposing (clip)

interpolate : BoundingBox -> Scale x a -> Scale y b -> Area a b -> List (Point Float Float)
interpolate bBox xScale yScale area =
  let
    interpolatePoint = (\x y -> Point (Scale.interpolate xScale x).value (Scale.interpolate yScale y).value)
  in
    List.map (\p -> interpolatePoint p.x p.y) area
      |> List.append (List.map (\p -> interpolatePoint p.x p.y2) area)
      |> clip bBox

toSvg : Interpolation -> List Svg.Attribute -> List (Point Float Float) -> Svg
toSvg interpolation attrs area =
  g
    []
    [ path
        ((d (pathString interpolation area)) :: attrs)
        []
    ]

pathString : Interpolation -> List (Point Float Float) -> String
pathString int area =
    "M" ++ (int area) ++ "Z"
