module Private.Path where

import Private.Models exposing (Points, Path, Point)
import Plot.Interpolation exposing (Interpolation)
import Private.BoundingBox exposing (BoundingBox)
import Private.Scale exposing (Scale)
import Private.Point as Point
import Svg exposing (Svg, path, g)
import Svg.Attributes exposing (d, stroke, strokeWidth, fill)
import Private.Line exposing (clipPath)

-- TODO add test
interpolate : BoundingBox -> Scale x a -> Scale y b -> Path a b -> List (Path Float Float)
interpolate bBox xScale yScale path =
  let
    interpolatePath =
      \p ->
        let
          point = Point.interpolate xScale yScale p
        in
          Point point.x.value point.y.value
  in
    clipPath bBox (List.map interpolatePath path)

toSvg : Interpolation -> List Svg.Attribute -> List (Path Float Float) -> Svg
toSvg intMethod attrs paths =
  g
    []
    (List.map (pathToSvg intMethod attrs) paths)

pathToSvg : Interpolation -> List Svg.Attribute -> Path Float Float -> Svg
pathToSvg intMethod attrs p =
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
    ((d <| "M" ++ intMethod (linePositions p)) :: attributes)
    []

linePositions : Path Float Float -> Points Float Float
linePositions path =
  List.map (\p -> {x = p.x, y = p.y}) path
