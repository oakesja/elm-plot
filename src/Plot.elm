module Plot where

import Svg exposing (svg, Svg)
import Svg.Attributes exposing (width, height)
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

type alias Margins =
  { top: Float
  , bottom: Float
  , right: Float
  , left: Float
  }

type alias Plot =
  { dimensions: Dimensions
  , margins: Margins
  , svgs: List (BoundingBox -> List Svg)
  , attrs: List Svg.Attribute
  }

createPlot : Float -> Float -> Plot
createPlot w h =
  { dimensions = { width = w, height = h }
  , margins = { top = 50, bottom = 50, right = 50, left = 50 }
  , svgs = []
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
        |> Points.interpolate (rescaleX bBox xScale) (rescaleX bBox yScale)
        |> Points.toSvg pointToSvg
  in
    addSvg svg plot

addLines : List a ->  (a -> b) -> (a -> c) -> Scale x b -> Scale y c -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addLines points getX getY xScale yScale interpolate attrs plot =
  let
    svg = \bBox ->
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Line.interpolate (rescaleX bBox xScale) (rescaleX bBox yScale)
        |> Line.toSvg interpolate attrs
        |> toList
  in
    addSvg svg plot

addArea : List a ->  (a -> b) -> (a -> c) -> (a -> c) -> Scale x b -> Scale y c -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addArea points getX getY getY2 xScale yScale interpolate attrs plot =
  let
    svg = \bBox ->
      List.map (\p -> { x = getX p, y = getY p, y2 = getY2 p }) points
        |> Area.interpolate (rescaleX bBox xScale) (rescaleX bBox yScale)
        |> Area.toSvg interpolate attrs
        |> toList
  in
    addSvg svg plot

addBars : List a -> (a -> b) -> (a -> c) -> Scale x b -> Scale y c -> Bars.Orient -> List Svg.Attribute -> Plot -> Plot
addBars points getX getY xScale yScale orient attrs plot =
  let
    svg = \bBox ->
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.interpolate (rescaleX bBox xScale) (rescaleX bBox yScale)
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
            Scale.rescale bBox Scale.Type.XScale axis.scale
          else
            Scale.rescale bBox Scale.Type.YScale axis.scale
        a = { axis
              | scale = scale
              , boundingBox = bBox
            }
      in
        [Axis.View.toSvg a]
  in
    addSvg svg plot

toSvg : Plot -> Svg
toSvg plot =
  let
    bBox = BoundingBox.from plot.dimensions plot.margins
    svgs = List.concat (List.map (\s -> s bBox) plot.svgs)
  in
    svg plot.attrs svgs

-- TODO cleanup
-- type alias MouseInfo = { clientX: Float, clientY: Float }
-- type alias MouseEvent a b = { x: a, y: b }
--
-- registerOnClick : Scale a b -> Scale d c -> (MouseEvent b c -> Signal.Message) -> Plot -> Plot
-- registerOnClick xScale yScale createMessage plot =
--   let
--     xScale' = Scale.includeMargins plot.margins.left plot.margins.right xScale
--     yScale' = Scale.includeMargins -plot.margins.bottom -plot.margins.top yScale
--     handler = (\event -> createMessage
--       { x = Scale.uninterpolate xScale' event.clientX
--       , y = Scale.uninterpolate yScale' event.clientY
--       })
--   in
--     { plot | attrs = (on "click" clickDecoder handler) :: plot.attrs }
--
-- clickDecoder : Decoder MouseInfo
-- clickDecoder =
--   object2 MouseInfo
--     ("clientX" := float)
--     ("clientY" := float)

-- private
rescaleX : BoundingBox -> Scale a b -> Scale a b
rescaleX bBox scale =
  Scale.rescale bBox Scale.Type.XScale scale

rescaleY : BoundingBox -> Scale a b -> Scale a b
rescaleY bBox scale =
  Scale.rescale bBox Scale.Type.YScale scale

addSvg : (BoundingBox -> List Svg) -> Plot -> Plot
addSvg svg plot =
  { plot | svgs = List.append plot.svgs [svg] }
