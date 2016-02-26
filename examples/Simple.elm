module Simple where

import Html exposing (Html, div)
import Plot exposing (..)
import Line.Interpolation exposing (linear)
import Scale
import Svg.Attributes exposing (cx, cy, r, stroke)
import Axis
import Axis.Orient
import Symbols exposing (circle, square, diamond, triangleUp, triangleDown)

main : Html
main =
  let
    yAxis =
      Axis.createAxis yScale Axis.Orient.Left
        |> Axis.innerTickAttributes [stroke "red"]
        |> Axis.title "y axis"

    xAxis =
      Axis.createAxis xScale Axis.Orient.Bottom
        |> Axis.labelRotation -45
        |> Axis.title "x axis"
  in
    createPlot 400 400
      |> addLines lines .x .y xScale yScale linear []
      |> addPoints points .x .y xScale yScale (diamond 5 [])
      |> addAxis xAxis
      |> addAxis yAxis
      |> margins {top = 50, bottom = 50, right = 50, left = 100}
      |> toSvg

xScale =
  Scale.linear (0, 100) (0, 400) 10

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
