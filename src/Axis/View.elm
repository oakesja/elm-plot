module Axis.View where

import BoundingBox exposing (BoundingBox)
import Axis exposing (Axis)
import Scale.Scale exposing (Scale)
import Axis.Orient exposing (Orient)
import Svg exposing (Svg, g, path)
import Svg.Attributes exposing (d)
import Extras.Set exposing (extentOf, calculateAxisExtent)
import Extras.SvgAttributes exposing (translate)
import Axis.Ticks
import Axis.Title

toSvg : Axis a b -> Svg
toSvg axis =
  let
    extent = calculateAxisExtent axis.boundingBox axis.orient axis.scale.range
  in
    g
      [ axisTranslation axis.boundingBox axis.orient ]
      <| List.concat
          [ [axisSvg axis]
          , Axis.Ticks.createTicks axis
          , Axis.Title.createTitle extent axis.orient axis.innerTickSize axis.tickPadding axis.titleAttributes axis.titleOffset axis.title
          ]

axisTranslation : BoundingBox -> Orient -> Svg.Attribute
axisTranslation bBox orient =
  let
    pos = case orient of
      Axis.Orient.Top ->
        (0, bBox.yStart)
      Axis.Orient.Bottom ->
        (0, bBox.yEnd)
      Axis.Orient.Left ->
        (bBox.xStart, 0)
      Axis.Orient.Right ->
        (bBox.xEnd, 0)
  in
    translate pos

axisSvg : Axis a b -> Svg
axisSvg axis =
  let
    ps = pathString axis.boundingBox axis.scale axis.orient axis.outerTickSize
    attrs = (d ps) :: axis.axisAttributes
  in
    path
       attrs
       []

pathString : BoundingBox -> Scale a b -> Orient -> Int -> String
pathString bBox scale orient tickSize =
  let
    extent = extentOf scale.range
    start = extent.start
    end = extent.end
    -- TODO try and create a single case statement
    path = case orient of
      Axis.Orient.Top ->
        verticalAxisString bBox -tickSize start end
      Axis.Orient.Bottom ->
        verticalAxisString bBox tickSize start end
      Axis.Orient.Left ->
        horizontalAxisString bBox -tickSize start end
      Axis.Orient.Right ->
        horizontalAxisString bBox tickSize start end
  in
    "M" ++ path

verticalAxisString : BoundingBox -> Int -> Float -> Float -> String
verticalAxisString bBox tickLocation xStart xEnd =
  let
    start = max xStart bBox.xStart
    end = min xEnd bBox.xEnd
  in
    (toString start) ++ "," ++ (toString tickLocation) ++ "V0H" ++ (toString end) ++ "V" ++ (toString tickLocation)

horizontalAxisString : BoundingBox -> Int -> Float -> Float -> String
horizontalAxisString bBox tickLocation yStart yEnd =
  let
    start = max yStart bBox.yStart
    end = min yEnd bBox.yEnd
  in
    (toString tickLocation) ++ "," ++ (toString start) ++ "H0V" ++ (toString end) ++ "H" ++ (toString tickLocation)
