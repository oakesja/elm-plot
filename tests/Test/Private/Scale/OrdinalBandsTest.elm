module Test.Private.Scale.OrdinalBandsTest where

import Private.Scale.OrdinalBands exposing (..)
import ElmTest exposing (..)
import Dict exposing (Dict)
import Private.Extras.Set as Set
import Test.TestUtils.Ordinal exposing (expectedInterpolation, expectedTicks, expectedMapping)

tests : Test
tests =
  suite "Private.Scale.OrdinalBands"
    [ createMappingTests
    , interpolateTests
    , uninterpolateTests
    , ticksTests
    , inDomainTests
    ]

createMappingTests : Test
createMappingTests =
  let
    domain = ["a", "b", "c"]
    range = Set.createFromTuple (0, 120)
    expected = expectedMapping domain
  in
    suite "createMapping"
      [ test "without any paddings"
          <| assertEqual (expected 40 [0, 40, 80])
          <| Dict.toList (createMapping 0 0 domain range).lookup
      , test "with a padding set"
          <| assertEqual (expected 30 [7.5, 45, 82.5])
          <| Dict.toList (createMapping 0.2 0.2 domain range).lookup
      , test "with a padding and a different outer padding set"
          <| assertEqual (expected 32 [4, 44, 84])
          <| Dict.toList (createMapping 0.2 0.1 domain range).lookup
      , test "with a descending range"
          <| assertEqual (expected 30 [82.5, 45, 7.5])
          <| Dict.toList (createMapping 0.2 0.2 domain (Set.createFromTuple (120, 0))).lookup
      ]

interpolateTests : Test
interpolateTests =
  let
    domain = ["a", "b", "c"]
    range = Set.createFromTuple (0, 120)
    expected = expectedInterpolation domain
  in
    suite "interpolate"
      [ test "for inputs inside the domain"
          <| assertEqual (expected 40 [0, 40, 80])
          <| List.map (interpolate (createMapping 0 0) domain range) domain
      , test "for inputs not in the domain"
          <| assertEqual {value = 0, width = 0, originalValue = "d"}
          <| interpolate (createMapping 0 0) domain range "d"
      ]

uninterpolateTests : Test
uninterpolateTests =
  let
    domain = ["a", "b", "c"]
    range = Set.createFromTuple (0, 120)
    expected = expectedInterpolation domain
  in
    suite "interpolate"
      [ test "for inputs that match excatly to a domain value"
          <| assertEqual domain
          <| List.map (uninterpolate (createMapping 0 0) domain range) [0, 40, 80]
      , test "for inputs that are close to a domain value"
          <| assertEqual domain
          <| List.map (uninterpolate (createMapping 0 0) domain range) [-1, 45, 95]
      , test "for inputs that are exactly in between two domain values"
          <| assertEqual "a"
          <| uninterpolate (createMapping 0 0) domain range 20
      ]

ticksTests : Test
ticksTests =
  let
    domain = ["a", "b", "c"]
    range = Set.createFromTuple (0, 120)
  in
    suite "ticks"
      [ test "it creates ticks for the given mapping in the middle of the bands"
          <| assertEqual (expectedTicks [20, 60, 100] domain)
          <| createTicks (createMapping 0 0) domain range
      ]

inDomainTests : Test
inDomainTests =
  suite "inDomain"
    [ test "for a value that is in the list of strings for the domain"
        <| assertEqual True
        <| inDomain ["a"] "a"
    , test "for a value that is not in the list of strings for the domain"
        <| assertEqual False
        <| inDomain ["a"] "b"
    ]
