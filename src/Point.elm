module Point where

import Private.Models exposing (Scale, Point, TransformedPoint)
import Scale

transform : Scale a -> Scale b -> Point a b -> TransformedPoint
transform xScale yScale point =
  { x = Scale.transform xScale point.x, y = Scale.transform yScale point.y}
