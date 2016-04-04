module Test.Plot.InterpolationTest where

import Plot.Interpolation exposing (..)
import Private.Models exposing (Points)
import ElmTest exposing (..)

tests : Test
tests =
  suite "Line.InterpolationTest"
        [ linearTests
        ]

linearTests : Test
linearTests =
  suite "linear"
    [ test "for zero points"
      <| assertEqual ""
      <| linear []
    , test "for one point"
      <| assertEqual "1,2Z"
      <| linear (createPoints [(1, 2)])
    , test "for more than one point"
      <| assertEqual "1,2L3,4"
      <| linear (createPoints [(1, 2), (3, 4)])
    ]

createPoints : List (Float, Float) -> Points Float Float
createPoints values =
  List.map (\p -> {x = fst p, y = snd p}) values
