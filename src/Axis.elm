module Axis where

import Axis.Orient exposing (Orient)
import Scale.Scale exposing (Scale)
import Svg
import Svg.Attributes exposing (fill, stroke, shapeRendering)
import BoundingBox exposing (BoundingBox)

type alias Axis a b =
  { scale : Scale a b
  , orient : Orient
  , boundingBox : BoundingBox
  , innerTickSize : Int
  , outerTickSize : Int
  , tickPadding : Int
  , labelRotation : Int
  , axisAttributes : List Svg.Attribute
  , innerTickAttributes : List Svg.Attribute
  , title : Maybe String
  , titleOffset : Maybe Int
  , titleAttributes : List Svg.Attribute
  }

create : Scale a b -> Orient -> Axis a b
create scale orient =
  let
    defaultLineAttrs =
      [ fill "none"
      , stroke "#000"
      , shapeRendering "crispEdges"
      ]
  in
  { scale = scale
  , orient = orient
  , boundingBox = BoundingBox.init
  , innerTickSize = 6
  , outerTickSize = 6
  , tickPadding = 3
  , labelRotation = 0
  , axisAttributes = defaultLineAttrs
  , innerTickAttributes = defaultLineAttrs
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
