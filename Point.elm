module Point where

import Html exposing (Html)
import Svg exposing (circle)
import Svg.Attributes exposing (cx, cy, r)
import Scale exposing (Scale)

type alias Point = {x: Float, y: Float}

rescale : Scale -> Scale -> Point -> Point
rescale xScale yScale point =
  { x = xScale.rescale point.x, y = yScale.rescale point.y }

toHtml : Point -> Html
toHtml point =
  circle
    [ cx <| toString point.x
    , cy <| toString point.y
    , r "5"
    ]
    []
