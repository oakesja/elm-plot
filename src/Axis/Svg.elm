module Axis.Svg where

import Scale exposing (Scale)
import BoundingBox exposing (BoundingBox)
import Axis.Orient exposing (Orient)
import Axis.Axis exposing (Axis)
import Svg exposing (Svg, path, text', g)
import Svg.Attributes exposing (d, fill, stroke, shapeRendering, x, y)

toSvg : Axis -> Svg
toSvg axis =
  g
    []
    <| (axisSvg axis) :: ticksSvg axis

axisSvg : Axis -> Svg
axisSvg axis =
  path
     [ d <| pathString axis.boundingBox axis.scale axis.orient
     ]
     []

ticksSvg : Axis -> List Svg
ticksSvg axis =
  let
    vals = axis.scale.ticks axis.numTicks
  in
    List.map (\y -> text axis.boundingBox.xStart (Scale.scale axis.scale y) (toString y)) vals

text : Float -> Float -> String -> Svg
text xPos yPos tex =
  text'
    [ x <| toString xPos
    , y <| toString yPos
    ]
    [ Svg.text tex ]

pathString : BoundingBox -> Scale -> Orient -> String
pathString bBox scale orient =
  let
    start = fst scale.range
    end = snd scale.range
    tickSize = 6
    path = case orient of
      Axis.Orient.Top ->
        verticalAxisString (bBox.yStart - tickSize) start end bBox.yStart
      Axis.Orient.Bottom ->
        verticalAxisString (bBox.yEnd + tickSize) start end bBox.yEnd
      Axis.Orient.Left ->
        horizontalAxisString (bBox.xStart - tickSize) start end bBox.xStart
      Axis.Orient.Right ->
        horizontalAxisString (bBox.xEnd + tickSize) start end bBox.xEnd
  in
    "M" ++ path

verticalAxisString : Float -> Float -> Float -> Float -> String
verticalAxisString tickLocation start end y =
  (toString start) ++ "," ++ (toString tickLocation) ++ "V" ++ (toString y) ++ "H" ++ (toString end) ++ "V" ++ (toString tickLocation)

horizontalAxisString : Float -> Float -> Float -> Float -> String
horizontalAxisString tickLocation start end x =
  (toString tickLocation) ++ "," ++ (toString start) ++ "H" ++ (toString x) ++ "V" ++ (toString end) ++ "H" ++ (toString tickLocation)
