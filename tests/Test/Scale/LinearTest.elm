module Test.Scale.LinearTest where

import Scale.Linear exposing (..)
import ElmTest exposing (..)

tests : Test
tests =
  suite "Scale.Lienar"
        [ scaleTests
        , ticksTests
        ]

scaleTests : Test
scaleTests =
  let
    range = (0, 16)
  in
    suite "scale"
      [ test "for a regular domain"
          <| assertEqual 4 <| scale (0, 1) range 0.25
      , test "for a reverse domain"
          <| assertEqual 12 <| scale (-1, 0) range -0.25
      , test "for domain where the min and max are equal"
          <| assertEqual 0 <| scale (1, 1) range 2
      ]

ticksTests : Test
ticksTests =
  suite "ticks"
    [ suite "generate ticks" generateTickTests
    , suite "formats ticks with the correct precision" formatTickTests
    ]

generateTickTests : List Test
generateTickTests =
  [ test "for a regular domain and 1 tick"
      <| assertEqual [0, 1] <| ticks (0, 1) 1
  , test "for a regular domain and 2 ticks"
      <| assertEqual [0, 0.5, 1] <| ticks (0, 1) 2
  , test "for a regular domain and 5 ticks"
      <| assertEqual [0, 0.2, 0.4, 0.6, 0.8, 1] <| ticks (0, 1) 5
  , test "for a regular domain and 10 ticks"
      <| assertEqual [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1] <| ticks (0, 1) 10
  , test "for a reverse domain and 1 tick"
      <| assertEqual [0, 1] <| ticks (1, 0) 1
  , test "for a reverse domain and 2 ticks"
      <| assertEqual [0, 0.5, 1] <| ticks (1, 0) 2
  , test "for a reverse domain and 5 ticks"
      <| assertEqual [0, 0.2, 0.4, 0.6, 0.8, 1] <| ticks (1, 0) 5
  , test "for a reverse domain and 10 ticks"
      <| assertEqual [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1] <| ticks (1, 0) 10
  ]

formatTickTests : List Test
formatTickTests =
  let
    domain = (0.123456789, 1.23456789)
    firstTick = \numTicks ->
      case List.head (ticks domain numTicks) of
        Just a ->
          a
        Nothing ->
          -1
  in
    [ test "for 1 tick"
        <| assertEqual 1 <| firstTick 1
    , test "for 2 tick"
        <| assertEqual 0.5 <| firstTick 2
    , test "for 16 tick"
        <| assertEqual 0.2 <| firstTick 16
    , test "for 64 tick"
        <| assertEqual 0.14 <| firstTick 64
    , test "for 256 tick"
        <| assertEqual 0.125 <| firstTick 256              
    ]
