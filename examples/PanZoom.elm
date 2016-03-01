module PanZoom where

import Plot exposing (..)
import Scale
import Axis
import Axis.Orient
import Symbols exposing (circle, square, diamond, triangleUp, triangleDown)
import StartApp.Simple as StartApp
import Scale.Scale exposing (Scale)
import Svg exposing (Svg)
import Html.Events exposing (on)
import Json.Decode exposing (object1, object2, (:=), float, Decoder)
import Zoom

main : Signal Svg
main =
  StartApp.start { model = model, view = view, update = update }

type alias WheelEvent = { deltaY : Float }
type alias DragEvent = { clientX : Float, clientY : Float }

type alias Model =
  { points : List { x : Float, y : Float }
  , xScale : Scale (Float, Float) Float
  , yScale : Scale (Float, Float) Float
  , dragging : Bool
  , dragPosition : { x : Float, y : Float }
  }

type Action = Wheel Float | DragStart Float Float | Drag Float Float | DragEnd

model : Model
model =
  { points =
    [ {x = 200, y = 100}
    , {x = 150, y = 150}
    , {x = 100, y = 200}
    , {x = 150, y = 250}
    , {x = 200, y = 300}
    , {x = 250, y = 250}
    , {x = 250, y = 150}
    , {x = 300, y = 200}
    ]
  , xScale = Scale.linear (0, 4) (0, 400) 5
  , yScale = Scale.linear (0, 400) (400, 0) 5
  , dragging = False
  , dragPosition = { x = 0, y = 0 }
  }

update : Action -> Model -> Model
update action model =
  case action of
    Wheel delta ->
      let
        direction =
          if delta > 0 then
            Zoom.Out
          else
            Zoom.In
      in
        { model
          | yScale = Scale.zoom model.yScale 0.25 direction
          , xScale = Scale.zoom model.xScale 0.25 direction
        }
    DragStart x y ->
      { model
        | dragging = True
        , dragPosition = { x = x, y = y }
      }
    Drag x y ->
      if model.dragging then
        let
          deltaX = model.dragPosition.x - x
          deltaY = y - model.dragPosition.y
        in
          { model
            | xScale = Scale.panInPixels model.xScale deltaX
            , yScale = Scale.panInPixels model.yScale deltaY
            , dragPosition = { x = x, y = y }
          }
      else
        model
    DragEnd ->
      { model | dragging = False }

view : Signal.Address Action -> Model -> Svg
view address model =
  let
    yAxis =
      Axis.createAxis model.yScale Axis.Orient.Left
    xAxis =
      Axis.createAxis model.xScale Axis.Orient.Bottom
    events =
      [ on "wheel" wheelDecoder (\event -> Signal.message address (Wheel event.deltaY))
      , on "mousedown" dragDecoder (\event -> Signal.message address (DragStart event.clientX event.clientY))
      , on "mousemove" dragDecoder (\event -> Signal.message address (Drag event.clientX event.clientY))
      , on "mouseup" dragDecoder (\_ -> Signal.message address (DragEnd))
      ]
  in
    createPlot 400 400
      |> addPoints model.points (\p -> p.x / 100) .y model.xScale model.yScale (circle 5 [])
      |> addAxis xAxis
      |> addAxis yAxis
      |> attributes events
      |> toSvg

wheelDecoder : Decoder WheelEvent
wheelDecoder =
  object1 WheelEvent
    ("deltaY" := float)

dragDecoder : Decoder DragEvent
dragDecoder =
  object2 DragEvent
    ("clientX" := float)
    ("clientY" := float)
