module Ordinal where

import Html exposing (Html, div)
import Plot exposing (..)
import Scale exposing (Scale)
import Axis
import Axis.Orient
import Symbols exposing (circle, square, diamond, triangleUp, triangleDown)

main : Html
main =
  let
    yAxis =
      Axis.createAxis xScale Axis.Orient.Left

    xAxis =
      Axis.createAxis yScale Axis.Orient.Bottom

    plot =
      createPlot 400 400
        |> addPoints points2 .y .x yScale xScale (circle 5 [])
        |> addAxis xAxis
        |> addAxis yAxis
        |> toSvg
  in
    div
      []
      [plot, plot]

xScale : Scale String
xScale =
  Scale.ordinalPoints ["a", "b", "c", "d"] (400, 0) 3

yScale : Scale Float
yScale =
  Scale.linear (0, 400) (0, 400) 10

points2 : List { x : String, y : Float }
points2 =
  [ {x = "a", y = 0}
  , {x = "b", y = 50}
  , {x = "c", y = 100}
  , {x = "d", y = 400}
  , {x = "c", y = 300}
  ]
