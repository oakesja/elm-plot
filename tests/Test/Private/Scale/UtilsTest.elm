module Test.Private.Scale.UtilsTest where

import Private.Scale.Utils exposing (..)
import ElmTest exposing (..)
import Test.TestUtils.Sets exposing (assertSet)
import Private.BoundingBox as BoundingBox
import Private.Extras.Set as Set

tests : Test
tests =
  suite "Private.Scale.Utils"
    [ calculateExtentTests ]

calculateExtentTests : Test
calculateExtentTests =
  let
    boundingBox  = BoundingBox.create 5 95 2 97
    set = Set.createFromTuple (10, 90)
    descendingSet = Set.createFromTuple (90, 10)
    largeSet = Set.createFromTuple (0, 100)
    descendingLarge = Set.createFromTuple (100, 0)
    calculateExtent' = calculateExtent boundingBox
  in
    suite "calculateAxisExtent"
      [ test "for the x axis and a range fits inside the bounding box"
          <| assertSet (10, 90)
          <| calculateExtent' XScale set
      , test "for the y axis and a range fits inside the bounding box"
          <| assertSet (10, 90)
          <| calculateExtent' YScale set
      , test "for the x axis and a descending range fits inside the bounding box"
          <| assertSet (90, 10)
          <| calculateExtent' XScale descendingSet
      , test "for the y axis and a descending range fits inside the bounding box"
          <| assertSet (90, 10)
          <| calculateExtent' YScale descendingSet
      , test "for the x axis and a range that does not inside the bounding box"
          <| assertSet (5, 95)
          <| calculateExtent' XScale largeSet
      , test "for the y axis and a range that does not inside the bounding box"
          <| assertSet (2, 97)
          <| calculateExtent' YScale largeSet
      , test "for the x axis and a descending range that does not inside the bounding box"
          <| assertSet (95, 5)
          <| calculateExtent' XScale descendingLarge
      , test "for the y axis and a descending range that does not inside the bounding box"
          <| assertSet (97, 2)
          <| calculateExtent' YScale descendingLarge
      ]
