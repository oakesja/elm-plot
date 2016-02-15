module Axis where

import Scale exposing (Scale)
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, fill, stroke, shapeRendering)

type Orientation = Top | Bottom | Left | Right
type alias Axis = {orient : Orientation, ticks : Int}

toHtml : Scale -> Maybe Axis -> List Svg
toHtml scale axis =
  case axis of
    Just axis ->
      [ path
         [ d <| pathString scale axis
         , fill "none"
         , stroke "#000"
         , shapeRendering "crispEdges"
         ]
         []
      ]
    Nothing ->
      []

pathString : Scale -> Axis -> String
pathString scale axis =
  "M" ++ toString (fst scale.range) ++ ",6V0H" ++ toString (snd scale.range) ++ "V6"
