module Point where

import Scale exposing (Scale)

type alias Point a b = {x: a, y: b}
type alias TransformedPoint = {x: Float, y: Float }

rescale : Scale a -> Scale b -> Point a b -> TransformedPoint
rescale xScale yScale point =
  { x = Scale.transform xScale point.x, y = Scale.transform yScale point.y}
