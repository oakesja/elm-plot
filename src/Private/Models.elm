module Private.Models where

type alias Point a b = {x: a, y: b}
type alias PointValue a = { value: Float, width: Float, originalValue : a }
type alias InterpolatedPoint a b = {x: PointValue a, y: PointValue b}
type alias Points a b = List (Point a b)
type alias InterpolatedPoints a b = List (InterpolatedPoint a b)
type alias Line a b = Points a b
type alias InterpolatedLine a b = List (InterpolatedPoint a b)
type alias Interpolation = Points Float Float -> String
type alias AreaPoint a b = { x : a, y : b, y2 : b }
type alias Area a b = List (AreaPoint a b)
type alias Dimensions = {width: Float, height: Float}

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
