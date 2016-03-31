module Test.Scale.LinearTest where

import Scale.Linear exposing (..)
import Zoom
import ElmTest exposing (..)
import Extras.Set as Set
import Test.TestUtils.Sets exposing (assertSet)

tests : Test
tests =
  suite "Scale.Linear"
        [ interpolateTests
        , uninterpolateTests
        , createTicksTests
        , zoomTests
        , panTests
        , panInPixelsTests
        , inDomainTests
        ]

-- TODO assert point value
interpolateTests : Test
interpolateTests =
  let
    range = (0, 16)
    interpolate' =
      \d r v ->
        interpolate (Set.createFromTuple d) (Set.createFromTuple r) v
  in
    suite "interpolate"
      [ test "for a regular domain"
          <| assertEqual 4
          <| (interpolate' (0, 1) range 0.25).value
      , test "for a reverse domain"
          <| assertEqual 12
          <| (interpolate' (-1, 0) range -0.25).value
      , test "when the min and max of the domain is equal"
          <| assertEqual 0
          <| (interpolate' (1, 1) range 2).value
      , test "the band width is always 0"
          <| assertEqual 0
          <| (interpolate' (0, 1) range 0.25).width
      ]

uninterpolateTests : Test
uninterpolateTests =
  let
    domain = (0, 1)
    uninterpolate' =
      \d r v ->
        uninterpolate (Set.createFromTuple d) (Set.createFromTuple r) v
  in
    suite "uninterpolate"
      [ test "for a regular domain"
          <| assertEqual 0.25
          <| uninterpolate' domain (0, 16) 4
      , test "for a reverse domain"
          <| assertEqual 0.25
          <| uninterpolate' domain (16, 0) 12
      , test "when the min and max of the range is equal"
          <| assertEqual 0
          <| uninterpolate' domain (16, 16) 2
      ]

createTicksTests : Test
createTicksTests =
  let
    range = (0, 10)
    createTicks' =
      \num d r ->
        createTicks num (Set.createFromTuple d) (Set.createFromTuple r)
  in
    suite "createTicks"
      [ test "for a regular domain and 1 tick"
          <| assertEqual [0, 10]
          <| List.map .position (createTicks' 1 (0, 1) range)
      , test "for a regular domain and 2 ticks"
          <| assertEqual [0, 5, 10]
          <| List.map .position (createTicks' 2 (0, 1) range)
      , test "for a regular domain and 5 ticks"
          <| assertEqual [0, 2, 4, 6, 8, 10]
          <| List.map .position (createTicks' 5 (0, 1) range)
      , test "for a regular domain and 10 ticks"
          <| assertEqual [0..10]
          <| List.map .position (createTicks' 10 (0, 1) range)
      , test "for a reverse domain and 1 tick"
          <| assertEqual [10, 0]
          <| List.map .position (createTicks' 1 (1, 0) range)
      , test "for a reverse domain and 2 ticks"
          <| assertEqual [10, 5, 0]
          <| List.map .position (createTicks' 2 (1, 0) range)
      , test "for a reverse domain and 5 ticks"
          <| assertEqual [10, 8, 6, 4, 2, 0]
          <| List.map .position (createTicks' 5 (1, 0) range)
      , test "for a reverse domain and 10 ticks"
          <| assertEqual (List.reverse [0..10])
          <| List.map .position (createTicks' 10 (1, 0) range)
      , test "for a larger domain when no rounding should take place"
          <| assertEqual [70, 102.5, 135, 167.5, 200, 232.5, 265, 297.5, 330]
          <| List.map .position (createTicks' 10 (0, 400) (70, 330))
      ]

zoomTests : Test
zoomTests =
  let
    zoom' =
      \d v dir ->
        zoom (Set.createFromTuple d) v dir
  in
    suite "zoom"
      [ test "zoom in with ascending domain"
          <| assertSet (25, 75)
          <| zoom' (0, 100) 0.25 Zoom.In
      , test "zoom out with ascending domain"
          <| assertSet (-25, 125)
          <| zoom' (0, 100) 0.25 Zoom.Out
      , test "zoom in with descending domain"
          <| assertSet (75, 25)
          <| zoom' (100, 0) 0.25 Zoom.In
      , test "zoom out with descending domain"
          <| assertSet (125, -25)
          <| zoom' (100, 0) 0.25 Zoom.Out
      ]

panTests : Test
panTests =
  let
    pan' =
      \d v ->
        pan (Set.createFromTuple d) v
  in
    suite "pan"
      [ test "pan positive with ascending domain"
          <| assertSet (10, 110)
          <| pan' (0, 100) 10
      , test "pan negative with ascending domain"
          <| assertSet (-10, 90)
          <| pan' (0, 100) -10
      , test "pan positive with descending domain"
          <| assertSet (110, 10)
          <| pan' (100, 0) 10
      , test "pan negative with descending domain"
          <| assertSet (90, -10)
          <| pan' (100, 0) -10
      ]

panInPixelsTests : Test
panInPixelsTests =
  let
    panInPixels' =
      \d r v ->
        panInPixels (Set.createFromTuple d) (Set.createFromTuple r) v
  in
    suite "panInPixels"
      [ test "pan positive with ascending domain"
          <| assertSet (0.1, 1.1)
          <| panInPixels' (0, 1) (0, 100) 10
      , test "pan negative with ascending domain"
          <| assertSet (-0.1, 0.9)
          <| panInPixels' (0, 1) (0, 100) -10
      , test "pan positive with descending domain"
          <| assertSet (1.1, 0.1)
          <| panInPixels' (1, 0) (0, 100) 10
      , test "pan negative with descending domain"
          <| assertSet (0.9, -0.1)
          <| panInPixels' (1, 0) (0, 100) -10
      , test "pan positive with descending range"
          <| assertSet (0.1, 1.1)
          <| panInPixels' (0, 1) (100, 0) 10
      , test "pan negative with descending range"
          <| assertSet (-0.1, 0.9)
          <| panInPixels' (0, 1) (100, 0) -10
      , test "pan when range has the same start and end"
          <| assertSet (0, 1)
          <| panInPixels' (0, 1) (100, 100) 10
      ]

inDomainTests : Test
inDomainTests =
  let
    inDomain' =
      \d v ->
        inDomain (Set.createFromTuple d) v
  in
    suite "inDomain"
      [ test "in the domain for an ascending domain"
          <| assertEqual True
          <| inDomain' (0, 1) 0.5
      , test "less than the min of domain for an ascending domain"
          <| assertEqual False
          <| inDomain' (0, 1) -1
      , test "greater than the max of domain for an ascending domain"
          <| assertEqual False
          <| inDomain' (0, 1) 2
      , test "in the domain for an descending domain"
          <| assertEqual True
          <| inDomain' (1, 0) 0.5
      , test "less than the min of domain for an descending domain"
          <| assertEqual False
          <| inDomain' (1, 0) -1
      , test "greater than the max of domain for an descending domain"
          <| assertEqual False
          <| inDomain' (1, 0) 2
      , test "equal to the min or max of the domain"
          <| assertEqual [True, True]
          <| List.map (inDomain' (1, 0)) [0, 1]
      ]
