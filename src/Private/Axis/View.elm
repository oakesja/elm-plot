module Private.Axis.View where

import Private.BoundingBox exposing (BoundingBox)
import Plot.Axis as Axis exposing (Axis, Orient)
import Private.Scale exposing (Scale)
import Svg exposing (Svg, g, path)
import Svg.Attributes exposing (d)
import Private.Extras.Set as Set exposing (Set)
import Private.Extras.SvgAttributes exposing (translate)
import Private.Axis.Ticks as AxisTicks
import Private.Axis.Title as AxisTitle

toSvg : Axis a b -> Svg
toSvg axis =
  let
    extent = calculateAxisExtent axis.boundingBox axis.orient axis.scale.range
  in
    g
      [ axisTranslation axis.boundingBox axis.orient ]
      <| List.concat
          [ [axisSvg axis]
          , AxisTicks.createTicks axis
          , AxisTitle.createTitle extent axis.orient axis.innerTickSize axis.tickPadding axis.titleAttributes axis.titleOffset axis.title
          ]

calculateAxisExtent : BoundingBox -> Orient -> Set -> Set
calculateAxisExtent bBox orient set =
  let
    extent = Set.extentOf set
    calc =
      if orient == Axis.Top || orient == Axis.Bottom then
        Set.create (max extent.start bBox.xStart) (min extent.end bBox.xEnd)
      else
        Set.create (max extent.start bBox.yStart) (min extent.end bBox.yEnd)
  in
    Set.extentOf(calc)

axisTranslation : BoundingBox -> Orient -> Svg.Attribute
axisTranslation bBox orient =
  let
    pos = case orient of
      Axis.Top ->
        (0, bBox.yStart)
      Axis.Bottom ->
        (0, bBox.yEnd)
      Axis.Left ->
        (bBox.xStart, 0)
      Axis.Right ->
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
    extent = Set.extentOf scale.range
    start = extent.start
    end = extent.end
    path = case orient of
      Axis.Top ->
        verticalAxisString bBox -tickSize start end
      Axis.Bottom ->
        verticalAxisString bBox tickSize start end
      Axis.Left ->
        horizontalAxisString bBox -tickSize start end
      Axis.Right ->
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
