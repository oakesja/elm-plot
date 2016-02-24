module Ordinal where

import Svg exposing (Svg)
import Plot exposing (..)
import Scale
import Axis
import Axis.Orient
import Bars
import Symbols exposing (circle, square, diamond, triangleUp, triangleDown)

main : Svg
main =
  let
    yAxis =
      Axis.createAxis yScale Axis.Orient.Left

    xAxis =
      Axis.createAxis xScale Axis.Orient.Bottom
  in
    createPlot 400 400
      |> addBars points2 .x .y xScale yScale Bars.Vertical []
      |> addAxis xAxis
      |> addAxis yAxis
      |> toSvg

xScale =
  Scale.ordinalBands ["a", "b", "c", "d"] (0, 400) 0.1 1.0

yScale =
  Scale.linear (0, 400) (400, 0) 10

points2 : List { x : String, y : Float }
points2 =
  [ {x = "a", y = 10}
  , {x = "b", y = 50}
  , {x = "c", y = 100}
  , {x = "d", y = 400}
  ]
