module Point where

import Scale exposing (Scale)

type alias Point = {x: Float, y: Float}

rescale : Scale -> Scale -> Point -> Point
rescale xScale yScale point =
  { point | x = xScale.rescale point.x, y = yScale.rescale point.y }
