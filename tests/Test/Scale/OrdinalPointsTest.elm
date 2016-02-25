module Test.Scale.OrdinalPointsTest where

import Scale.OrdinalPoints exposing (..)
import ElmTest exposing (..)
import Private.Models exposing (PointValue, Tick)
import Dict exposing (Dict)

tests : Test
tests =
  suite "Scale.OrdinalPoints"
        [ createMappingTests
        , interpolateTests
        , uninterpolateTests
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
      [ test "without padding"
          <| assertEqual (expected [0, 60, 120])
          <| Dict.toList <| .lookup <| createMapping domain 0 range
      , test "with a padding"
          <| assertEqual (expected [30, 60, 90])
          <| Dict.toList <| .lookup <| createMapping domain 2 range
      , test "a single item in the input domain is correctly handled"
          <| assertEqual (expected [60])
          <| Dict.toList <| .lookup <| createMapping ["a"] 0 range
      , test "descending range without padding"
          <| assertEqual (expected [120, 60, 0])
          <| Dict.toList <| .lookup <| createMapping domain 0 (120, 0)
      , test "descending range with padding"
          <| assertEqual (expected [90, 60, 30])
          <| Dict.toList <| .lookup <| createMapping domain 2 (120, 0)
      ]

expectedMapping : List String -> List Float -> List (String, PointValue String)
expectedMapping domain values =
    List.map2 (\d v -> (d, { value = v, width = 0, originalValue = d })) domain values

interpolateTests : Test
interpolateTests =
  let
    domain = ["a", "b", "c"]
    range = (0, 120)
    expected = expectedInterpolation domain
  in
    suite "interpolate"
      [ test "for inputs inside the domain"
          <| assertEqual (expected [0, 60, 120])
          <| List.map (interpolate (createMapping domain 0) range) domain
      , test "for inputs not in the domain"
          <| assertEqual {value = 0, width = 0, originalValue = "d"}
          <| interpolate (createMapping domain 0) range "d"
      ]

expectedInterpolation : List String -> List Float -> List (PointValue String)
expectedInterpolation domain values =
  List.map2 (\d v -> { value = v, width = 0, originalValue = d }) domain values

uninterpolateTests : Test
uninterpolateTests =
  let
    domain = ["a", "b", "c"]
    range = (0, 120)
    expected = expectedInterpolation domain
  in
    suite "interpolate"
      [ test "for inputs that match excatly to a domain value"
          <| assertEqual domain
          <| List.map (uninterpolate (createMapping domain 0) range) [0, 60, 120]
      , test "for inputs that are close to a domain value"
          <| assertEqual domain
          <| List.map (uninterpolate (createMapping domain 0) range) [-1, 75, 125]
      , test "for inputs that are exactly in between two domain values"
          <| assertEqual "a"
          <| uninterpolate (createMapping domain 0) range 30
      ]

ticksTests : Test
ticksTests =
  let
    domain = ["a", "b", "c"]
    range = (0, 120)
  in
    suite "ticks"
      [ test "it creates tick for everything in the domain"
          <| assertEqual (expectedTicks [0, 60, 120] domain)
          <| createTicks (createMapping domain 0) range
      ]

expectedTicks : List Float -> List String -> List Tick
expectedTicks values domain =
  List.map2 (\v d-> { position = v, label = d }) values domain
