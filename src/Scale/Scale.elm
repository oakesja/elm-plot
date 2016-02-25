module Scale.Scale where

import Private.Models exposing (PointValue, Tick)
import Sets exposing (Range)

type alias Scale a =
  { range : Range
  , transform : (Range -> a -> PointValue)
  , createTicks : (Range -> List Tick)
  }
