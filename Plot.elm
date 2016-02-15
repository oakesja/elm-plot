module Plot where

import Html exposing (Html, text)
import Svg exposing (svg, circle, line, path)
import Svg.Attributes exposing (cx, cy, r, width, height, stroke, strokeWidth, d, fill)
import Line.InterpolationModes exposing (InterpolationMode)
import Points exposing (Points)
import Point
import Scale exposing (Scale)
import Line exposing (Line)

type alias Dimensions = {width: Float, height: Float}

-- axes
type Orientation = Top | Bottom | Left | Right
type alias Axis = {orient : Orientation, ticks : Int}

type alias Plot =
  { dimensions: Dimensions
  , xScale : Scale
  , yScale : Scale
  , points: Points
  , lines: List Line
  , xAxis : Maybe Axis
  , yAxis : Maybe Axis
  }

createPlot : Float -> Float -> Plot
createPlot width height =
  { dimensions = {width = width, height = height}
  , xScale = Scale.identity
  , yScale = Scale.identity
  , points = []
  , lines = []
  , xAxis = Nothing
  , yAxis = Nothing
  }

addPoints : Points -> Plot -> Plot
addPoints points plot =
  { plot | points = points }

addLines : InterpolationMode -> Points -> Plot -> Plot
addLines mode points plot =
  let
    l = { points = points, mode = mode }
  in
    { plot | lines = l :: plot.lines }

addXScale : Scale -> Plot -> Plot
addXScale scale plot =
  { plot | xScale = scale }

addYScale : Scale -> Plot -> Plot
addYScale scale plot =
  { plot | yScale = scale }

addXAxis : Axis -> Plot -> Plot
addXAxis axis plot =
  { plot | xAxis = Just axis }

addYAxis : Axis -> Plot -> Plot
addYAxis axis plot =
  { plot | xAxis = Just axis }

toHtml : Plot -> Html
toHtml p =
  let
    plot = rescale p
  in
    svg
      [ width (toString plot.dimensions.width)
      , height (toString plot.dimensions.height)
      ]
      (List.append (Points.toHtml plot.points) (List.map Line.toHtml plot.lines))

rescale : Plot -> Plot
rescale plot =
  let
    newLines = List.map (Line.rescale plot.xScale plot.yScale) plot.lines
    newPoints = List.map (Point.rescale plot.xScale plot.yScale) plot.points
  in
    { plot
    | lines = newLines
    , points = newPoints
    }
