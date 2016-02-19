module Axis where

import Scale exposing (Scale)
import Svg exposing (Svg, path)
import Svg.Attributes exposing (d, fill, stroke, shapeRendering)
import BoundingBox exposing (BoundingBox)


type Orient = Top | Bottom | Left | Right
type alias Axis =
  { scale : Scale
  , orient : Orient
  , boundingBox : BoundingBox
  }

toSvg : Axis -> Svg
toSvg axis =
  path
     [ d <| pathString axis.boundingBox axis.scale axis.orient
     , fill "none"
     , stroke "#000"
     , shapeRendering "crispEdges"
     ]
     []

pathString : BoundingBox -> Scale -> Orient -> String
pathString bBox scale orient =
  let
    r1 = toString (fst scale.range)
    r2 = toString (snd scale.range)
    tickSize = 6
  in
    case orient of
      Top ->
        "M" ++ r1 ++ "," ++ (toString <| bBox.yStart - tickSize) ++ "V" ++ (toString bBox.yStart) ++ "H" ++ r2 ++ "V" ++ (toString <| bBox.yStart - tickSize)
      Bottom ->
        "M" ++ r1 ++ "," ++ (toString <| bBox.yEnd + tickSize) ++ "V" ++ (toString bBox.yEnd) ++ "H" ++ r2 ++ "V" ++ (toString <| bBox.yEnd + tickSize)
      Left ->
        "M" ++ (toString <| bBox.xStart - tickSize) ++ "," ++ r1 ++ "H" ++ (toString bBox.xStart) ++ "V" ++ r2 ++ "H" ++ (toString <| bBox.xStart - tickSize)
      Right ->
        "M" ++ (toString <| bBox.xEnd + tickSize) ++ "," ++ r1 ++ "H" ++ (toString bBox.xEnd) ++ "V" ++ r2 ++ "H" ++ (toString <| bBox.xEnd + tickSize)
