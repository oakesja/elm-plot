module Axis where

import Axis.Axis exposing (Axis)
import Scale.Scale exposing (Scale)
import Axis.Orient exposing (Orient)
import Svg
import Svg.Attributes exposing (fill, stroke, shapeRendering)

createAxis : Scale a b -> Orient -> Axis a b
createAxis scale orient =
  { scale = scale
  , orient = orient
  , boundingBox = { xStart = 0, xEnd = 0, yStart = 0, yEnd = 0 }
  , innerTickSize = 6
  , outerTickSize = 6
  , tickPadding = 3
  , labelRotation = 0
  , axisAttributes = [ fill "none", stroke "#000", shapeRendering "crispEdges" ]
  , innerTickAttributes = [ fill "none", stroke "#000", shapeRendering "crispEdges" ]
  , title = Nothing
  , titleOffset = Nothing
  , titleAttributes = []
  }

innerTickSize : Int -> Axis a b -> Axis a b
innerTickSize size axis =
  { axis | innerTickSize = size }

outerTickSize : Int -> Axis a b -> Axis a b
outerTickSize size axis =
  { axis | outerTickSize = size }

tickPadding : Int -> Axis a b -> Axis a b
tickPadding padding axis =
  { axis | tickPadding = padding }

labelRotation : Int -> Axis a b -> Axis a b
labelRotation rotation axis =
  { axis | labelRotation = rotation }

axisAttributes : List Svg.Attribute -> Axis a b -> Axis a b
axisAttributes attrs axis =
  { axis | axisAttributes = attrs }

innerTickAttributes : List Svg.Attribute -> Axis a b -> Axis a b
innerTickAttributes attrs axis =
  { axis | innerTickAttributes = attrs }

title : String -> Axis a b -> Axis a b
title t axis =
  { axis | title  = Just t }

titleOffset : Int -> Axis a b -> Axis a b
titleOffset offset axis =
  { axis | titleOffset  = Just offset }

titleAttributes : List Svg.Attribute -> Axis a b -> Axis a b
titleAttributes attrs axis =
  { axis | titleAttributes  = attrs }
