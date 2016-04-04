module Private.Scale where

import Private.Extras.Set as Set exposing (Set)
import Private.Tick exposing (Tick)
import Private.PointValue exposing (PointValue)

type alias Scale a b =
  { domain : a
  , range : Set
  , interpolate : (a -> Set -> b -> PointValue b)
  , uninterpolate : (a -> Set -> Float -> b)
  , createTicks : (a -> Set -> List Tick)
  , inDomain : (a -> b -> Bool)
  }
