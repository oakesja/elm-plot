module Test.PolygonTest where

import Polygon exposing (..)
import Private.Models exposing (BoundingBox)
import ElmTest exposing (..)

tests : Test
tests =
  suite "Polygon"
    [ clipTests
    ]

clipTests : Test
clipTests =
  let
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
        <| assertEqual []
        <| clip' [(0, 0), (1, 0), (0, -1)]
    ]

getPoints : List Point -> List (Float, Float)
getPoints points =
  List.map (\p -> (p.x, p.y)) points

createPoint : (Float, Float) -> Point
createPoint p =
  Point (fst p) (snd p)

bBox : BoundingBox
bBox =
  { xStart = 1
  , xEnd = 3
  , yStart = 1
  , yEnd = 3
  }

assertList : List comparable -> List comparable -> Assertion
assertList expected actual =
  assertEqual (List.sort expected) (List.sort actual)
