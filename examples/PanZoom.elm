module PanZoom where

import Plot exposing (..)
import Scale
import Axis
import Axis.Orient
import Symbols exposing (circle)
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
type alias Point = { x : Float, y : Float }
type alias Model =
  { points : List Point
  , xScale : Scale (Float, Float) Float
  , yScale : Scale (Float, Float) Float
  , dragging : Bool
  , dragPosition : Point
  }

type Action = Wheel Float | DragStart Float Float | Drag Float Float | DragEnd

model : Model
model =
  { points =
    [ {x = 2.0, y = 100}
    , {x = 1.5, y = 150}
    , {x = 1.0, y = 200}
    , {x = 1.5, y = 250}
    , {x = 2.0, y = 300}
    , {x = 2.5, y = 250}
    , {x = 2.5, y = 150}
    , {x = 3.0, y = 200}
    ]
  , xScale = Scale.linear (0, 4) (0, 800) 5
  , yScale = Scale.linear (0, 400) (800, 0) 5
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
    events =
      [ on "wheel" wheelDecoder (\event -> Signal.message address (Wheel event.deltaY))
      , on "mousedown" dragDecoder (\event -> Signal.message address (DragStart event.clientX event.clientY))
      , on "mousemove" dragDecoder (\event -> Signal.message address (Drag event.clientX event.clientY))
      , on "mouseup" dragDecoder (\_ -> Signal.message address (DragEnd))
      ]
  in
    createPlot 800 800
      |> addPoints model.points .x .y model.xScale model.yScale (circle 5 [])
      |> addAxis (Axis.create model.yScale Axis.Orient.Left)
      |> addAxis (Axis.create model.xScale Axis.Orient.Bottom)
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
