module Private.Point where

import Private.Scale.Utils as Scale
import Private.Scale exposing (Scale)
import Private.PointValue exposing (PointValue)

type alias Point a b =
  { x: a
  , y: b
  }
type alias InterpolatedPoint a b =
  { x: PointValue a
  , y: PointValue b
  }

create : a -> b -> Point a b
create x y =
  { x = x
  , y = y
  }

interpolate : Scale x a -> Scale y b -> Point a b -> InterpolatedPoint a b
interpolate xScale yScale point =
  { x = Scale.interpolate xScale point.x, y = Scale.interpolate yScale point.y}
