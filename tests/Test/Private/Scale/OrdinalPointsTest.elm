module Test.Private.Scale.OrdinalPointsTest where

import Private.Scale.OrdinalPoints exposing (..)
import ElmTest exposing (..)
import Dict exposing (Dict)
import Private.Extras.Set as Set
import Private.PointValue exposing (PointValue)
import Test.TestUtils.Ordinal exposing (expectedInterpolation, expectedTicks, expectedMapping)

tests : Test
tests =
  suite "Private.Scale.OrdinalPoints"
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
    expected = expectedMapping domain 0
  in
    suite "createMapping"
      [ test "without padding"
          <| assertEqual (expected [0, 60, 120])
          <| Dict.toList (createMapping 0 domain range).lookup
      , test "with a padding"
          <| assertEqual (expected [30, 60, 90])
          <| Dict.toList (createMapping 2 domain range).lookup
      , test "a single item in the input domain is correctly handled"
          <| assertEqual (expected [60])
          <| Dict.toList (createMapping 0 ["a"] range).lookup
      , test "descending range without padding"
          <| assertEqual (expected [120, 60, 0])
          <| Dict.toList (createMapping 0 domain (Set.createFromTuple (120, 0))).lookup
      , test "descending range with padding"
          <| assertEqual (expected [90, 60, 30])
          <| Dict.toList (createMapping 2 domain (Set.createFromTuple (120, 0))).lookup
      ]

interpolateTests : Test
interpolateTests =
  let
    domain = ["a", "b", "c"]
    range = Set.createFromTuple (0, 120)
    expected = expectedInterpolation domain 0
  in
    suite "interpolate"
      [ test "for inputs inside the domain"
          <| assertEqual (expected [0, 60, 120])
          <| List.map (interpolate (createMapping 0) domain range) domain
      , test "for inputs not in the domain"
          <| assertEqual {value = 0, width = 0, originalValue = "d"}
          <| interpolate (createMapping 0) domain range "d"
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
          <| List.map (uninterpolate (createMapping 0) domain range) [0, 60, 120]
      , test "for inputs that are close to a domain value"
          <| assertEqual domain
          <| List.map (uninterpolate (createMapping 0) domain range) [-1, 75, 125]
      , test "for inputs that are exactly in between two domain values"
          <| assertEqual "a"
          <| uninterpolate (createMapping 0) domain range 30
      ]

ticksTests : Test
ticksTests =
  let
    domain = ["a", "b", "c"]
    range = Set.createFromTuple (0, 120)
  in
    suite "ticks"
      [ test "it creates tick for everything in the domain"
          <| assertEqual (expectedTicks [0, 60, 120] domain)
          <| createTicks (createMapping 0) domain range
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
