module CustomSymbol where

import Plot exposing (..)
import Scale
import Axis
import Axis.Orient
import StartApp.Simple as StartApp
import Scale.Scale exposing (Scale)
import Svg exposing (Svg, ellipse)
import Svg.Attributes exposing (cx, cy, rx, ry, stroke, fill, strokeWidth)
import Svg.Events

main : Signal Svg
main =
  StartApp.start { model = model, view = view, update = update }

type Action = Click Float Float

type alias Point = { x: Float, y : Float }
type alias Model =
  { points : List Point
  , xScale : Scale (Float, Float) Float
  , yScale : Scale (Float, Float) Float
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
      { model | points = List.filter (\p -> p.x /= xPos && p.y /= yPos) model.points }

view : Signal.Address Action -> Model -> Svg
view address model =
  createPlot 800 800
    |> addPoints model.points .x .y model.xScale model.yScale (symbol address)
    |> addAxis (Axis.createAxis model.xScale Axis.Orient.Bottom)
    |> addAxis (Axis.createAxis model.yScale Axis.Orient.Left)
    |> toSvg

symbol : Signal.Address Action -> Float -> Float -> Float -> Float -> Svg
symbol address x y pointX pointY =
  ellipse
    [ cx (toString x)
    , cy (toString y)
    , rx "8"
    , ry "10"
    , stroke "red"
    , fill "black"
    , strokeWidth "4"
    , Svg.Events.onClick (Signal.message address (Click pointX pointY))
    ]
    []
