module Test.LineTest where

import Line exposing (..)
import BoundingBox exposing (BoundingBox)
import ElmTest exposing (..)

tests : Test
tests =
  suite "Line"
        [ clipPathTests
        , clipTests
        ]

clipPathTests : Test
clipPathTests =
  let
    clipPath' = \pts -> clipPath bBox (List.map createPoint pts)
  in
    suite "clipPath"
        [ test "when all lines in the path do not need to be clipped"
            <| assertPoints [[(1, 1), (1.5, 1.5), (2, 2)]]
            <| clipPath' [(1, 1), (1.5, 1.5), (2, 2)]
        , test "when some of the lines are outside of the bounding box"
            <| assertPoints [[(1.5, 1), (2, 1.5)]]
            <| clipPath' [(1.5, 1), (2.5, 2), (3, 3)]
        , test "when a path is split in two because parts of two lines are outside the bounding box"
            <| assertPoints [[(1.5, 1), (2, 1.25)], [(2, 1.75), (1.5, 2)]]
            <| clipPath' [(1.5, 1), (2.5, 1.5), (1.5, 2)]
        , test "when a path is split in two because a line is outside the bounding box"
            <| assertPoints [[(1.5, 1), (2, 1.5)], [(2, 1.5), (1.5, 2)]]
            <| clipPath' [(1.5, 1), (2.5, 2), (2.5, 1), (1.5, 2) ]
        ]

assertPoints : List (List (Float, Float)) -> List (List Point) -> Assertion
assertPoints points actual =
  assertEqual (List.map (List.map createPoint) points) actual

createPoint : (Float, Float) -> Point
createPoint p =
  Point (fst p) (snd p)

clipTests : Test
clipTests =
  let
    clip' = (\p1 p2 -> getPoints (clip bBox (line p1 p2)))
  in
    suite "clip"
      [ test "for a line that intersects the left edge"
          <| assertEqual ((1.5, 1), (2, 1.5))
          <| clip' (1.5, 1) (2.5, 2)
      , test "for a line that intersects the right edge"
          <| assertEqual ((1.5, 1), (1, 1.5))
          <| clip' (1.5, 1) (0.5, 2)
      , test "for a line that intersects the top edge"
          <| assertEqual ((1, 1.5), (1.5, 2))
          <| clip' (1, 1.5) (2.5, 3)
      , test "for a horizontal line outside of the bounding box"
          <| assertEqual Nothing
          <| clip bBox (line (0, 0) (0, 1))
      , test "for a vertical line outside of the bounding box"
          <| assertEqual Nothing
          <| clip bBox (line (1, 0) (2, 0))
      , test "for a line outside of the bounding box"
          <| assertEqual Nothing
          <| clip bBox (line (-1, -1) (0, 0))
      ]

getPoints : Maybe Line -> ((Float, Float), (Float, Float))
getPoints line =
  case line of
    Nothing ->
      ((0, 0), (0, 0))
    Just line ->
      ((line.p0.x, line.p0.y), (line.p1.x, line.p1.y))

line : (Float, Float) -> (Float, Float) -> Line
line p1 p2 =
  Line (createPoint p1) (createPoint p2)

bBox : BoundingBox
bBox =
  BoundingBox.create 1 2 1 2
