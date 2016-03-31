module Area where

import Private.Models exposing (Point)
import Line.Interpolation exposing (Interpolation)
import BoundingBox exposing (BoundingBox)
import Scale.Scale exposing (Scale)
import Scale
import Svg exposing (Svg, path, g)
import Svg.Attributes exposing (d, stroke, strokeWidth)
import Polygon

type alias AreaPoint a b = { x : a, y : b, y2 : b }
type alias Area a b = List (AreaPoint a b)
type alias InterpolatedArea = List (Point Float Float)

-- TODO use point constructor
interpolate : BoundingBox -> Scale x a -> Scale y b -> Area a b -> InterpolatedArea
interpolate bBox xScale yScale area =
  let
    interpolatePoint = (\x y -> Point (Scale.interpolate xScale x).value (Scale.interpolate yScale y).value)
  in
    List.append
      (List.map (\p -> interpolatePoint p.x p.y) area)
      (List.reverse (List.map (\p -> interpolatePoint p.x p.y2) area))
      |> Polygon.clip bBox

toSvg : Interpolation -> List Svg.Attribute -> InterpolatedArea -> Svg
toSvg intMethod attrs area =
  g
    []
    [ path
        ((d (pathString intMethod area)) :: attrs)
        []
    ]

pathString : Interpolation -> List (Point Float Float) -> String
pathString intMethod area =
  if List.length area == 0 then
    ""
  else if List.length area == 1 then
    "M" ++ (intMethod area)
  else
    "M" ++ (intMethod area) ++ "Z"
