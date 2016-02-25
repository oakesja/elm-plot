module OrdinalBandsEvent where

import Plot exposing (..)
import Scale
import Axis
import Axis.Orient
import Symbols exposing (circle, square, diamond, triangleUp, triangleDown)
import Debug
import StartApp.Simple as StartApp
import Scale.Scale exposing (Scale)
import Svg exposing (Svg)
import Bars

main : Signal Svg
main =
  StartApp.start { model = model, view = view, update = update }

type Action = Click String Float

type alias Model =
  { points : List { x: String, y : Float}, xScale : Scale String, yScale : Scale Float}

model : Model
model =
  { points =
    [ {x = "a", y = 10}
    , {x = "b", y = 50}
    , {x = "c", y = 100}
    , {x = "d", y = 400}
    , {x = "e", y = 150}
    ]
  , xScale = Scale.ordinalBands ["a", "b", "c", "d"] (0, 400) 0 0.2
  , yScale = Scale.linear (0, 400) (400, 0) 10
  }

-- update : Plot.Action -> Model -> Model
update action model =
  case action of
    Click xPos yPos ->
      Debug.log "model" { model | points = { x = xPos, y = yPos } :: model.points }

-- view : Signal.Address Plot.Action -> Model -> Svg
view address model =
  let
    yAxis =
      Axis.createAxis model.yScale Axis.Orient.Left

    xAxis =
      Axis.createAxis model.xScale Axis.Orient.Bottom
  in
    createPlot 400 400
      |> addBars model.points .x .y model.xScale model.yScale Bars.Vertical []
      |> addAxis xAxis
      |> addAxis yAxis
      |> registerOnClick model.xScale model.yScale (\me -> Signal.message address <| Click me.x me.y)
      |> toSvg
