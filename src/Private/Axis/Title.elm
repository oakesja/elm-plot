module Private.Axis.Title where

import Svg exposing (Svg, text, text')
import Svg.Attributes exposing (textAnchor)
import Plot.Axis as Axis exposing (Orient)
import Private.Extras.Set exposing (Extent)
import Private.Extras.SvgAttributes exposing (rotate, x, y)

createTitle : Extent -> Orient -> Int -> Int -> List Svg.Attribute -> Maybe Int ->  Maybe String -> List Svg
createTitle extent orient innerTickSize tickPadding attrs offset title =
  case title of
    Just s ->
      [titleSvg extent orient innerTickSize tickPadding attrs offset s]
    Nothing ->
      []

titleSvg : Extent -> Orient -> Int -> Int -> List Svg.Attribute -> Maybe Int -> String -> Svg
titleSvg extent orient innerTickSize tickPadding attrs offset title =
  text'
    (titleAttrs extent orient innerTickSize tickPadding attrs offset)
    [text title]

titleAttrs : Extent -> Orient -> Int -> Int -> List Svg.Attribute -> Maybe Int -> List Svg.Attribute
titleAttrs extent orient innerTickSize tickPadding attrs offset =
  let
    middle = ((extent.end - extent.start) / 2) + extent.start
    sign = if orient == Axis.Top || orient == Axis.Left then -1 else 1
    calOffset = case offset of
      Just o ->
        sign * o
      Nothing ->
        sign * (innerTickSize + tickPadding + 30)
    posAttrs =
      if orient == Axis.Top || orient == Axis.Bottom then
        [x middle, y calOffset]
      else
        [x calOffset, y middle, rotate (calOffset, middle) (sign * 90) ]
  in
    (textAnchor "middle") :: posAttrs ++ attrs
