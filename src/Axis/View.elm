module Axis.View where

import Private.Models exposing (BoundingBox)
import Axis.Axis exposing (Axis)
import Scale.Scale exposing (Scale)
import Axis.Orient exposing (Orient)
import Svg exposing (Svg, g, path)
import Svg.Attributes exposing (d)
import Sets exposing (extentOf)
import SvgAttributesExtras exposing (translate)
import Axis.Ticks
import Axis.Extent exposing (calculateExtent)
import Axis.Title

toSvg : Axis a b -> Svg
toSvg axis =
  let
    extent = calculateExtent axis.boundingBox axis.orient axis.scale.range
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
  path
     ((d <| pathString axis.boundingBox axis.scale axis.orient axis.outerTickSize) :: axis.axisAttributes)
     []

pathString : BoundingBox -> Scale a b -> Orient -> Int -> String
pathString bBox scale orient tickSize =
  let
    extent = extentOf scale.range
    start = fst extent
    end = snd extent
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
    start = if xStart < bBox.xStart then bBox.xStart else xStart
    end = if xEnd > bBox.xEnd then bBox.xEnd else xEnd
  in
    (toString start) ++ "," ++ (toString tickLocation) ++ "V0H" ++ (toString end) ++ "V" ++ (toString tickLocation)

horizontalAxisString : BoundingBox -> Int -> Float -> Float -> String
horizontalAxisString bBox tickLocation yStart yEnd =
  let
    start = if yStart < bBox.yStart then bBox.yStart else yStart
    end = if yEnd > bBox.yEnd then bBox.yEnd else yEnd
  in
    (toString tickLocation) ++ "," ++ (toString start) ++ "H0V" ++ (toString end) ++ "H" ++ (toString tickLocation)
