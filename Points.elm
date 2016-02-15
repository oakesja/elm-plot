module Points where

import Html exposing (Html)
import Point exposing (Point)
import Scale exposing (Scale)

type alias Points = List Point

rescale : Scale -> Scale -> Points -> Points
rescale xScale yScale points =
  List.map (Point.rescale xScale yScale) points

toHtml : List Point -> List Html
toHtml points =
    List.map Point.toHtml points
