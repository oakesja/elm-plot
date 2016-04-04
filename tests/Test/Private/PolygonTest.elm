module Test.Private.PolygonTest where

import Private.Polygon exposing (..)
import Private.BoundingBox as BoundingBox exposing (BoundingBox)
import ElmTest exposing (..)
import Test.TestUtils.Point exposing (createPoint)
import Private.Point exposing (Point)

tests : Test
tests =
  suite "Private.Polygon"
    [ clipTests ]

clipTests : Test
clipTests =
  let
    bBox = BoundingBox.create 1 3 1 3
    clip' = (\pts -> getPoints (clip bBox (List.map createPoint pts)))
  in
    suite "clip"
      [ test "for a polygon that is totally inside the bounding box"
          <| assertList [(2, 1), (3, 2), (2, 3), (1, 2)]
          <| clip' [(2, 1), (3, 2), (2, 3), (1, 2)]
      , test "for a polygon that enters and leaves the bounding box"
          <| assertList [(2, 2), (3, 1), (3, 3)]
          <| clip' [(2, 2), (4, 0), (4, 4)]
      , test "for a polygon that is outside the bounding box the bounding box"
          <| assertList []
          <| clip' [(0, 0), (1, 0), (0, -1)]
      ]

getPoints : List (Point Float Float) -> List (Float, Float)
getPoints points =
  List.map (\p -> (p.x, p.y)) points

assertList : List comparable -> List comparable -> Assertion
assertList expected actual =
  assertEqual (List.sort expected) (List.sort actual)
