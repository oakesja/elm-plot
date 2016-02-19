module Point where

import Scale exposing (Scale)

type alias Point = {x: Float, y: Float}

rescale : Scale -> Scale -> Point -> Point
rescale xScale yScale point =
  { point | x = Scale.scale xScale point.x, y = Scale.scale yScale point.y }
