module Axis where

import Html exposing (Html)
import Scale exposing (Scale)

type Orientation = Top | Bottom | Left | Right
type alias Axis = {orient : Orientation, ticks : Int}

-- toHtml : Scale -> Axis -> Html
-- toHtml scale axis =
