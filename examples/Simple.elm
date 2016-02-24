module Simple where

import Html exposing (Html, div)
import Plot exposing (..)
import Line.Interpolation exposing (linear)
import Scale exposing (Scale)
import Svg.Attributes exposing (cx, cy, r, stroke)
import Axis
import Axis.Orient
import Symbols exposing (circle, square, diamond, triangleUp, triangleDown)

main : Html
main =
  let
    yAxis =
      Axis.createAxis yScale Axis.Orient.Left
        |> Axis.outerTickSize 10
        |> Axis.innerTickSize 15
        |> Axis.innerTickStyle [stroke "red"]
        |> Axis.title "y axis"
        |> Axis.titleOffset 40

    xAxis =
      Axis.createAxis xScale Axis.Orient.Bottom
        |> Axis.tickPadding 5
        |> Axis.labelRotation -45
        |> Axis.title "x axis"
  in
    createPlot 400 400
      |> addLines lines .x .y xScale yScale linear []
      -- |> addPoints points .x .y xScale yScale (circle 3 [])
      -- |> addPoints points .x .y xScale yScale (square 5 [])
      |> addPoints points .x .y xScale yScale (diamond 5 [])
      -- |> addPoints points .x .y xScale yScale (triangleUp 10 [])
      -- |> addPoints points .x .y xScale yScale (triangleDown 10 [])
      |> addAxis xAxis
      |> addAxis yAxis
      |> toSvg

xScale : Scale Float
xScale =
  Scale.linear (0, 100) (0, 400) 10

yScale : Scale Float
yScale =
  Scale.linear (0, 100) (400, 0) 20

points : List { x : Float, y : Float }
points =
  [ {x = 0, y = 0}
  , {x = 50, y = 50}
  , {x = 100, y = 100}
  , {x = 200, y = 200}
  , {x = 300, y = 300}
  , {x = 400, y = 400}
  ]

points2 : List { x : String, y : Float }
points2 =
  [ {x = "0", y = 0}
  , {x = "50", y = 50}
  , {x = "100", y = 100}
  , {x = "200", y = 200}
  , {x = "300", y = 300}
  , {x = "400", y = 400}
  ]

lines : List { x : Float, y : Float }
lines =
  [ { x =  0,   y =  0}
  , { x =  50,  y =  50}
  , { x =  40,  y =  10}
  , { x =  60,  y =  40}
  , { x =  80,  y =  5}
  , { x =  100, y =  100}
  ]
