module Plot where

import Svg exposing (svg, Svg)
import Svg.Attributes exposing (width, height)
import Private.Models exposing (..)
import Scale.Scale exposing (Scale)
import Axis.Axis exposing (Axis)
import Bars
import Scale
import Points
import Area
import Line
import Axis.View
import Axis.Orient
import BoundingBox
import Html.Events exposing (on)
import Json.Decode exposing (object2, (:=), float, Decoder)

type alias Plot =
  { dimensions: Dimensions
  , html : List Svg
  , margins : Margins
  , attrs : List Svg.Attribute
  }

type Action = ClickEvent Float Float

-- TODO clean up

createPlot : Float -> Float -> Plot
createPlot width height =
  { dimensions = { width = width, height = height }
  , html = []
  , margins = {top = 70, bottom = 70, right = 70, left = 70}
  , attrs = []
  }

addPoints : List a -> (a -> b) -> (a -> c) -> Scale b -> Scale c -> (Float -> Float -> Svg) -> Plot -> Plot
addPoints points getX getY xScale yScale pointToSvg plot =
  let
    xScaleWithMargins = Scale.includeMargins plot.margins.left plot.margins.right xScale
    yScaleWithMargins = Scale.includeMargins -plot.margins.bottom -plot.margins.top yScale
    newHtml =
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.interpolate xScaleWithMargins yScaleWithMargins
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
        |> Line.interpolate xScaleWithMargins yScaleWithMargins
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
        |> Area.interpolate xScaleWithMargins yScaleWithMargins
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
    { plot | html = List.append plot.html [Axis.View.toSvg a] }

addBars : List a -> (a -> b) -> (a -> c) -> Scale b -> Scale c -> Bars.Orient -> List Svg.Attribute -> Plot -> Plot
addBars points getX getY xScale yScale orient attrs plot =
  let
    xScaleWithMargins = Scale.includeMargins plot.margins.left plot.margins.right xScale
    yScaleWithMargins = Scale.includeMargins -plot.margins.bottom -plot.margins.top yScale
    newHtml =
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.interpolate xScaleWithMargins yScaleWithMargins
        |> Bars.toSvg (BoundingBox.from plot.dimensions plot.margins) orient attrs
        |> List.append plot.html
  in
    { plot | html = newHtml }

type alias MouseInfo = { clientX: Float, clientY: Float }
type alias MouseEvent a b = { x: a, y: b }

registerOnClick : Scale b -> Scale c -> (MouseEvent b c -> Signal.Message) -> Plot -> Plot
registerOnClick xScale yScale createMessage plot =
  let
    xScale' = Scale.includeMargins plot.margins.left plot.margins.right xScale
    yScale' = Scale.includeMargins -plot.margins.bottom -plot.margins.top yScale
    handler = (\event -> createMessage
      { x = Scale.uninterpolate xScale' event.clientX
      , y = Scale.uninterpolate yScale' event.clientY
      })
  in
    { plot | attrs = (on "click" clickDecoder handler) :: plot.attrs }

additionalAttributes : List Svg.Attribute -> Plot -> Plot
additionalAttributes attrs plot =
  { plot | attrs = plot.attrs ++ attrs }

clickDecoder : Decoder MouseInfo
clickDecoder =
  object2 MouseInfo
    ("clientX" := float)
    ("clientY" := float)

toSvg : Plot -> Svg
toSvg plot =
  let
    posAttrs =
      [ width (toString plot.dimensions.width)
      , height (toString plot.dimensions.height)
      ]
  in
    svg
      (plot.attrs ++ posAttrs)
      plot.html
