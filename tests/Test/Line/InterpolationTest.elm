module Test.Line.InterpolationTest where

import Line.Interpolation exposing (..)
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
    , test "for one point" <| assertEqual "1,2Z" <| linear [{x = 1, y = 2}]
    , test "for more than one point" <| assertEqual "1,2L3,4" <| linear [{x = 1, y = 2}, {x = 3, y = 4}]
    ]
