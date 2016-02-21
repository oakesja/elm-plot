module Simple where

import Html exposing (Html, div)
import Plot exposing (..)
import Line.Interpolation exposing (linear)
import Scale exposing (Scale)
import Svg exposing (circle, Svg)
import Svg.Attributes exposing (cx, cy, r)
import Axis
import Axis.Orient

main : Html
main =
  let
    yAxis =
      Axis.createAxis yScale Axis.Orient.Left
        |> Axis.numberOfTicks 10

    plot =
      createPlot 400 400
        |> addLines lines .x .y xScale yScale linear []
        |> addPoints points .x .y xScale yScale circleSvg
        -- |> addAxis createAxis xScale Axis.Top
        |> addAxis yAxis
        |> toSvg
  in
    div
      []
      [plot, plot]

xScale : Scale
xScale =
  Scale.linear (0, 100) (0, 400)

yScale : Scale
yScale =
  Scale.linear (0, 100) (400, 0)

circleSvg : Float -> Float -> Svg
circleSvg x y =
  circle
    [ cx <| toString x
    , cy <| toString y
    , r "4"
    ]
    []

points : List { x : Float, y : Float }
points =
  [ {x = 0, y = 0}
  , {x = 50, y = 50}
  , {x = 100, y = 100}
  , {x = 200, y = 200}
  , {x = 300, y = 300}
  , {x = 400, y = 400}
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
