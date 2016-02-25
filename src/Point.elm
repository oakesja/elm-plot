module Point where

import Private.Models exposing (Scale, Point, PointWithBands)
import Scale

transformIntoBand : Scale a -> Scale b -> Point a b -> PointWithBands
transformIntoBand xScale yScale point =
  { x = Scale.transform xScale point.x, y = Scale.transform yScale point.y}

transformIntoPoint : Scale a -> Scale b -> Point a b -> Point Float Float
transformIntoPoint xScale yScale point =
  { x = .value <| Scale.transform xScale point.x, y = .value <| Scale.transform yScale point.y}
