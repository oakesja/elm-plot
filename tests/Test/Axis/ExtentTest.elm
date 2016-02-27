module Test.Axis.ExtentTest where

import Axis.Extent exposing (..)
import Axis.Orient
import ElmTest exposing (..)

tests : Test
tests =
  suite "Axis.Extent"
        [ calculateExtentTests
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
    range = (10, 90)
    descendingRange = (90, 10)
    largeRange = (0, 100)
    largeDescending = (100, 0)
    calculateExtent' = calculateExtent boundingBox
  in
    suite "calculateExtent"
      [ test "for top orient and range fits inside the bounding box"
          <| assertEqual (createExtent 10 90)
          <| calculateExtent' Axis.Orient.Top range
      , test "for bottom orient and range fits inside the bounding box"
          <| assertEqual (createExtent 10 90)
          <| calculateExtent' Axis.Orient.Bottom range
      , test "for left orient and range fits inside the bounding box"
          <| assertEqual (createExtent 10 90)
          <| calculateExtent' Axis.Orient.Left range
      , test "for right orient and range fits inside the bounding box"
          <| assertEqual (createExtent 10 90)
          <| calculateExtent' Axis.Orient.Right range
      , test "for top orient and descending range fits inside the bounding box"
          <| assertEqual (createExtent 10 90)
          <| calculateExtent' Axis.Orient.Top descendingRange
      , test "for bottom orient and descending range fits inside the bounding box"
          <| assertEqual (createExtent 10 90)
          <| calculateExtent' Axis.Orient.Bottom descendingRange
      , test "for left orient and descending range fits inside the bounding box"
          <| assertEqual (createExtent 10 90)
          <| calculateExtent' Axis.Orient.Left descendingRange
      , test "for right orient and descending range fits inside the bounding box"
          <| assertEqual (createExtent 10 90)
          <| calculateExtent' Axis.Orient.Right descendingRange
      , test "for top orient and range that does not inside the bounding box"
          <| assertEqual (createExtent 5 95)
          <| calculateExtent' Axis.Orient.Top largeRange
      , test "for bottom orient and range that does not inside the bounding box"
          <| assertEqual (createExtent 5 95)
          <| calculateExtent' Axis.Orient.Bottom largeRange
      , test "for left orient and range that does not inside the bounding box"
          <| assertEqual (createExtent 2 97)
          <| calculateExtent' Axis.Orient.Left largeRange
      , test "for right orient and range that does not inside the bounding box"
          <| assertEqual (createExtent 2 97)
          <| calculateExtent' Axis.Orient.Right largeRange
      , test "for top orient and descending range that does not inside the bounding box"
          <| assertEqual (createExtent 5 95)
          <| calculateExtent' Axis.Orient.Top largeDescending
      , test "for bottom orient and descending range that does not inside the bounding box"
          <| assertEqual (createExtent 5 95)
          <| calculateExtent' Axis.Orient.Bottom largeDescending
      , test "for left orient and descending range that does not inside the bounding box"
          <| assertEqual (createExtent 2 97)
          <| calculateExtent' Axis.Orient.Left largeDescending
      , test "for right orient and descending range that does not inside the bounding box"
          <| assertEqual (createExtent 2 97)
          <| calculateExtent' Axis.Orient.Right largeDescending
      ]
