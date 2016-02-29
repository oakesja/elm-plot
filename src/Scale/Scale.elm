module Scale.Scale where

import Private.Models exposing (PointValue, Tick)
import Sets exposing (Range)

type alias Scale a b =
  { domain : a
  , range : Range
  , interpolate : (a -> Range -> b -> PointValue b)
  , uninterpolate : (a -> Range -> Float -> b)
  , createTicks : (a -> Range -> List Tick)
  , inDomain : (a -> b -> Bool)
  }
