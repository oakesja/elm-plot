module Points where

import Point exposing (Point)
import Scale exposing (Scale)

type alias Points = List Point

rescale : Scale -> Scale -> Points -> Points
rescale xScale yScale points =
  List.map (Point.rescale xScale yScale) points
