module Axis.Axis where

import Axis.Orient exposing (Orient)
import Svg
import Scale.Scale exposing (Scale)
import Private.Models exposing (BoundingBox)

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
