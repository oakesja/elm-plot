module Plot where

import Svg exposing (svg, Svg)
import Private.Extras.SvgAttributes exposing (width, height)
import Private.Dimensions exposing (Dimensions)
import Private.Margins as Margins exposing (Margins)
import Plot.Interpolation exposing (Interpolation)
import Private.BoundingBox as BoundingBox exposing (BoundingBox)
import Plot.Scale as Scale
import Private.Scale exposing (Scale)
import Plot.Axis as Axis exposing (Axis)
import Private.Bars as Bars exposing (Orient)
import Private.Points as Points
import Private.Area as Area
import Private.Path as Path
import Private.Axis.View as AxisView
import Private.Extras.List exposing (toList)
import Private.Rules as Rules
import Private.Title as Title
import Plot.Events exposing (MouseEvent)

type alias Plot =
  { dimensions: Dimensions
  , margins: Margins
  , svgs: List (BoundingBox -> List Svg)
  , eventHandlers: List (BoundingBox -> Svg.Attribute)
  , attrs: List Svg.Attribute
  , title : Title.Model
  }

createPlot : Float -> Float -> Plot
createPlot w h =
  { dimensions = { width = w, height = h }
  , margins = Margins.init
  , svgs = []
  , eventHandlers = []
  , attrs = [width w, height h]
  , title = Title.init
  }

addTitle : String -> List Svg.Attribute -> Plot -> Plot
addTitle title attrs plot =
  { plot | title = Title.create title attrs }

attributes : List Svg.Attribute -> Plot -> Plot
attributes attrs plot =
  { plot | attrs = plot.attrs ++ attrs }

margins : Margins -> Plot -> Plot
margins m plot =
  { plot | margins = m }

-- TODO remove duplication of (Scale.rescaleX bBox xScale) (Scale.rescaleY bBox yScale)
addPoints : List a -> (a -> b) -> (a -> c) -> Scale x b -> Scale y c -> (Float -> Float -> b -> c -> Svg) -> Plot -> Plot
addPoints points getX getY xScale yScale pointToSvg plot =
  let
    svg = \bBox ->
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.interpolate (Scale.rescaleX bBox xScale) (Scale.rescaleY bBox yScale)
        |> Points.toSvg pointToSvg
  in
    addSvg svg plot

-- TODO Element.interpolate and interpolation method is confusioning
addLines : List a ->  (a -> b) -> (a -> c) -> Scale x b -> Scale y c -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addLines points getX getY xScale yScale intMethod attrs plot =
  let
    svg = \bBox ->
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Path.interpolate bBox (Scale.rescaleX bBox xScale) (Scale.rescaleY bBox yScale)
        |> Path.toSvg intMethod attrs
        |> toList
  in
    addSvg svg plot

addArea : List a ->  (a -> b) -> (a -> c) -> (a -> c) -> Scale x b -> Scale y c -> Interpolation -> List Svg.Attribute -> Plot -> Plot
addArea points getX getY getY2 xScale yScale intMethod attrs plot =
  let
    svg = \bBox ->
      List.map (\p -> { x = getX p, y = getY p, y2 = getY2 p }) points
        |> Area.interpolate bBox (Scale.rescaleX bBox xScale) (Scale.rescaleY bBox yScale)
        |> Area.toSvg intMethod attrs
        |> toList
  in
    addSvg svg plot

-- TODO cleanup add bars
addVerticalBars : List a -> (a -> b) -> (a -> c) -> Scale x b -> Scale y c -> List Svg.Attribute -> Plot -> Plot
addVerticalBars points getX getY xScale yScale attrs plot =
  let
    svg = \bBox ->
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.interpolate (Scale.rescaleX bBox xScale) (Scale.rescaleY bBox yScale)
        |> Bars.toSvg bBox Bars.Vertical attrs
  in
    addSvg svg plot

-- TODO consider doing add vertical and add horizontal bars
addHorizontalBars : List a -> (a -> b) -> (a -> c) -> Scale x b -> Scale y c -> List Svg.Attribute -> Plot -> Plot
addHorizontalBars points getX getY xScale yScale attrs plot =
  let
    svg = \bBox ->
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.interpolate (Scale.rescaleX bBox xScale) (Scale.rescaleY bBox yScale)
        |> Bars.toSvg bBox Bars.Horizontal attrs
  in
    addSvg svg plot

addAxis : Axis a b -> Plot -> Plot
addAxis axis plot =
  let
    svg = \bBox ->
      let
        scale =
          if axis.orient == Axis.Top || axis.orient == Axis.Bottom then
            Scale.rescaleX bBox axis.scale
          else
            Scale.rescaleY bBox axis.scale
        a = { axis
              | scale = scale
              , boundingBox = bBox
            }
      in
        [AxisView.toSvg a]
  in
    addSvg svg plot

addVerticalRules : List a -> Scale x a -> List Svg.Attribute -> Plot -> Plot
addVerticalRules vals scale attrs plot =
  addRule vals scale attrs Rules.Vertical Scale.rescaleX plot

addHorizontalRules : List a -> Scale x a -> List Svg.Attribute -> Plot -> Plot
addHorizontalRules vals scale attrs plot =
  addRule vals scale attrs Rules.Horizontal Scale.rescaleY plot

-- TODO look into an abstract addEvent function
onClick : Scale a b -> Scale d c -> (MouseEvent b c -> Signal.Message) -> Plot -> Plot
onClick xScale yScale createMessage plot =
  let
    handler = \bBox -> Plot.Events.onClick xScale yScale createMessage bBox
  in
    { plot | eventHandlers =  handler :: plot.eventHandlers }

toSvg : Plot -> Svg
toSvg plot =
  let
    bBox = BoundingBox.from plot.dimensions plot.margins
    plotElements = List.concat (List.map (\s -> s bBox) plot.svgs)
    events = List.map (\s -> s bBox) plot.eventHandlers
    svgs =
      if Title.isEmpty plot.title then
        plotElements
      else
        plotElements ++ [Title.toSvg plot.title bBox]
  in
    svg (plot.attrs ++ events) (svgs)

addRule : List a -> Scale x a -> List Svg.Attribute -> Rules.Direction -> (BoundingBox -> Scale x a -> Scale x a) -> Plot -> Plot
addRule vals scale attrs direction rescale plot =
  let
    svg = \bBox ->
      Rules.interpolate vals (rescale bBox scale)
        |> Rules.toSvg bBox attrs direction
  in
    addSvg svg plot

addSvg : (BoundingBox -> List Svg) -> Plot -> Plot
addSvg svg plot =
  { plot | svgs = List.append plot.svgs [svg] }
