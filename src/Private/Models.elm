module Private.Models where

import Svg
import Axis.Orient exposing (Orient)

type alias Point a b = {x: a, y: b}
type alias PointValue = { value: Float, bandWidth: Float }
type alias TransformedPoint = {x: PointValue, y: PointValue }
type alias Points a b = List (Point a b)
type alias TransformedPoints = List TransformedPoint
type alias Line a b = Points a b
type alias Interpolation = TransformedPoints -> String
type alias AreaPoint a b = { x : a, y : b, y2 : b }
type alias TransformedAreaPoint = { x : PointValue, y : PointValue, y2 : PointValue }
type alias Area a b = List (AreaPoint a b)
type alias TransformedArea = List TransformedAreaPoint
type alias Dimensions = {width: Float, height: Float}
type alias Margins = {top: Float, bottom: Float, right: Float, left: Float}
type alias Extent = { start : Float, stop : Float }

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

type alias BoundingBox =
  { xStart : Float
  , xEnd : Float
  , yStart : Float
  , yEnd : Float
  }

type alias Scale a =
  { range : (Float, Float)
  , transform : ((Float, Float) -> a -> PointValue)
  , createTicks : ((Float, Float) -> List Tick)
  }

type alias Tick =
  { position : Float
  , label : String
  }

type alias TickInfo =
  { label : String
  , translation : (Float, Float)
  }
