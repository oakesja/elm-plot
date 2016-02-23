module Axis.Svg where

import Scale exposing (Scale)
import BoundingBox exposing (BoundingBox)
import Axis.Orient exposing (Orient)
import Axis.Axis exposing (Axis)
import Svg exposing (Svg, path, text', g, line)
import Svg.Attributes exposing (d, fill, stroke, shapeRendering, x, y, transform, y2, x2, dy, textAnchor)
import Utils exposing (extentOf)
import Axis.Tick exposing (Tick)

type alias TickInfo =
  { label : String
  , translation : (Float, Float)
  }

toSvg : Axis a -> Svg
toSvg axis =
  g
    [ transform <| axisTranslation axis.boundingBox axis.orient ]
    <| axisSvg axis :: ticksSvg axis

axisTranslation : BoundingBox -> Orient -> String
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
    translateString pos

axisSvg : Axis a -> Svg
axisSvg axis =
  path
     ((d <| pathString axis.boundingBox axis.scale axis.orient axis.outerTickSize) :: axis.axisStyle)
     []

ticksSvg : Axis a -> List Svg
ticksSvg axis =
  List.map (createTick axis) (createTickInfos axis.scale axis.orient)

createTick : Axis a -> TickInfo -> Svg
createTick axis tickInfo =
  g
    [ transform (translateString tickInfo.translation) ]
    [ line ((innerTickLineAttributes axis.orient axis.innerTickSize) ++ axis.innerTickStyle) []
    , text'
      (labelAttributes axis.orient axis.innerTickSize axis.tickPadding axis.labelRotation)
      [ Svg.text tickInfo.label ]
    ]

-- https://github.com/mbostock/d3/blob/5b981a18db32938206b3579248c47205ecc94123/src/svg/axis.js#L53
labelAttributes : Orient -> Int -> Int -> Int -> List Svg.Attribute
labelAttributes orient tickSize tickPadding rotation =
  let
    pos = innerTickLinePos orient (tickSize + tickPadding)
    xString = (toString (fst pos))
    yString = (toString (snd pos))
    posAttrs = [x xString, y yString]
    anchorAttrs = case orient of
      Axis.Orient.Top ->
        [dy "0em", textAnchor "middle"]
      Axis.Orient.Bottom ->
        [dy ".71em", textAnchor "middle"]
      Axis.Orient.Left ->
        [dy ".32em", textAnchor "end"]
      Axis.Orient.Right ->
        [dy ".32em", textAnchor "start"]
  in
    if rotation == 0 then
      posAttrs ++ anchorAttrs
    else
      posAttrs ++ anchorAttrs ++ [transform <| "rotate(" ++ (toString rotation) ++ "," ++ xString ++ "," ++ yString ++ ")"]

innerTickLineAttributes : Orient -> Int -> List Svg.Attribute
innerTickLineAttributes orient tickSize =
  let
    pos = innerTickLinePos orient tickSize
  in
    [ x2 (toString (fst pos)), y2 (toString (snd pos)) ]

innerTickLinePos : Orient -> Int -> (Int, Int)
innerTickLinePos orient tickSize =
  case orient of
    Axis.Orient.Top ->
      (0, -tickSize)
    Axis.Orient.Bottom ->
      (0, tickSize)
    Axis.Orient.Left ->
      (-tickSize, 0)
    Axis.Orient.Right ->
      (tickSize, 0)

createTickInfos : Scale a -> Orient -> List TickInfo
createTickInfos scale orient =
  List.map (createTickInfo scale orient) (Scale.createTicks scale)

createTickInfo : Scale a -> Orient -> Tick -> TickInfo
createTickInfo scale orient tick =
  let
    translation =
      if orient == Axis.Orient.Top || orient == Axis.Orient.Bottom then
          (tick.position, 0)
      else
          (0, tick.position)
  in
    { label = tick.label, translation = translation }

translateString : (Float, Float) -> String
translateString pos =
  "translate(" ++ (toString (fst pos)) ++ "," ++ (toString (snd pos)) ++ ")"

pathString : BoundingBox -> Scale a -> Orient -> Int -> String
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
