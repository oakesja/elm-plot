module Test.Scale.LinearTest where

import Scale.Linear exposing (..)
import Zoom
import ElmTest exposing (..)

tests : Test
tests =
  suite "Scale.Linear"
        [ interpolateTests
        , uninterpolateTests
        , createTicksTests
        , zoomTests
        , panTests
        ]

interpolateTests : Test
interpolateTests =
  let
    range = (0, 16)
  in
    suite "interpolate"
      [ test "for a regular domain"
          <| assertEqual 4
          <| (interpolate (0, 1) range 0.25).value
      , test "for a reverse domain"
          <| assertEqual 12
          <| (interpolate (-1, 0) range -0.25).value
      , test "when the min and max of the domain is equal"
          <| assertEqual 0
          <| (interpolate (1, 1) range 2).value
      , test "the band width is always 0"
          <| assertEqual 0
          <| (interpolate (0, 1) range 0.25).width
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

createTicksTests : Test
createTicksTests =
  let
    range = (0, 10)
  in
    suite "createTicks"
      [ test "for a regular domain and 1 tick"
          <| assertEqual [0, 10]
          <| List.map .position (createTicks 1 (0, 1) range)
      , test "for a regular domain and 2 ticks"
          <| assertEqual [0, 5, 10]
          <| List.map .position (createTicks 2 (0, 1) range)
      , test "for a regular domain and 5 ticks"
          <| assertEqual [0, 2, 4, 6, 8, 10]
          <| List.map .position (createTicks 5 (0, 1) range)
      , test "for a regular domain and 10 ticks"
          <| assertEqual [0..10]
          <| List.map .position (createTicks 10 (0, 1) range)
      , test "for a reverse domain and 1 tick"
          <| assertEqual [10, 0]
          <| List.map .position (createTicks 1 (1, 0) range)
      , test "for a reverse domain and 2 ticks"
          <| assertEqual [10, 5, 0]
          <| List.map .position (createTicks 2 (1, 0) range)
      , test "for a reverse domain and 5 ticks"
          <| assertEqual [10, 8, 6, 4, 2, 0]
          <| List.map .position (createTicks 5 (1, 0) range)
      , test "for a reverse domain and 10 ticks"
          <| assertEqual (List.reverse [0..10])
          <| List.map .position (createTicks 10 (1, 0) range)
      , test "for a larger domain when no rounding should take place"
          <| assertEqual [70, 102.5, 135, 167.5, 200, 232.5, 265, 297.5, 330]
          <| List.map .position (createTicks 10 (0, 400) (70, 330))
      ]

zoomTests : Test
zoomTests =
  suite "zoom"
    [ test "zoom in"
        <| assertEqual (25, 75)
        <| zoom (0, 100) 0.25 Zoom.In
    , test "zoom out"
        <| assertEqual (-25, 125)
        <| zoom (0, 100) 0.25 Zoom.Out
    , test "zoom in descending domain"
        <| assertEqual (75, 25)
        <| zoom (100, 0) 0.25 Zoom.In
    , test "zoom out"
        <| assertEqual (125, -25)
        <| zoom (100, 0) 0.25 Zoom.Out
    ]

panTests : Test
panTests =
  suite "pan"
    [ test "pan positive with ascending domain"
        <| assertEqual (10, 110)
        <| pan (0, 100) 10
    , test "pan negative with ascending domain"
        <| assertEqual (-10, 90)
        <| pan (0, 100) -10
    , test "pan positive with descending domain"
        <| assertEqual (110, 10)
        <| pan (100, 0) 10
    , test "pan negative with descending domain"
        <| assertEqual (90, -10)
        <| pan (100, 0) -10
    ]
