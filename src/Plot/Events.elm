module Plot.Events (MouseEvent, onClick) where

import Json.Decode exposing (object2, (:=), float, Decoder)
import Html.Events exposing (on)
import Plot.Scale as Scale
import Private.Scale exposing (Scale)
import Svg exposing (Svg)
import Private.BoundingBox exposing (BoundingBox)

type alias MouseInfo = { clientX: Float, clientY: Float }
type alias MouseEvent a b = { x: a, y: b }

onClick : Scale a b -> Scale d c -> (MouseEvent b c -> Signal.Message) -> BoundingBox -> Svg.Attribute
onClick xScale yScale createMessage bBox =
  on "click" clickDecoder
    <| \event -> createMessage
        { x = Scale.uninterpolate (Scale.rescaleX bBox xScale) event.clientX
        , y = Scale.uninterpolate (Scale.rescaleY bBox yScale) event.clientY
        }

clickDecoder : Decoder MouseInfo
clickDecoder =
  object2 MouseInfo
    ("clientX" := float)
    ("clientY" := float)
