module Test.Axis.ViewTest where

import Axis.View exposing (..)
import Axis.Orient
import Scale
import BoundingBox exposing (BoundingBox)
import Scale.Scale exposing (Scale)
import ElmTest exposing (..)
import Svg.Attributes exposing (transform)
import Extras.Set as Set exposing (Set)

tests : Test
tests =
  suite "Axis.Title"
        [ axisTranslationTests
        , pathStringTests
        ]

axisTranslationTests : Test
axisTranslationTests =
  suite "axisTranslation"
    [ test "for top orient"
        <| assertEqual (transform "translate(0,2)")
        <| axisTranslation boundingBox Axis.Orient.Top
    , test "for bottom orient"
        <| assertEqual (transform "translate(0,100)")
        <| axisTranslation boundingBox Axis.Orient.Bottom
    , test "for left orient"
        <| assertEqual (transform "translate(5,0)")
        <| axisTranslation boundingBox Axis.Orient.Left
    , test "for right orient"
        <| assertEqual (transform "translate(95,0)")
        <| axisTranslation boundingBox Axis.Orient.Right
    ]

pathStringTests : Test
pathStringTests =
  suite "pathString"
    [ test "for top orient"
      <| assertEqual "M10,-6V0H90V-6"
      <| pathString boundingBox scale Axis.Orient.Top 6
    , test "for bottom orient"
      <| assertEqual "M10,6V0H90V6"
      <| pathString boundingBox scale Axis.Orient.Bottom 6
    , test "for left orient"
      <| assertEqual "M-6,10H0V90H-6"
      <| pathString boundingBox scale Axis.Orient.Left 6
    , test "for right orient"
      <| assertEqual "M6,10H0V90H6"
      <| pathString boundingBox scale Axis.Orient.Right 6
    , test "for a scale that does not fit inside the x boundings"
      <| assertEqual "M5,-6V0H95V-6"
      <| pathString boundingBox (Scale.linear (0, 105) (0, 105) 1) Axis.Orient.Top 6
    , test "for a scale that does not fit inside the y boundings"
      <| assertEqual "M-6,2H0V100H-6"
      <| pathString boundingBox (Scale.linear (0, 105) (0, 105) 1) Axis.Orient.Left 6
    , test "for x axis with a descending scale that does not fit inside the x boundings"
      <| assertEqual "M5,-6V0H95V-6"
      <| pathString boundingBox (Scale.linear (0, 105) (105, 0) 1) Axis.Orient.Top 6
    , test "for y axis with a descending scale that does not fit inside the y boundings"
      <| assertEqual "M-6,2H0V100H-6"
      <| pathString boundingBox (Scale.linear (0, 105) (105, 0) 1) Axis.Orient.Left 6
    , test "for a non-default tick size"
      <| assertEqual "M10,-8V0H90V-8"
      <| pathString boundingBox scale Axis.Orient.Top 8
    ]

scale : Scale Set Float
scale =
  Scale.linear (10, 90) (10, 90) 1

boundingBox : BoundingBox
boundingBox  =
  BoundingBox.create 5 95 2 100
