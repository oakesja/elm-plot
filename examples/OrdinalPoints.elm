module OrdinalPoints where

import Svg exposing (Svg)
import Plot exposing (..)
import Scale
import Axis
import Axis.Orient
import Symbols exposing (circle)

main : Svg
main =
  let
    yScale = Scale.linear (0, 400) (800, 0) 10
    xScale = Scale.ordinalPoints ["a", "b", "c", "d"] (0, 800) 0
  in
    createPlot 800 800
      |> addPoints points .x .y xScale yScale (circle 5 [])
      |> addAxis (Axis.create xScale Axis.Orient.Bottom)
      |> addAxis (Axis.create yScale Axis.Orient.Left)
      |> toSvg

points : List { x : String, y : Float }
points =
  [ {x = "a", y = 10}
  , {x = "b", y = 50}
  , {x = "c", y = 100}
  , {x = "d", y = 400}
  ]
