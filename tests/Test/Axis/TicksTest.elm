module Test.Axis.TicksTest where

import Axis.Ticks exposing (..)
import Axis.Orient
import Scale exposing (Scale)
import ElmTest exposing (..)
import Svg.Attributes exposing (x, y, y2, x2, dy, textAnchor, transform)

tests : Test
tests =
  suite "Axis.Svg"
        [ createTickInfosTests
        , innerTickLineAttributesTests
        , labelAttributesTests
        ]

createTickInfosTests : Test
createTickInfosTests =
  let
    scale = Scale.linear (0, 1) (0, 10) 1
  in
    suite "createTicks"
      [ test "for top orient"
          <| assertEqual [{label = "0", translation = (0, 0)}, {label = "1", translation = (10, 0)}]
            <| createTickInfos scale Axis.Orient.Top
      , test "for bottom orient"
          <| assertEqual [{label = "0", translation = (0, 0)}, {label = "1", translation = (10, 0)}]
            <| createTickInfos scale Axis.Orient.Bottom
      , test "for left orient"
          <| assertEqual [{label = "0", translation = (0, 0)}, {label = "1", translation = (0, 10)}]
            <| createTickInfos scale Axis.Orient.Left
      , test "for right orient"
          <| assertEqual [{label = "0", translation = (0, 0)}, {label = "1", translation = (0, 10)}]
            <| createTickInfos scale Axis.Orient.Right
      ]

innerTickLineAttributesTests : Test
innerTickLineAttributesTests =
  suite "innerTickLineAttributes"
    [ test "for top orient"
        <| assertEqual [x2 "0", y2 "-6"]
          <| innerTickLineAttributes Axis.Orient.Top 6
    , test "for bottom orient"
        <| assertEqual [x2 "0", y2 "6"]
          <| innerTickLineAttributes Axis.Orient.Bottom 6
    , test "for left orient"
        <| assertEqual [x2 "-4", y2 "0"]
          <| innerTickLineAttributes Axis.Orient.Left 4
    , test "for right orient"
        <| assertEqual [x2 "4", y2 "0"]
          <| innerTickLineAttributes Axis.Orient.Right 4
    ]

labelAttributesTests : Test
labelAttributesTests =
  suite "labelAttributes"
    [ test "for top orient"
        <| assertEqual [x "0", y "-6", dy "0em", textAnchor "middle"]
          <| labelAttributes Axis.Orient.Top 6 0 0
    , test "for bottom orient"
        <| assertEqual [x "0", y "6", dy ".71em", textAnchor "middle"]
          <| labelAttributes Axis.Orient.Bottom 6 0 0
    , test "for left orient"
        <| assertEqual [x "-6", y "0", dy ".32em", textAnchor "end"]
          <| labelAttributes Axis.Orient.Left 6 0 0
    , test "for right orient"
        <| assertEqual [x "6", y "0", dy ".32em", textAnchor "start"]
          <| labelAttributes Axis.Orient.Right 6 0 0
    , test "tick padding is included in the ofset"
        <| assertEqual [x "10", y "0", dy ".32em", textAnchor "start"]
          <| labelAttributes Axis.Orient.Right 8 2 0
    , test "when rotation is not zero a rotaion transform is included"
        <| assertEqual [x "6", y "0", dy ".32em", textAnchor "start", transform "rotate(25,6,0)"]
          <| labelAttributes Axis.Orient.Right 6 0 25
    ]
