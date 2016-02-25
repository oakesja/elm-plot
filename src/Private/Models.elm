module Private.Models where

import Svg
import Axis.Orient exposing (Orient)

type alias Point a b = {x: a, y: b}
type alias PointValue = { value: Float, bandWidth: Float }
type alias PointWithBands = {x: PointValue, y: PointValue }
type alias Points a b = List (Point a b)
type alias Line a b = Points a b
type alias Interpolation = Points Float Float -> String
type alias AreaPoint a b = { x : a, y : b, y2 : b }
type alias Area a b = List (AreaPoint a b)
type alias Dimensions = {width: Float, height: Float}
type alias Margins = {top: Float, bottom: Float, right: Float, left: Float}
type alias Extent = { start : Float, stop : Float }

type alias BoundingBox =
  { xStart : Float
  , xEnd : Float
  , yStart : Float
  , yEnd : Float
  }

type alias Tick =
  { position : Float
  , label : String
  }

type alias TickInfo =
  { label : String
  , translation : (Float, Float)
  }
