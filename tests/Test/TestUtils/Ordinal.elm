module Test.TestUtils.Ordinal where

import Private.PointValue exposing (PointValue)
import Private.Tick exposing (Tick)

expectedMapping : List String -> Float-> List Float -> List (String, PointValue String)
expectedMapping domain width values =
  List.map2 (\d v -> (d, { value = v, width = width, originalValue = d })) domain values

expectedInterpolation : List String -> Float-> List Float -> List (PointValue String)
expectedInterpolation domain width values =
  List.map2 (\d v -> { value = v, width = width, originalValue = d }) domain values

expectedTicks : List Float -> List String -> List Tick
expectedTicks values domain =
  List.map2 (\v d-> { position = v, label = d }) values domain
