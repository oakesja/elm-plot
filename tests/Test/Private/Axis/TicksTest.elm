module Test.Private.Axis.TicksTest where

import Private.Axis.Ticks exposing (..)
import Plot.Scale as Scale
import Plot.Axis as Axis
import ElmTest exposing (..)
import Svg.Attributes exposing (x, y, y2, x2, dy, textAnchor, transform)

tests : Test
tests =
  suite "Private.Axis.Ticks"
    [ createTickInfosTests
    , innerTickLineAttributesTests
    , labelAttributesTests
    ]

createTickInfosTests : Test
createTickInfosTests =
  let
    scale = Scale.linear (0, 1) (0, 10) 1
  in
    suite "createTickInfos"
      [ test "for top orient"
          <| assertEqual [{label = "0", translation = (0, 0)}, {label = "1", translation = (10, 0)}]
          <| createTickInfos scale Axis.Top
      , test "for bottom orient"
          <| assertEqual [{label = "0", translation = (0, 0)}, {label = "1", translation = (10, 0)}]
          <| createTickInfos scale Axis.Bottom
      , test "for left orient"
          <| assertEqual [{label = "0", translation = (0, 0)}, {label = "1", translation = (0, 10)}]
          <| createTickInfos scale Axis.Left
      , test "for right orient"
          <| assertEqual [{label = "0", translation = (0, 0)}, {label = "1", translation = (0, 10)}]
          <| createTickInfos scale Axis.Right
      ]

innerTickLineAttributesTests : Test
innerTickLineAttributesTests =
  suite "innerTickLineAttributes"
    [ test "for top orient"
        <| assertEqual [x2 "0", y2 "-6"]
        <| innerTickLineAttributes Axis.Top 6
    , test "for bottom orient"
        <| assertEqual [x2 "0", y2 "6"]
        <| innerTickLineAttributes Axis.Bottom 6
    , test "for left orient"
        <| assertEqual [x2 "-4", y2 "0"]
        <| innerTickLineAttributes Axis.Left 4
    , test "for right orient"
        <| assertEqual [x2 "4", y2 "0"]
        <| innerTickLineAttributes Axis.Right 4
    ]

labelAttributesTests : Test
labelAttributesTests =
  suite "labelAttributes"
    [ test "for top orient"
        <| assertEqual [x "0", y "-6", dy "0em", textAnchor "middle"]
        <| labelAttributes Axis.Top 6 0 0
    , test "for bottom orient"
        <| assertEqual [x "0", y "6", dy ".71em", textAnchor "middle"]
        <| labelAttributes Axis.Bottom 6 0 0
    , test "for left orient"
        <| assertEqual [x "-6", y "0", dy ".32em", textAnchor "end"]
        <| labelAttributes Axis.Left 6 0 0
    , test "for right orient"
        <| assertEqual [x "6", y "0", dy ".32em", textAnchor "start"]
        <| labelAttributes Axis.Right 6 0 0
    , test "tick padding is included in the ofset"
        <| assertEqual [x "10", y "0", dy ".32em", textAnchor "start"]
        <| labelAttributes Axis.Right 8 2 0
    , test "when rotation is not zero a rotaion transform is included"
        <| assertEqual [x "6", y "0", dy ".32em", textAnchor "start", transform "rotate(25,6,0)"]
        <| labelAttributes Axis.Right 6 0 25
    ]
