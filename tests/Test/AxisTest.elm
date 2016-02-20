module Test.AxisTest where

import Axis exposing (..)
import Scale
import ElmTest exposing (..)

tests : Test
tests =
  suite "Axis"
        [ pathStringTests
        ]

pathStringTests : Test
pathStringTests =
  let
    scale = Scale.linear (10, 90) (10, 90)
    boundingBox =
      { xStart = 5
      , xEnd = 95
      , yStart = 2
      , yEnd = 100
      }
  in
    suite "pathString"
      [ test "for top orient"
          <| assertEqual "M10,-4V2H90V-4" <| pathString boundingBox scale Top
      , test "for bottom orient"
        <| assertEqual "M10,106V100H90V106" <| pathString boundingBox scale Bottom
      , test "for left orient"
        <| assertEqual "M-1,10H5V90H-1" <| pathString boundingBox scale Left
      , test "for right orient"
        <| assertEqual "M101,10H95V90H101" <| pathString boundingBox scale Right
      ]
