module Plot where

import Svg exposing (svg, Svg, g)
import Svg.Attributes exposing (width, height, x, y)
import Private.Models exposing (Dimensions, Interpolation, BoundingBox)
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
import Scale.Type
import SvgAttributesExtras exposing (translate)

type alias MouseInfo = { clientX: Float, clientY: Float }
type alias MouseEvent a b = { x: a, y: b }

type alias Margins =
  { top: Float
  , bottom: Float
  , right: Float
  , left: Float
  }

type alias Plot =
  { dimensions: Dimensions
  , margins: Margins
  , points: List (BoundingBox -> List Svg)
  , marks: List (BoundingBox -> List Svg)
  , axes: List (BoundingBox -> Svg)
  , eventHandlers: List (BoundingBox -> Svg.Attribute)
  , attrs: List Svg.Attribute
  }

createPlot : Float -> Float -> Plot
createPlot w h =
  { dimensions = { width = w, height = h }
  , margins = { top = 50, bottom = 50, right = 50, left = 50 }
  , points = []
  , marks = []
  , axes = []
  , eventHandlers = []
  , attrs = [width (toString w), height (toString h)]
  }

attributes : List Svg.Attribute -> Plot -> Plot
attributes attrs plot =
  { plot | attrs = plot.attrs ++ attrs }

margins : Margins -> Plot -> Plot
margins m plot =
  { plot | margins = m }

addPoints : List a -> (a -> b) -> (a -> c) -> Scale x b -> Scale y c -> (Float -> Float -> Svg) -> Plot -> Plot
addPoints points getX getY xScale yScale pointToSvg plot =
  let
    svg = \bBox ->
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.interpolate (rescaleX bBox xScale) (rescaleY bBox yScale)
        |> Points.toSvg pointToSvg
  in
    { plot | points = List.append plot.points [svg] }

addLines : List a ->  (a -> b) -> (a -> c) -> Scale x b -> Scale y c -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addLines points getX getY xScale yScale interpolate attrs plot =
  let
    svg = \bBox ->
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Line.interpolate (rescaleX bBox xScale) (rescaleY bBox yScale)
        |> Line.toSvg interpolate attrs
        |> toList
  in
    addSvg svg plot

addArea : List a ->  (a -> b) -> (a -> c) -> (a -> c) -> Scale x b -> Scale y c -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addArea points getX getY getY2 xScale yScale interpolate attrs plot =
  let
    svg = \bBox ->
      List.map (\p -> { x = getX p, y = getY p, y2 = getY2 p }) points
        |> Area.interpolate (rescaleX bBox xScale) (rescaleY bBox yScale)
        |> Area.toSvg interpolate attrs
        |> toList
  in
    addSvg svg plot

addBars : List a -> (a -> b) -> (a -> c) -> Scale x b -> Scale y c -> Bars.Orient -> List Svg.Attribute -> Plot -> Plot
addBars points getX getY xScale yScale orient attrs plot =
  let
    svg = \bBox ->
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.interpolate (rescaleX bBox xScale) (rescaleY bBox yScale)
        |> Bars.toSvg bBox orient attrs
  in
    addSvg svg plot

addAxis : Axis a b -> Plot -> Plot
addAxis axis plot =
  let
    svg = \bBox ->
      let
        scale =
          if axis.orient == Axis.Orient.Top || axis.orient == Axis.Orient.Bottom then
            rescaleX bBox axis.scale
          else
            rescaleY bBox axis.scale
        a = { axis
              | scale = scale
              , boundingBox = bBox
            }
      in
        Axis.View.toSvg a
  in
    { plot | axes = List.append plot.axes [svg] }

onClick : Scale a b -> Scale d c -> (MouseEvent b c -> Signal.Message) -> Plot -> Plot
onClick xScale yScale createMessage plot =
  let
    handler = \bBox ->
        on "click" clickDecoder
          <| \event -> createMessage
              { x = Scale.uninterpolate (rescaleX bBox xScale) event.clientX
              , y = Scale.uninterpolate (rescaleY bBox yScale) event.clientY
              }
  in
    { plot | eventHandlers =  handler :: plot.eventHandlers }


toSvg : Plot -> Svg
toSvg plot =
  let
    bBox = BoundingBox.from plot.dimensions plot.margins
    axes = List.map (\s -> s bBox) plot.axes
    marks = createMarks bBox plot.marks
    events = List.map (\s -> s bBox) plot.eventHandlers
    points = List.concat (List.map (\s -> s bBox) plot.points)
  in
    svg (plot.attrs ++ events) (axes ++ [marks] ++ points)

createMarks : BoundingBox -> List (BoundingBox -> List Svg) -> Svg
createMarks bBox marks =
  let
    adjustedMarks = List.concat (List.map (\s -> s bBox) marks)
  in
    svg
      [
      width (toString (bBox.xEnd - bBox.xStart))
      , height (toString (bBox.yEnd - bBox.yStart))
      -- , x (toString bBox.xStart)
      -- , y (toString bBox.yStart)
      ]
      adjustedMarks

-- private
rescaleX : BoundingBox -> Scale a b -> Scale a b
rescaleX bBox scale =
  Scale.rescale bBox Scale.Type.XScale scale

rescaleY : BoundingBox -> Scale a b -> Scale a b
rescaleY bBox scale =
  Scale.rescale bBox Scale.Type.YScale scale

addSvg : (BoundingBox -> List Svg) -> Plot -> Plot
addSvg svg plot =
  { plot | marks = List.append plot.marks [svg] }

clickDecoder : Decoder MouseInfo
clickDecoder =
  object2 MouseInfo
    ("clientX" := float)
    ("clientY" := float)
