module Private.Axis.Ticks where

import Plot.Axis as Axis exposing (Orient, Axis)
import Private.Tick exposing (Tick)
import Plot.Scale as Scale
import Private.Scale exposing (Scale)
import Svg exposing (Svg, path, text', g, line)
import Svg.Attributes exposing (dy, textAnchor)
import Private.Extras.SvgAttributes exposing (translate, rotate, y2, x2, x, y)

type alias TickInfo =
  { label : String
  , translation : (Float, Float)
  }

createTicks : Axis a b -> List Svg
createTicks axis =
  List.map (createTick axis) (createTickInfos axis.scale axis.orient)

createTick : Axis a b -> TickInfo -> Svg
createTick axis tickInfo =
  g
    [ translate tickInfo.translation ]
    [ line ((innerTickLineAttributes axis.orient axis.innerTickSize) ++ axis.innerTickAttributes) []
    , text'
      (labelAttributes axis.orient axis.innerTickSize axis.tickPadding axis.labelRotation)
      [ Svg.text tickInfo.label ]
    ]

-- https://github.com/mbostock/d3/blob/5b981a18db32938206b3579248c47205ecc94123/src/svg/axis.js#L53
labelAttributes : Orient -> Int -> Int -> Int -> List Svg.Attribute
labelAttributes orient tickSize tickPadding rotation =
  let
    pos = innerTickLinePos orient (tickSize + tickPadding)
    posAttrs = [x (fst pos), y (snd pos)]
    anchorAttrs = case orient of
      Axis.Top ->
        [dy "0em", textAnchor "middle"]
      Axis.Bottom ->
        [dy ".71em", textAnchor "middle"]
      Axis.Left ->
        [dy ".32em", textAnchor "end"]
      Axis.Right ->
        [dy ".32em", textAnchor "start"]
  in
    if rotation == 0 then
      posAttrs ++ anchorAttrs
    else
      posAttrs ++ anchorAttrs ++ [rotate pos rotation]

innerTickLineAttributes : Orient -> Int -> List Svg.Attribute
innerTickLineAttributes orient tickSize =
  let
    pos = innerTickLinePos orient tickSize
  in
    [ x2 (fst pos), y2 (snd pos) ]

innerTickLinePos : Orient -> Int -> (Int, Int)
innerTickLinePos orient tickSize =
  case orient of
    Axis.Top ->
      (0, -tickSize)
    Axis.Bottom ->
      (0, tickSize)
    Axis.Left ->
      (-tickSize, 0)
    Axis.Right ->
      (tickSize, 0)

createTickInfos : Scale a b -> Orient -> List TickInfo
createTickInfos scale orient =
  List.map (createTickInfo scale orient) (Scale.createTicks scale)

createTickInfo : Scale a b -> Orient -> Tick -> TickInfo
createTickInfo scale orient tick =
  let
    translation =
      if orient == Axis.Top || orient == Axis.Bottom then
          (tick.position, 0)
      else
          (0, tick.position)
  in
    { label = tick.label, translation = translation }
