module Test.Scale.LinearTest where

import Scale.Linear exposing (..)
import ElmTest exposing (..)

tests : Test
tests =
  suite "Scale.Linear"
        [ interpolateTests
        , uninterpolateTests
        , ticksTests
        ]

interpolateTests : Test
interpolateTests =
  let
    range = (0, 16)
  in
    suite "interpolate"
      [ test "for a regular domain"
          <| assertEqual 4
          <| .value <| interpolate (0, 1) range 0.25
      , test "for a reverse domain"
          <| assertEqual 12
          <| .value <| interpolate (-1, 0) range -0.25
      , test "when the min and max of the domain is equal"
          <| assertEqual 0
          <| .value <| interpolate (1, 1) range 2
      , test "the band width is always 0"
          <| assertEqual 0
          <| .width <| interpolate (0, 1) range 0.25
      ]

uninterpolateTests : Test
uninterpolateTests =
  let
    domain = (0, 1)
  in
    suite "uninterpolate"
      [ test "for a regular domain"
          <| assertEqual 0.25
          <| uninterpolate domain (0, 16) 4
      , test "for a reverse domain"
          <| assertEqual 0.25
          <| uninterpolate domain (16, 0) 12
      , test "when the min and max of the range is equal"
          <| assertEqual 0
          <| uninterpolate domain (16, 16) 2
      ]

ticksTests : Test
ticksTests =
  suite "ticks"
    [ suite "create ticks" createTicksTests
    , suite "formats ticks with the correct precision" formatTickTests
    ]

createTicksTests : List Test
createTicksTests =
  let
    range = (0, 10)
  in
    [ test "for a regular domain and 1 tick"
        <| assertEqual [0, 10]
        <| List.map .position <| createTicks (0, 1) 1 range
    , test "for a regular domain and 2 ticks"
        <| assertEqual [0, 5, 10]
        <| List.map .position <| createTicks (0, 1) 2 range
    , test "for a regular domain and 5 ticks"
        <| assertEqual [0, 2, 4, 6, 8, 10]
        <| List.map .position <| createTicks (0, 1) 5 range
    , test "for a regular domain and 10 ticks"
        <| assertEqual [0..10]
        <| List.map .position <| createTicks (0, 1) 10 range
    , test "for a reverse domain and 1 tick"
        <| assertEqual [10, 0]
        <| List.map .position <| createTicks (1, 0) 1 range
    , test "for a reverse domain and 2 ticks"
        <| assertEqual [10, 5, 0]
        <| List.map .position <| createTicks (1, 0) 2 range
    , test "for a reverse domain and 5 ticks"
        <| assertEqual [10, 8, 6, 4, 2, 0]
        <| List.map .position <| createTicks (1, 0) 5 range
    , test "for a reverse domain and 10 ticks"
        <| assertEqual (List.reverse [0..10])
        <| List.map .position <| createTicks (1, 0) 10 range
    ]

formatTickTests : List Test
formatTickTests =
  let
    domain = (0.123456789, 1.23456789)
    firstTick = \numTicks ->
      case List.head (createTicks domain numTicks domain) of
        Just a ->
          a.position
        Nothing ->
          -1
  in
    [ test "for 1 tick"
        <| assertEqual 1
        <| firstTick 1
    , test "for 2 tick"
        <| assertEqual 0.5
        <| firstTick 2
    , test "for 16 tick"
        <| assertEqual 0.2
        <| firstTick 16
    , test "for 64 tick"
        <| assertEqual 0.14
        <| firstTick 64
    , test "for 256 tick"
        <| assertEqual 0.125
        <| firstTick 256
    ]
