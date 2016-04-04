module Test.Private.Axis.ViewTest where

import Private.Axis.View exposing (..)
import Plot.Scale as Scale exposing (LinearScale)
import Plot.Axis as Axis
import Private.BoundingBox as BoundingBox exposing (BoundingBox)
import ElmTest exposing (..)
import Svg.Attributes exposing (transform)

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
        <| axisTranslation boundingBox Axis.Top
    , test "for bottom orient"
        <| assertEqual (transform "translate(0,100)")
        <| axisTranslation boundingBox Axis.Bottom
    , test "for left orient"
        <| assertEqual (transform "translate(5,0)")
        <| axisTranslation boundingBox Axis.Left
    , test "for right orient"
        <| assertEqual (transform "translate(95,0)")
        <| axisTranslation boundingBox Axis.Right
    ]

pathStringTests : Test
pathStringTests =
  suite "pathString"
    [ test "for top orient"
      <| assertEqual "M10,-6V0H90V-6"
      <| pathString boundingBox scale Axis.Top 6
    , test "for bottom orient"
      <| assertEqual "M10,6V0H90V6"
      <| pathString boundingBox scale Axis.Bottom 6
    , test "for left orient"
      <| assertEqual "M-6,10H0V90H-6"
      <| pathString boundingBox scale Axis.Left 6
    , test "for right orient"
      <| assertEqual "M6,10H0V90H6"
      <| pathString boundingBox scale Axis.Right 6
    , test "for a scale that does not fit inside the x boundings"
      <| assertEqual "M5,-6V0H95V-6"
      <| pathString boundingBox (Scale.linear (0, 105) (0, 105) 1) Axis.Top 6
    , test "for a scale that does not fit inside the y boundings"
      <| assertEqual "M-6,2H0V100H-6"
      <| pathString boundingBox (Scale.linear (0, 105) (0, 105) 1) Axis.Left 6
    , test "for x axis with a descending scale that does not fit inside the x boundings"
      <| assertEqual "M5,-6V0H95V-6"
      <| pathString boundingBox (Scale.linear (0, 105) (105, 0) 1) Axis.Top 6
    , test "for y axis with a descending scale that does not fit inside the y boundings"
      <| assertEqual "M-6,2H0V100H-6"
      <| pathString boundingBox (Scale.linear (0, 105) (105, 0) 1) Axis.Left 6
    , test "for a non-default tick size"
      <| assertEqual "M10,-8V0H90V-8"
      <| pathString boundingBox scale Axis.Top 8
    ]

scale : LinearScale
scale =
  Scale.linear (10, 90) (10, 90) 1

boundingBox : BoundingBox
boundingBox  =
  BoundingBox.create 5 95 2 100
