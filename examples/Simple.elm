module Simple where

import Html exposing (Html)
import Plot exposing (..)
import Plot exposing (..)
import Line.Interpolation exposing (linear)
import Axis
import Scale
import Svg exposing (circle, Svg)
import Svg.Attributes exposing (cx, cy, r)

main : Html
main =
  let
    xScale = Scale.linear (0, 100) (0, 400)
    yScale = Scale.linear (0, 100) (400, 0)
  in
    createPlot 400 400
      |> addLines lines .x .y xScale yScale linear
      |> addPoints points .x .y xScale yScale circleSvg
      |> toSvg

circleSvg : Float -> Float -> Svg
circleSvg x y =
  circle
    [ cx <| toString x
    , cy <| toString y
    , r "4"
    ]
    []

points =
  [ {x = 10, y = 10}
  , {x = 50, y = 50}
  , {x = 100, y = 100}
  , {x = 200, y = 200}
  , {x = 300, y = 300}
  , {x = 400, y = 500}
  ]

lines =
  [ { x =  10,   y =  10}
  , { x =  50,  y =  50}
  , { x =  40,  y =  10}
  , { x =  60,  y =  40}
  , { x =  80,  y =  5}
  , { x =  100, y =  60}
  ]
