module PlotClickEvent where

import Plot exposing (..)
import Plot.Scale as Scale exposing (LinearScale)
import Plot.Axis as Axis
import Plot.Symbols exposing (circle)
import StartApp.Simple as StartApp
import Svg exposing (Svg)

main : Signal Svg
main =
  StartApp.start { model = model, view = view, update = update }

type Action = Click Float Float

type alias Model =
  { points : List { x: Float, y : Float }
  , xScale : LinearScale
  , yScale : LinearScale
}

model : Model
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
  , xScale = Scale.linear (0, 400) (0, 800) 2
  , yScale = Scale.linear (0, 400) (800, 0) 2
  }

update : Action -> Model -> Model
update action model =
  case action of
    Click xPos yPos ->
      { model | points = { x = xPos, y = yPos } :: model.points }

view : Signal.Address Action -> Model -> Svg
view address model =
  createPlot 800 800
    |> addPoints model.points .x .y model.xScale model.yScale (circle 5 [])
    |> addAxis (Axis.create model.xScale Axis.Bottom)
    |> addAxis (Axis.create model.yScale Axis.Left)
    |> onClick model.xScale model.yScale (\e -> Signal.message address (Click e.x e.y))
    |> toSvg
