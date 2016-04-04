module Test.Plot.InterpolationTest where

import Plot.Interpolation exposing (..)
import ElmTest exposing (..)
import Test.TestUtils.Point exposing (createPoints)

tests : Test
tests =
  suite "Plot.Interpolation"
    [ linearTests ]

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
