module Event where

import Svg exposing (Svg)
import Plot exposing (..)
import Scale
import Axis
import Axis.Orient
import Bars
import Symbols exposing (circle, square, diamond, triangleUp, triangleDown)
import Debug
import StartApp.Simple as StartApp
import Svg.Events exposing (..)

main =
  StartApp.start { model = model, view = view, update = update }

model =
  { points =
    [ {x = 10, y = 10}
    , {x = 50, y = 50}
    , {x = 100, y = 100}
    , {x = 150, y = 150}
    , {x = 200, y = 200}
    , {x = 250, y = 250}
    , {x = 300, y = 300}
    , {x = 400, y = 400}
    ]
  , xScale = Scale.linear (0, 400) (0, 400) 10
  , yScale = Scale.linear (0, 400) (400, 0) 10
  }

update action model =
  case action of
    Plot.ClickEvent x y ->
      let
        temp = Debug.log "click position" (x, y)
      in
        model

view address model =
  let
    yAxis =
      Axis.createAxis model.yScale Axis.Orient.Left

    xAxis =
      Axis.createAxis model.xScale Axis.Orient.Bottom
  in
    createPlot 400 400
      |> addPoints model.points .x .y model.xScale model.yScale (circle 5 [])
      |> addAxis xAxis
      |> addAxis yAxis
      |> registerOnClick model.xScale model.yScale address
      |> toSvg
