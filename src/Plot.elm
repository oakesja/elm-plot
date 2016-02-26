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
import ListExtra exposing (toList)

type alias Plot =
  { dimensions: Dimensions
  , svgs : List (Margins -> List Svg)
  , margins : Margins
  , attrs : List Svg.Attribute
  }

-- TODO clean up

createPlot : Float -> Float -> Plot
createPlot width height =
  { dimensions = { width = width, height = height }
  , svgs = []
  , margins = {top = 50, bottom = 50, right = 50, left = 50}
  , attrs = []
  }

addPoints : List a -> (a -> b) -> (a -> c) -> Scale x b -> Scale y c -> (Float -> Float -> Svg) -> Plot -> Plot
addPoints points getX getY xScale yScale pointToSvg plot =
  let
    svg = \margins ->
      let
        xScaleWithMargins = Scale.includeMargins margins.left margins.right xScale
        yScaleWithMargins = Scale.includeMargins -margins.bottom -margins.top yScale
      in
        List.map (\p -> { x = getX p, y = getY p }) points
          |> Points.interpolate xScaleWithMargins yScaleWithMargins
          |> Points.toSvg pointToSvg
  in
    { plot | svgs = (List.append plot.svgs [svg]) }

addLines : List a ->  (a -> b) -> (a -> c) -> Scale x b -> Scale y c -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addLines points getX getY xScale yScale interpolate attrs plot =
  let
    svg = \margins ->
      let
        xScaleWithMargins = Scale.includeMargins margins.left margins.right xScale
        yScaleWithMargins = Scale.includeMargins -margins.bottom -margins.top yScale
      in
        List.map (\p -> { x = getX p, y = getY p }) points
          |> Line.interpolate xScaleWithMargins yScaleWithMargins
          |> Line.toSvg interpolate attrs
          |> toList
  in
    { plot | svgs = (List.append plot.svgs [svg]) }

addArea : List a ->  (a -> b) -> (a -> c) -> (a -> c) -> Scale x b -> Scale y c -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addArea points getX getY getY2 xScale yScale interpolate attrs plot =
  let
    svg = \margins ->
      let
        xScaleWithMargins = Scale.includeMargins margins.left margins.right xScale
        yScaleWithMargins = Scale.includeMargins -margins.bottom -margins.top yScale
      in
        List.map (\p -> { x = getX p, y = getY p, y2 = getY2 p }) points
          |> Area.interpolate xScaleWithMargins yScaleWithMargins
          |> Area.toSvg interpolate attrs
          |> toList
  in
    { plot | svgs = (List.append plot.svgs [svg]) }

addAxis : Axis a b -> Plot -> Plot
addAxis axis plot =
  let
    svg = \margins ->
      let
        scale = case axis.orient of
          Axis.Orient.Top ->
            Scale.includeMargins margins.left margins.right axis.scale
          Axis.Orient.Bottom ->
            Scale.includeMargins margins.left margins.right axis.scale
          Axis.Orient.Left ->
            Scale.includeMargins -margins.bottom -margins.top axis.scale
          Axis.Orient.Right ->
            Scale.includeMargins -margins.bottom -margins.top axis.scale
        a = { axis
            | scale = scale
            , boundingBox = BoundingBox.from plot.dimensions margins
            }
        in
          [Axis.View.toSvg a]
  in
    { plot | svgs = (List.append plot.svgs [svg]) }

addBars : List a -> (a -> b) -> (a -> c) -> Scale x b -> Scale y c -> Bars.Orient -> List Svg.Attribute -> Plot -> Plot
addBars points getX getY xScale yScale orient attrs plot =
  let
    svg = \margins ->
      let
        xScaleWithMargins = Scale.includeMargins margins.left margins.right xScale
        yScaleWithMargins = Scale.includeMargins -margins.bottom -margins.top yScale
      in
        List.map (\p -> { x = getX p, y = getY p }) points
          |> Points.interpolate xScaleWithMargins yScaleWithMargins
          |> Bars.toSvg (BoundingBox.from plot.dimensions plot.margins) orient attrs
  in
    { plot | svgs = (List.append plot.svgs [svg]) }

type alias MouseInfo = { clientX: Float, clientY: Float }
type alias MouseEvent a b = { x: a, y: b }

registerOnClick : Scale a b -> Scale d c -> (MouseEvent b c -> Signal.Message) -> Plot -> Plot
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

margins : Margins -> Plot -> Plot
margins m plot =
  { plot | margins = m }

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
      (List.concat <| List.map (\s -> s plot.margins) plot.svgs)
