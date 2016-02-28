module Test.SetsTest where

import Sets exposing (..)
import Axis.Orient
import ElmTest exposing (..)
import Scale.Type

tests : Test
tests =
  suite "Sets"
        [ extentOfTests
        , calculateAxisExtentTests
        , calculateExtentTests
        ]

extentOfTests : Test
extentOfTests =
  suite "extentOf"
    [ test "for a set"
        <| assertEqual (0, 1)
        <| extentOf (0, 1)
    , test "for a reversed set"
        <| assertEqual (0, 1)
        <| extentOf (1, 0)
    ]

calculateAxisExtentTests : Test
calculateAxisExtentTests =
  let
    boundingBox  =
        { xStart = 5
        , xEnd = 95
        , yStart = 2
        , yEnd = 97
        }
    range = (10, 90)
    descendingRange = (90, 10)
    largeRange = (0, 100)
    largeDescending = (100, 0)
    calculateExtent' = calculateAxisExtent boundingBox
  in
    suite "calculateAxisExtent"
      [ test "for the x axis and a range fits inside the bounding box"
          <| assertEqual (10, 90)
          <| calculateExtent' Axis.Orient.Top range
      , test "for bottom orient and a range fits inside the bounding box"
          <| assertEqual (10, 90)
          <| calculateExtent' Axis.Orient.Bottom range
      , test "for left orient and a range fits inside the bounding box"
          <| assertEqual (10, 90)
          <| calculateExtent' Axis.Orient.Left range
      , test "for right orient and a range fits inside the bounding box"
          <| assertEqual (10, 90)
          <| calculateExtent' Axis.Orient.Right range
      , test "for the x axis and a descending range fits inside the bounding box"
          <| assertEqual (10, 90)
          <| calculateExtent' Axis.Orient.Top descendingRange
      , test "for bottom orient and a descending range fits inside the bounding box"
          <| assertEqual (10, 90)
          <| calculateExtent' Axis.Orient.Bottom descendingRange
      , test "for left orient and a descending range fits inside the bounding box"
          <| assertEqual (10, 90)
          <| calculateExtent' Axis.Orient.Left descendingRange
      , test "for right orient and a descending range fits inside the bounding box"
          <| assertEqual (10, 90)
          <| calculateExtent' Axis.Orient.Right descendingRange
      , test "for the x axis and a range that does not inside the bounding box"
          <| assertEqual (5, 95)
          <| calculateExtent' Axis.Orient.Top largeRange
      , test "for bottom orient and a range that does not inside the bounding box"
          <| assertEqual (5, 95)
          <| calculateExtent' Axis.Orient.Bottom largeRange
      , test "for left orient and a range that does not inside the bounding box"
          <| assertEqual (2, 97)
          <| calculateExtent' Axis.Orient.Left largeRange
      , test "for right orient and a range that does not inside the bounding box"
          <| assertEqual (2, 97)
          <| calculateExtent' Axis.Orient.Right largeRange
      , test "for the x axis and a descending range that does not inside the bounding box"
          <| assertEqual (5, 95)
          <| calculateExtent' Axis.Orient.Top largeDescending
      , test "for bottom orient and a descending range that does not inside the bounding box"
          <| assertEqual (5, 95)
          <| calculateExtent' Axis.Orient.Bottom largeDescending
      , test "for left orient and a descending range that does not inside the bounding box"
          <| assertEqual (2, 97)
          <| calculateExtent' Axis.Orient.Left largeDescending
      , test "for right orient and a descending range that does not inside the bounding box"
          <| assertEqual (2, 97)
          <| calculateExtent' Axis.Orient.Right largeDescending
      ]

calculateExtentTests : Test
calculateExtentTests =
  let
    boundingBox  =
        { xStart = 5
        , xEnd = 95
        , yStart = 2
        , yEnd = 97
        }
    set = (10, 90)
    descendingSet = (90, 10)
    largeSet = (0, 100)
    descendingLarge = (100, 0)
    calculateExtent' = calculateExtent boundingBox
  in
    suite "calculateAxisExtent"
      [ test "for the x axis and a range fits inside the bounding box"
          <| assertEqual set
          <| calculateExtent' Scale.Type.XScale set
      , test "for the y axis and a range fits inside the bounding box"
          <| assertEqual set
          <| calculateExtent' Scale.Type.YScale set
      , test "for the x axis and a descending range fits inside the bounding box"
          <| assertEqual descendingSet
          <| calculateExtent' Scale.Type.XScale descendingSet
      , test "for the y axis and a descending range fits inside the bounding box"
          <| assertEqual descendingSet
          <| calculateExtent' Scale.Type.YScale descendingSet
      , test "for the x axis and a range that does not inside the bounding box"
          <| assertEqual (5, 95)
          <| calculateExtent' Scale.Type.XScale largeSet
      , test "for the y axis and a range that does not inside the bounding box"
          <| assertEqual (2, 97)
          <| calculateExtent' Scale.Type.YScale largeSet
      , test "for the x axis and a descending range that does not inside the bounding box"
          <| assertEqual (95, 5)
          <| calculateExtent' Scale.Type.XScale descendingLarge
      , test "for the y axis and a descending range that does not inside the bounding box"
          <| assertEqual (97, 2)
          <| calculateExtent' Scale.Type.YScale descendingLarge
      ]
