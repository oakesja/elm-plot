module Test.Private.Axis.ViewTest where

import Private.Axis.View exposing (..)
import Plot.Scale as Scale exposing (LinearScale)
import Plot.Axis as Axis
import Private.BoundingBox as BoundingBox exposing (BoundingBox)
import ElmTest exposing (..)
import Svg.Attributes exposing (transform)
import Test.TestUtils.Sets exposing (assertSet)
import Private.Extras.Set as Set

tests : Test
tests =
  suite "Private.Axis.View"
    [ calculateAxisExtentTests
    , axisTranslationTests
    , pathStringTests
    ]

calculateAxisExtentTests : Test
calculateAxisExtentTests =
  let
    boundingBox  = BoundingBox.create 5 95 2 97
    range = Set.createFromTuple (10, 90)
    descendingRange = Set.createFromTuple (90, 10)
    largeRange = Set.createFromTuple (0, 100)
    largeDescending = Set.createFromTuple (100, 0)
    calculateExtent' = calculateAxisExtent boundingBox
  in
    suite "calculateAxisExtent"
      [ test "for the x axis and a range fits inside the bounding box"
          <| assertSet (10, 90)
          <| calculateExtent' Axis.Top range
      , test "for bottom orient and a range fits inside the bounding box"
          <| assertSet (10, 90)
          <| calculateExtent' Axis.Bottom range
      , test "for left orient and a range fits inside the bounding box"
          <| assertSet (10, 90)
          <| calculateExtent' Axis.Left range
      , test "for right orient and a range fits inside the bounding box"
          <| assertSet (10, 90)
          <| calculateExtent' Axis.Right range
      , test "for the x axis and a descending range fits inside the bounding box"
          <| assertSet (10, 90)
          <| calculateExtent' Axis.Top descendingRange
      , test "for bottom orient and a descending range fits inside the bounding box"
          <| assertSet (10, 90)
          <| calculateExtent' Axis.Bottom descendingRange
      , test "for left orient and a descending range fits inside the bounding box"
          <| assertSet (10, 90)
          <| calculateExtent' Axis.Left descendingRange
      , test "for right orient and a descending range fits inside the bounding box"
          <| assertSet (10, 90)
          <| calculateExtent' Axis.Right descendingRange
      , test "for the x axis and a range that does not inside the bounding box"
          <| assertSet (5, 95)
          <| calculateExtent' Axis.Top largeRange
      , test "for bottom orient and a range that does not inside the bounding box"
          <| assertSet (5, 95)
          <| calculateExtent' Axis.Bottom largeRange
      , test "for left orient and a range that does not inside the bounding box"
          <| assertSet (2, 97)
          <| calculateExtent' Axis.Left largeRange
      , test "for right orient and a range that does not inside the bounding box"
          <| assertSet (2, 97)
          <| calculateExtent' Axis.Right largeRange
      , test "for the x axis and a descending range that does not inside the bounding box"
          <| assertSet (5, 95)
          <| calculateExtent' Axis.Top largeDescending
      , test "for bottom orient and a descending range that does not inside the bounding box"
          <| assertSet (5, 95)
          <| calculateExtent' Axis.Bottom largeDescending
      , test "for left orient and a descending range that does not inside the bounding box"
          <| assertSet (2, 97)
          <| calculateExtent' Axis.Left largeDescending
      , test "for right orient and a descending range that does not inside the bounding box"
          <| assertSet (2, 97)
          <| calculateExtent' Axis.Right largeDescending
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
