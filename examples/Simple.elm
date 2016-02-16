module Simple where

import Html exposing (Html)
import Plot exposing (..)
import Plot exposing (..)
import Line.InterpolationModes exposing (linear)
import Axis
import Scale
import Svg exposing (circle, Svg)
import Svg.Attributes exposing (cx, cy, r)

main : Html
main =
  createPlot 400 400 (Scale.linear (0, 100) (0, 400)) (Scale.linear (0, 100) (400, 0))
    |> addPoints (List.map (\p -> { point = p, toHtml = circleSvg }) points)
    |> addLines linear lines
    |> addXAxis { orient = Axis.Bottom, ticks = 10 }
    |> toHtml

circleSvg : Float -> Float -> Svg
circleSvg x y =
  circle
    [ cx <| toString x
    , cy <| toString y
    , r "3"
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
  [ { x =  1,   y =  5}
  , { x =  20,  y =  20}
  , { x =  40,  y =  10}
  , { x =  60,  y =  40}
  , { x =  80,  y =  5}
  , { x =  100, y =  60}
  ]
