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
          <| assertEqual 4 <| transform (0, 1) range 0.25
      , test "for a reverse domain"
          <| assertEqual 12 <| transform (-1, 0) range -0.25
      , test "for domain where the min and max are equal"
          <| assertEqual 0 <| transform (1, 1) range 2
      ]

ticksTests : Test
ticksTests =
  suite "ticks"
    [ suite "generate ticks" generateTickTests
    , suite "formats ticks with the correct precision" formatTickTests
    ]

generateTickTests : List Test
generateTickTests =
  let
    range = (0, 10)
  in
    [ test "for a regular domain and 1 tick"
        <| assertEqual [0, 10] <| List.map .position <| createTicks (0, 1) range 1
    , test "for a regular domain and 2 ticks"
        <| assertEqual [0, 5, 10] <| List.map .position <| createTicks (0, 1) range 2
    , test "for a regular domain and 5 ticks"
        <| assertEqual [0, 2, 4, 6, 8, 10] <| List.map .position <| createTicks (0, 1) range 5
    , test "for a regular domain and 10 ticks"
        <| assertEqual [0..10] <| List.map .position <| createTicks (0, 1) range 10
    , test "for a reverse domain and 1 tick"
        <| assertEqual [10, 0] <| List.map .position <| createTicks (1, 0) range 1
    , test "for a reverse domain and 2 ticks"
        <| assertEqual [10, 5, 0] <| List.map .position <| createTicks (1, 0) range 2
    , test "for a reverse domain and 5 ticks"
        <| assertEqual [10, 8, 6, 4, 2, 0] <| List.map .position <| createTicks (1, 0) range 5
    , test "for a reverse domain and 10 ticks"
        <| assertEqual (List.reverse [0..10]) <| List.map .position <| createTicks (1, 0) range 10
    ]

formatTickTests : List Test
formatTickTests =
  let
    domain = (0.123456789, 1.23456789)
    firstTick = \numTicks ->
      case List.head (createTicks domain domain numTicks) of
        Just a ->
          a.position
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
