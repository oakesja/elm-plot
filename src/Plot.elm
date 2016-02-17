module Plot where

import Html exposing (Html)
import Svg exposing (svg, Svg)
import Svg.Attributes exposing (width, height)
import Line.Interpolation exposing (Interpolation)
import Points exposing (Points)
import Scale exposing (Scale)
import Line exposing (Line)
-- import Axis exposing (Axis)
-- import Area exposing (Area, AreaPoint)

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

addLines : List a ->  (a -> Float) -> (a -> Float) -> Scale -> Scale -> Interpolation -> Plot -> Plot
addLines points getX getY xScale yScale interpolate plot =
  let
    line =
      List.map (\p -> { x = getX p, y = getY p }) points
        |> Points.rescale xScale yScale
        |> Line.toSvg interpolate
  in
    { plot | html = List.append plot.html [line] }

-- addArea : InterpolationMode -> List AreaPoint -> Plot -> Plot
-- addArea mode points plot =
--   let
--     a = { points = points, mode = mode }
--   in
--     { plot | areas = a :: plot.areas }
--
-- addXAxis : Axis -> Plot -> Plot
-- addXAxis axis plot =
--   { plot | xAxis = Just axis }
--
-- addYAxis : Axis -> Plot -> Plot
-- addYAxis axis plot =
--   { plot | xAxis = Just axis }

toSvg : Plot -> Svg
toSvg plot =
  svg
    [ width (toString plot.dimensions.width)
    , height (toString plot.dimensions.height)
    ]
    plot.html

  -- let
  --   plot = rescale p
  -- in
  --   svg
  --     [ width (toString plot.dimensions.width)
  --     , height (toString plot.dimensions.height)
  --     ]
  --     <| List.concat
  --       [ List.concat <| List.map SvgPoints.toHtml plot.points
  --       , List.map Line.toHtml plot.lines
  --       , List.map Area.toHtml plot.areas
  --       , Axis.toHtml plot.xScale plot.xAxis
  --       ]

-- rescale : Plot -> Plot
-- rescale plot =
--   let
--     newLines = List.map (Line.rescale plot.xScale plot.yScale) plot.lines
--     newPoints = List.map (SvgPoints.rescale plot.xScale plot.yScale) plot.points
--     newAreas = List.map (Area.rescale plot.xScale plot.yScale) plot.areas
--   in
--     { plot
--     | lines = newLines
--     , points = newPoints
--     , areas = newAreas
--     }
