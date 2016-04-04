module Test.Private.SetsTest where

import Private.Extras.Set as Set exposing (..)
import ElmTest exposing (..)
import Test.TestUtils.Sets exposing (assertSet)

tests : Test
tests =
  suite "Sets"
        [ extentOfTests
        ]

extentOfTests : Test
extentOfTests =
  suite "extentOf"
    [ test "for a set"
        <| assertSet (0, 1)
        <| extentOf
        <| createFromTuple (0, 1)
    , test "for a reversed set"
        <| assertSet (0, 1)
        <| extentOf
        <| createFromTuple (1, 0)
    ]

-- TODO move
-- calculateAxisExtentTests : Test
-- calculateAxisExtentTests =
--   let
--     boundingBox  = BoundingBox.create 5 95 2 97
--     range = createFromTuple (10, 90)
--     descendingRange = createFromTuple (90, 10)
--     largeRange = createFromTuple (0, 100)
--     largeDescending = createFromTuple (100, 0)
--     calculateExtent' = calculateAxisExtent boundingBox
--   in
--     suite "calculateAxisExtent"
--       [ test "for the x axis and a range fits inside the bounding box"
--           <| assertSet (10, 90)
--           <| calculateExtent' Axis.Orient.Top range
--       , test "for bottom orient and a range fits inside the bounding box"
--           <| assertSet (10, 90)
--           <| calculateExtent' Axis.Orient.Bottom range
--       , test "for left orient and a range fits inside the bounding box"
--           <| assertSet (10, 90)
--           <| calculateExtent' Axis.Orient.Left range
--       , test "for right orient and a range fits inside the bounding box"
--           <| assertSet (10, 90)
--           <| calculateExtent' Axis.Orient.Right range
--       , test "for the x axis and a descending range fits inside the bounding box"
--           <| assertSet (10, 90)
--           <| calculateExtent' Axis.Orient.Top descendingRange
--       , test "for bottom orient and a descending range fits inside the bounding box"
--           <| assertSet (10, 90)
--           <| calculateExtent' Axis.Orient.Bottom descendingRange
--       , test "for left orient and a descending range fits inside the bounding box"
--           <| assertSet (10, 90)
--           <| calculateExtent' Axis.Orient.Left descendingRange
--       , test "for right orient and a descending range fits inside the bounding box"
--           <| assertSet (10, 90)
--           <| calculateExtent' Axis.Orient.Right descendingRange
--       , test "for the x axis and a range that does not inside the bounding box"
--           <| assertSet (5, 95)
--           <| calculateExtent' Axis.Orient.Top largeRange
--       , test "for bottom orient and a range that does not inside the bounding box"
--           <| assertSet (5, 95)
--           <| calculateExtent' Axis.Orient.Bottom largeRange
--       , test "for left orient and a range that does not inside the bounding box"
--           <| assertSet (2, 97)
--           <| calculateExtent' Axis.Orient.Left largeRange
--       , test "for right orient and a range that does not inside the bounding box"
--           <| assertSet (2, 97)
--           <| calculateExtent' Axis.Orient.Right largeRange
--       , test "for the x axis and a descending range that does not inside the bounding box"
--           <| assertSet (5, 95)
--           <| calculateExtent' Axis.Orient.Top largeDescending
--       , test "for bottom orient and a descending range that does not inside the bounding box"
--           <| assertSet (5, 95)
--           <| calculateExtent' Axis.Orient.Bottom largeDescending
--       , test "for left orient and a descending range that does not inside the bounding box"
--           <| assertSet (2, 97)
--           <| calculateExtent' Axis.Orient.Left largeDescending
--       , test "for right orient and a descending range that does not inside the bounding box"
--           <| assertSet (2, 97)
--           <| calculateExtent' Axis.Orient.Right largeDescending
--       ]
--
-- calculateExtentTests : Test
-- calculateExtentTests =
--   let
--     boundingBox  = BoundingBox.create 5 95 2 97
--     set = createFromTuple (10, 90)
--     descendingSet = createFromTuple (90, 10)
--     largeSet = createFromTuple (0, 100)
--     descendingLarge = createFromTuple (100, 0)
--     calculateExtent' = calculateExtent boundingBox
--   in
--     suite "calculateAxisExtent"
--       [ test "for the x axis and a range fits inside the bounding box"
--           <| assertSet (10, 90)
--           <| calculateExtent' Scale.Type.XScale set
--       , test "for the y axis and a range fits inside the bounding box"
--           <| assertSet (10, 90)
--           <| calculateExtent' Scale.Type.YScale set
--       , test "for the x axis and a descending range fits inside the bounding box"
--           <| assertSet (90, 10)
--           <| calculateExtent' Scale.Type.XScale descendingSet
--       , test "for the y axis and a descending range fits inside the bounding box"
--           <| assertSet (90, 10)
--           <| calculateExtent' Scale.Type.YScale descendingSet
--       , test "for the x axis and a range that does not inside the bounding box"
--           <| assertSet (5, 95)
--           <| calculateExtent' Scale.Type.XScale largeSet
--       , test "for the y axis and a range that does not inside the bounding box"
--           <| assertSet (2, 97)
--           <| calculateExtent' Scale.Type.YScale largeSet
--       , test "for the x axis and a descending range that does not inside the bounding box"
--           <| assertSet (95, 5)
--           <| calculateExtent' Scale.Type.XScale descendingLarge
--       , test "for the y axis and a descending range that does not inside the bounding box"
--           <| assertSet (97, 2)
--           <| calculateExtent' Scale.Type.YScale descendingLarge
--       ]
