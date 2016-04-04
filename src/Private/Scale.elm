module Private.Scale where

import Private.Extras.Set as Set exposing (Range)
import Private.Tick exposing (Tick)
import Private.Models exposing (PointValue)

type alias Scale a b =
  { domain : a
  , range : Range
  , interpolate : (a -> Range -> b -> PointValue b)
  , uninterpolate : (a -> Range -> Float -> b)
  , createTicks : (a -> Range -> List Tick)
  , inDomain : (a -> b -> Bool)
  }
