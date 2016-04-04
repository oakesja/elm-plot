module Private.Path where

import Plot.Interpolation exposing (Interpolation)
import Private.BoundingBox exposing (BoundingBox)
import Private.Scale exposing (Scale)
import Private.Point as Point exposing (Point)
import Svg exposing (Svg, path, g)
import Svg.Attributes exposing (d, stroke, strokeWidth, fill)
import Private.Line exposing (clipPath)

type alias Path a b = List (Point a b)

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

linePositions : Path Float Float -> Path Float Float
linePositions path =
  List.map (\p -> {x = p.x, y = p.y}) path
