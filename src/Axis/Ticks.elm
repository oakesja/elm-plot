module Axis.Ticks where

import Scale exposing (Scale)
import Axis.Orient exposing (Orient)
import Axis.Model exposing (Axis)
import Svg exposing (Svg, path, text', g, line)
import Svg.Attributes exposing (d, fill, stroke, shapeRendering, x, y, transform, y2, x2, dy, textAnchor)
import Axis.Tick exposing (Tick)
import SvgAttributesExtras exposing (translate, rotate)

type alias TickInfo =
  { label : String
  , translation : (Float, Float)
  }

createTicks : Axis a -> List Svg
createTicks axis =
  List.map (createTick axis) (createTickInfos axis.scale axis.orient)

createTick : Axis a -> TickInfo -> Svg
createTick axis tickInfo =
  g
    [ translate tickInfo.translation ]
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
    xString = toString (fst pos)
    yString = toString (snd pos)
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
      posAttrs ++ anchorAttrs ++ [rotate pos rotation]

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
