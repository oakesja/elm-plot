module Test.TestUtils.Point where

import Private.Models exposing (Point)

createPoints : List (Float, Float) -> List (Point Float Float)
createPoints points =
  List.map createPoint points

createPoint : (Float, Float) -> Point Float Float
createPoint point =
  Point (fst point) (snd point)
