module Plot where

import Html exposing (Html)
import Svg exposing (svg, Svg)
import Svg.Attributes exposing (width, height)
import Line.Interpolation exposing (Interpolation)
import Points exposing (Points)
import Scale exposing (Scale)
import Line exposing (Line)
import Area exposing (Area)

type alias Dimensions = {width: Float, height: Float}

type alias Plot =
  { dimensions: Dimensions
  , html : List Html
  }

createPlot : Float -> Float -> Plot
createPlot width height =
  { dimensions = { width = width, height = height }
  , html = []
  }

addPoints : List a -> (a -> Float) -> (a -> Float) -> Scale -> Scale -> (Float -> Float -> Svg) -> Plot -> Plot
addPoints points getX getY xScale yScale pointToSvg plot =
  let
    newHtml =
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.rescale xScale yScale
        |> Points.toSvg pointToSvg
        |> List.append plot.html
  in
    { plot | html = newHtml }

addLines : List a ->  (a -> Float) -> (a -> Float) -> Scale -> Scale -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addLines points getX getY xScale yScale interpolate attrs plot =
  let
    line =
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.rescale xScale yScale
        |> Line.toSvg interpolate attrs
  in
    { plot | html = List.append plot.html [line] }


addArea : List a ->  (a -> Float) -> (a -> Float) -> (a -> Float) -> Scale -> Scale -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addArea points getX getY getY2 xScale yScale interpolate attrs plot =
  let
    area =
      List.map (\p -> { x = getX p, y = getY p, y2 = getY2 p }) points
        |> Area.rescale xScale yScale
        |> Area.toSvg interpolate attrs
  in
    { plot | html = List.append plot.html [area] }

toSvg : Plot -> Svg
toSvg plot =
  svg
    [ width (toString plot.dimensions.width)
    , height (toString plot.dimensions.height)
    ]
    plot.html
