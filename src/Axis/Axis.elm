module Axis.Axis where

import Scale exposing (Scale)
import BoundingBox exposing (BoundingBox)
import Svg
import Axis.Orient exposing (Orient)

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
  }
