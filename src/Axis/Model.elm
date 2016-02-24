module Axis.Model where

import Scale exposing (Scale)
import BoundingBox exposing (BoundingBox)
import Axis.Orient exposing (Orient)
import Svg

type alias Axis a =
  { scale : Scale a
  , orient : Orient
  , boundingBox : BoundingBox
  , innerTickSize : Int
  , outerTickSize : Int
  , tickPadding : Int
  , labelRotation : Int
  , axisStyle : List Svg.Attribute
  , innerTickStyle : List Svg.Attribute
  , title : Maybe String
  , titleOffset : Maybe Int
  , titleStyle : List Svg.Attribute
  }
