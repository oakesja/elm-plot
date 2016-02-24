module Test.Line.InterpolationTest where

import Line.Interpolation exposing (..)
import Private.Models exposing (TransformedPoints)
import ElmTest exposing (..)

tests : Test
tests =
  suite "Line.InterpolationTest"
        [ linearTests
        ]

linearTests : Test
linearTests =
  suite "linear"
    [ test "for zero points" <| assertEqual "" <| linear []
    , test "for one point" <| assertEqual "1,2Z" <| linear <| createPoints [(1, 2)]
    , test "for more than one point" <| assertEqual "1,2L3,4" <| linear <| createPoints [(1, 2), (3, 4)]
    ]

createPoints : List (Float, Float) -> TransformedPoints
createPoints values =
  List.map (\p -> {x = {value = fst p, bandWidth = 0}, y = {value = snd p, bandWidth = 0}}) values
