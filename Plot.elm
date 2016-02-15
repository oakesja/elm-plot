module Plot where

import Html exposing (Html)
import Svg exposing (svg)
import Svg.Attributes exposing (width, height)
import Line.InterpolationModes exposing (InterpolationMode)
import SvgPoints exposing (SvgPoints)
import Points exposing (Points)
import Scale exposing (Scale)
import Line exposing (Line)
import Axis exposing (Axis)
import Area exposing (Area, AreaPoint)

type alias Dimensions = {width: Float, height: Float}

type alias Plot =
  { dimensions: Dimensions
  , xScale : Scale
  , yScale : Scale
  , points : List SvgPoints
  , lines : List Line
  , areas : List Area
  , xAxis : Maybe Axis
  , yAxis : Maybe Axis
  }

createPlot : Float -> Float -> Scale -> Scale -> Plot
createPlot width height xScale yScale=
  { dimensions = {width = width, height = height}
  , xScale = xScale
  , yScale = yScale
  , points = []
  , lines = []
  , areas = []
  , xAxis = Nothing
  , yAxis = Nothing
  }

addPoints : SvgPoints -> Plot -> Plot
addPoints points plot =
    { plot | points = points :: plot.points }

addLines : InterpolationMode -> Points -> Plot -> Plot
addLines mode points plot =
  let
    l = { points = points, mode = mode }
  in
    { plot | lines = l :: plot.lines }

addArea : InterpolationMode -> List AreaPoint -> Plot -> Plot
addArea mode points plot =
  let
    a = { points = points, mode = mode }
  in
    { plot | areas = a :: plot.areas }

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
      <| List.concat
        [ List.concat <| List.map SvgPoints.toHtml plot.points
        , List.map Line.toHtml plot.lines
        , List.map Area.toHtml plot.areas
        , Axis.toHtml plot.xScale plot.xAxis
        ]

rescale : Plot -> Plot
rescale plot =
  let
    newLines = List.map (Line.rescale plot.xScale plot.yScale) plot.lines
    newPoints = List.map (SvgPoints.rescale plot.xScale plot.yScale) plot.points
    newAreas = List.map (Area.rescale plot.xScale plot.yScale) plot.areas
  in
    { plot
    | lines = newLines
    , points = newPoints
    , areas = newAreas
    }
