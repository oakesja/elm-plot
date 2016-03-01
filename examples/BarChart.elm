module OrdinalBands where

import Svg exposing (Svg)
import Plot exposing (..)
import Scale
import Axis
import Axis.Orient
import Bars

main : Svg
main =
  let
    xScale = Scale.ordinalBands ["a", "b", "c", "d"] (0, 800) 0.2 0.2
    yScale = Scale.linear (0, 400) (800, 0) 10
  in
    createPlot 800 800
      |> addBars points .x .y xScale yScale Bars.Vertical []
      |> addAxis (Axis.createAxis xScale Axis.Orient.Bottom)
      |> addAxis (Axis.createAxis yScale Axis.Orient.Left)
      |> toSvg

points : List { x : String, y : Float }
points =
  [ {x = "a", y = 10}
  , {x = "b", y = 50}
  , {x = "c", y = 100}
  , {x = "d", y = 400}
  , {x = "e", y = 150}
  ]
