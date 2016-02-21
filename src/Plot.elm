module Plot where

import Html exposing (Html)
import Svg exposing (svg, Svg)
import Svg.Attributes exposing (width, height)
import Line.Interpolation exposing (Interpolation)
import Points exposing (Points)
import Scale exposing (Scale)
import Line exposing (Line)
import Area exposing (Area)
import Axis.Axis exposing (Axis)
import Axis.Svg
import Axis.Orient
import Dimensions exposing (Dimensions, Margins)
import BoundingBox

type alias Plot =
  { dimensions: Dimensions
  , html : List Html
  , margins : Margins
  }

createPlot : Float -> Float -> Plot
createPlot width height =
  { dimensions = { width = width, height = height }
  , html = []
  , margins = {top = 10, bottom = 10, right = 10, left = 10}
  }

addPoints : List a -> (a -> Float) -> (a -> Float) -> Scale -> Scale -> (Float -> Float -> Svg) -> Plot -> Plot
addPoints points getX getY xScale yScale pointToSvg plot =
  let
    xScaleWithMargins = Scale.includeMargins plot.margins.left plot.margins.right xScale
    yScaleWithMargins = Scale.includeMargins -plot.margins.bottom -plot.margins.top yScale
    newHtml =
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.rescale xScaleWithMargins yScaleWithMargins
        |> Points.toSvg pointToSvg
        |> List.append plot.html
  in
    { plot | html = newHtml }

addLines : List a ->  (a -> Float) -> (a -> Float) -> Scale -> Scale -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addLines points getX getY xScale yScale interpolate attrs plot =
  let
    xScaleWithMargins = Scale.includeMargins plot.margins.left plot.margins.right xScale
    yScaleWithMargins = Scale.includeMargins -plot.margins.bottom -plot.margins.top yScale
    line =
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.rescale xScaleWithMargins yScaleWithMargins
        |> Line.toSvg interpolate attrs
  in
    { plot | html = List.append plot.html [line] }


addArea : List a ->  (a -> Float) -> (a -> Float) -> (a -> Float) -> Scale -> Scale -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addArea points getX getY getY2 xScale yScale interpolate attrs plot =
  let
    xScaleWithMargins = Scale.includeMargins plot.margins.left plot.margins.right xScale
    yScaleWithMargins = Scale.includeMargins -plot.margins.bottom -plot.margins.top yScale
    area =
      List.map (\p -> { x = getX p, y = getY p, y2 = getY2 p }) points
        |> Area.rescale xScaleWithMargins yScaleWithMargins
        |> Area.toSvg interpolate attrs
  in
    { plot | html = List.append plot.html [area] }

addAxis : Axis -> Plot -> Plot
addAxis axis plot =
  let
    scale = case axis.orient of
      Axis.Orient.Top ->
        Scale.includeMargins plot.margins.left plot.margins.right axis.scale
      Axis.Orient.Bottom ->
        Scale.includeMargins plot.margins.left plot.margins.right axis.scale
      Axis.Orient.Left ->
        Scale.includeMargins -plot.margins.bottom -plot.margins.top axis.scale
      Axis.Orient.Right ->
        Scale.includeMargins -plot.margins.bottom -plot.margins.top axis.scale
    a = { axis
        | scale = scale
        , boundingBox = BoundingBox.from plot.dimensions plot.margins
        }
  in
    { plot | html = List.append plot.html [Axis.Svg.toSvg a] }

toSvg : Plot -> Svg
toSvg plot =
  svg
    [ width (toString plot.dimensions.width)
    , height (toString plot.dimensions.height)
    ]
    plot.html
