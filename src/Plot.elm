module Plot where

import Svg exposing (svg, Svg)
import Svg.Attributes exposing (width, height)
import Private.Models exposing (..)
import Bars
import Scale
import Points
import Area
import Line
import Axis.Axis
import Axis.Orient
import BoundingBox

type alias Plot =
  { dimensions: Dimensions
  , html : List Svg
  , margins : Margins
  }

createPlot : Float -> Float -> Plot
createPlot width height =
  { dimensions = { width = width, height = height }
  , html = []
  , margins = {top = 70, bottom = 70, right = 70, left = 70}
  }

addPoints : List a -> (a -> b) -> (a -> c) -> Scale b -> Scale c -> (Float -> Float -> Svg) -> Plot -> Plot
addPoints points getX getY xScale yScale pointToSvg plot =
  let
    xScaleWithMargins = Scale.includeMargins plot.margins.left plot.margins.right xScale
    yScaleWithMargins = Scale.includeMargins -plot.margins.bottom -plot.margins.top yScale
    newHtml =
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.transform xScaleWithMargins yScaleWithMargins
        |> Points.toSvg pointToSvg
        |> List.append plot.html
  in
    { plot | html = newHtml }

addLines : List a ->  (a -> b) -> (a -> c) -> Scale b -> Scale c -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addLines points getX getY xScale yScale interpolate attrs plot =
  let
    xScaleWithMargins = Scale.includeMargins plot.margins.left plot.margins.right xScale
    yScaleWithMargins = Scale.includeMargins -plot.margins.bottom -plot.margins.top yScale
    line =
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Line.transform xScaleWithMargins yScaleWithMargins
        |> Line.toSvg interpolate attrs
  in
    { plot | html = List.append plot.html [line] }

addArea : List a ->  (a -> b) -> (a -> c) -> (a -> c) -> Scale b -> Scale c -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addArea points getX getY getY2 xScale yScale interpolate attrs plot =
  let
    xScaleWithMargins = Scale.includeMargins plot.margins.left plot.margins.right xScale
    yScaleWithMargins = Scale.includeMargins -plot.margins.bottom -plot.margins.top yScale
    area =
      List.map (\p -> { x = getX p, y = getY p, y2 = getY2 p }) points
        |> Area.transform xScaleWithMargins yScaleWithMargins
        |> Area.toSvg interpolate attrs
  in
    { plot | html = List.append plot.html [area] }

addAxis : Axis a -> Plot -> Plot
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
    { plot | html = List.append plot.html [Axis.Axis.toSvg a] }

addBars : List a -> (a -> b) -> (a -> c) -> Scale b -> Scale c -> Bars.Orient -> List Svg.Attribute -> Plot -> Plot
addBars points getX getY xScale yScale orient attrs plot =
  let
    xScaleWithMargins = Scale.includeMargins plot.margins.left plot.margins.right xScale
    yScaleWithMargins = Scale.includeMargins -plot.margins.bottom -plot.margins.top yScale
    newHtml =
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.transform xScaleWithMargins yScaleWithMargins
        |> Bars.toSvg (BoundingBox.from plot.dimensions plot.margins) orient attrs
        |> List.append plot.html
  in
    { plot | html = newHtml }

toSvg : Plot -> Svg
toSvg plot =
  svg
    [ width (toString plot.dimensions.width)
    , height (toString plot.dimensions.height)
    ]
    plot.html
