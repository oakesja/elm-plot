module Test.Scale.OrdinalBandsTest where

import Scale.OrdinalBands exposing (..)
import ElmTest exposing (..)
import Dict exposing (Dict)
import Private.Models exposing (PointValue, Tick)

tests : Test
tests =
  suite "Scale.OrdinalBands"
        [ createMappingTests
        , interpolateTests
        , ticksTests
        ]

createMappingTests : Test
createMappingTests =
  let
    domain = ["a", "b", "c"]
    range = (0, 120)
    expected = expectedMapping domain
  in
    suite "createMapping"
      [ test "without any paddings"
          <| assertEqual (expected [0, 40, 80] 40)
          <| Dict.toList <| createMapping domain 0 0 range
      , test "with a padding set"
          <| assertEqual (expected [7.5, 45, 82.5] 30)
          <| Dict.toList <| createMapping domain 0.2 0.2 range
      , test "with a padding and a different outer padding set"
          <| assertEqual (expected [4, 44, 84] 32)
          <| Dict.toList <| createMapping domain 0.2 0.1 range
      , test "with a descending range"
          <| assertEqual (expected [82.5, 45, 7.5] 30)
          <| Dict.toList <| createMapping domain 0.2 0.2 (120, 0)
      ]

expectedMapping : List String -> List Float -> Float -> List (String, PointValue String)
expectedMapping domain values width =
  List.map2 (\d v -> (d, { value = v, width = width, originalValue = d })) domain values

interpolateTests : Test
interpolateTests =
  let
    domain = ["a", "b", "c"]
    range = (0, 120)
    expected = expectedInterpolation domain
  in
    suite "interpolate"
      [ test "for inputs inside the domain"
          <| assertEqual (expected [0, 40, 80] 40)
          <| List.map (interpolate (createMapping domain 0 0) range) domain
      , test "for inputs not in the domain"
          <| assertEqual {value = 0, width = 0, originalValue = "d"}
          <| interpolate (createMapping domain 0 0) range "d"
      ]

expectedInterpolation : List String -> List Float -> Float -> List (PointValue String)
expectedInterpolation domain values width =
  List.map2 (\d v -> { value = v, width = width, originalValue = d }) domain values

ticksTests : Test
ticksTests =
  let
    domain = ["a", "b", "c"]
    range = (0, 120)
  in
    suite "ticks"
      [ test "it creates ticks for the given mapping in the middle of the bands"
          <| assertEqual (expectedTicks [20, 60, 100] domain)
          <| createTicks (createMapping domain 0 0) range
      ]

expectedTicks : List Float -> List String -> List Tick
expectedTicks values domain =
  List.map2 (\v d-> { position = v, label = d }) values domain
