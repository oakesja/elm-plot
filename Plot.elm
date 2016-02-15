module Plot where

import Html exposing (Html, text)
import Svg exposing (svg, circle, line, path)
import Svg.Attributes exposing (cx, cy, r, width, height, stroke, strokeWidth, d, fill)
import Line.InterpolationModes exposing (InterpolationMode)
import Scale

type alias Point = {x: Float, y: Float}
type alias Points = List Point
type alias Line = {points : Points, mode : InterpolationMode}
type alias Dimensions = {width: Float, height: Float}
type alias Scale = Float -> Float

type alias Plot =
  { dimensions: Dimensions
  , xScale : Scale
  , yScale : Scale
  , points: Points
  , lines: List Line
  -- , areas
  -- , scale
  }

createPlot : Float -> Float -> Plot
createPlot width height =
  { dimensions = {width = width, height = height}
  , xScale = Scale.identity
  , yScale = Scale.identity
  , points = []
  , lines = []
  }

addPoints : List Point -> Plot -> Plot
addPoints points plot =
  { plot | points = points }

addLines : InterpolationMode -> List Point -> Plot -> Plot
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

toHtml : Plot -> Html
toHtml p =
  let
    plot = rescale p
  in
    svg
      [ width (toString plot.dimensions.width)
      , height (toString plot.dimensions.height)
      ]
      (List.append (pointsToHmtl plot) (linesToHtml plot))

rescale : Plot -> Plot
rescale plot =
  let
    newLines = rescaleLines plot.xScale plot.yScale plot.lines
  in
    { plot | lines = newLines }

rescaleLines : Scale -> Scale -> List Line -> List Line
rescaleLines xScale yScale lines =
  List.map (rescaleLine xScale yScale) lines

rescaleLine : Scale -> Scale -> Line -> Line
rescaleLine xScale yScale line =
  let
    newPoints = List.map (rescalePoint xScale yScale) line.points
  in
    { line | points = newPoints }

rescalePoint : Scale -> Scale -> Point -> Point
rescalePoint xScale yScale point =
  { x = xScale point.x, y = yScale point.y }

pointsToHmtl : Plot -> List Html
pointsToHmtl plot =
  let
    createPoints = \point ->  createPointSvg plot.dimensions.width plot.dimensions.height point
  in
    List.map createPoints plot.points

createPointSvg : Float -> Float -> {x : Float, y : Float} -> Html
createPointSvg plotWidth plotHeight point =
  let
    x = toString point.x
    y = toString (plotHeight - point.y)
  in
    circle [cx x, cy y, r "5"] []

linesToHtml : Plot -> List Html
linesToHtml plot =
  List.map lineToHtml plot.lines

lineToHtml : Line -> Html
lineToHtml line =
  path
    [ d <| line.mode line.points
    , stroke "blue"
    , strokeWidth "2"
    , fill "none"
    ]
    []
