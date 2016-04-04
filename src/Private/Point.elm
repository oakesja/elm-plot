module Private.Point where

import Private.Models exposing (Point, InterpolatedPoint)
import Plot.Scale as Scale
import Private.Scale exposing (Scale)

interpolate : Scale x a -> Scale y b -> Point a b -> InterpolatedPoint a b
interpolate xScale yScale point =
  { x = Scale.interpolate xScale point.x, y = Scale.interpolate yScale point.y}
