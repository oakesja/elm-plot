module Test.Axis.SvgTest where

import Axis.Svg exposing (..)
import Axis.Orient
import Scale exposing (Scale)
import BoundingBox exposing (BoundingBox)
import ElmTest exposing (..)
import Svg.Attributes exposing (x, y, y2, x2, dy, textAnchor, transform)

tests : Test
tests =
  suite "Axis.Svg"
        [ axisTranslationTests
        , pathStringTests
        , createTickInfosTests
        , innerTickLineAttributesTests
        , labelAttributesTests
        ]

axisTranslationTests : Test
axisTranslationTests =
  suite "axisTranslation"
    [ test "for top orient"
        <| assertEqual "translate(0,2)" <| axisTranslation boundingBox Axis.Orient.Top
    , test "for bottom orient"
        <| assertEqual "translate(0,100)" <| axisTranslation boundingBox Axis.Orient.Bottom
    , test "for left orient"
        <| assertEqual "translate(5,0)" <| axisTranslation boundingBox Axis.Orient.Left
    , test "for right orient"
        <| assertEqual "translate(95,0)" <| axisTranslation boundingBox Axis.Orient.Right
    ]

pathStringTests : Test
pathStringTests =
  suite "pathString"
    [ test "for top orient"
      <| assertEqual "M10,-6V0H90V-6" <| pathString boundingBox scale Axis.Orient.Top 6
    , test "for bottom orient"
      <| assertEqual "M10,6V0H90V6" <| pathString boundingBox scale Axis.Orient.Bottom 6
    , test "for left orient"
      <| assertEqual "M-6,10H0V90H-6" <| pathString boundingBox scale Axis.Orient.Left 6
    , test "for right orient"
      <| assertEqual "M6,10H0V90H6" <| pathString boundingBox scale Axis.Orient.Right 6
    , test "for a scale that does not fit inside the x boundings"
      <| assertEqual "M5,-6V0H95V-6"
        <| pathString boundingBox (Scale.linear (0, 105) (0, 105) 1) Axis.Orient.Top 6
    , test "for a scale that does not fit inside the y boundings"
      <| assertEqual "M-6,2H0V100H-6"
        <| pathString boundingBox (Scale.linear (0, 105) (0, 105) 1) Axis.Orient.Left 6
    , test "for x axis with a reverse scale that does not fit inside the x boundings"
      <| assertEqual "M5,-6V0H95V-6"
        <| pathString boundingBox (Scale.linear (0, 105) (105, 0) 1) Axis.Orient.Top 6
    , test "for y axis with a reverse scale that does not fit inside the y boundings"
      <| assertEqual "M-6,2H0V100H-6"
        <| pathString boundingBox (Scale.linear (0, 105) (105, 0) 1) Axis.Orient.Left 6
    , test "for a non-default tick size"
      <| assertEqual "M10,-8V0H90V-8" <| pathString boundingBox scale Axis.Orient.Top 8
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

scale : Scale Float
scale =
  Scale.linear (10, 90) (10, 90) 1

boundingBox : BoundingBox
boundingBox  =
    { xStart = 5
    , xEnd = 95
    , yStart = 2
    , yEnd = 100
    }
