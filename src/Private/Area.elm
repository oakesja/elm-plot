module Private.Area where

import Private.Point exposing (Point)
import Plot.Interpolation exposing (Interpolation)
import Private.BoundingBox exposing (BoundingBox)
import Private.Scale.Utils as Scale
import Private.Scale as Scale exposing (Scale)
import Svg exposing (Svg, path, g)
import Svg.Attributes exposing (d, stroke, strokeWidth)
import Private.Polygon as Polygon

type alias AreaPoint a b =
  { x : a
  , y : b
  , y2 : b
  }
type alias Area a b = List (AreaPoint a b)
type alias InterpolatedArea = List (Point Float Float)

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
