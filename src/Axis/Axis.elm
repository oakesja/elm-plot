module Axis.Axis where

import Scale exposing (Scale)
import BoundingBox exposing (BoundingBox)
import Svg
import Axis.Orient exposing (Orient)

type alias Axis =
  { scale : Scale
  , orient : Orient
  , boundingBox : BoundingBox
  , numTicks : Int
  , innerTickSize : Int
  , outerTickSize : Int
  , axisStyle : List Svg.Attribute
  , innerTickStyle : List Svg.Attribute
  }
