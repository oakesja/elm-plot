module Test.Private.AreaTest where

import Private.Area exposing (..)
import ElmTest exposing (..)
import Private.BoundingBox as BoundingBox
import Plot.Scale as Scale
import Plot.Interpolation exposing (linear)
import Test.TestUtils.Point exposing (createPoints)

tests : Test
tests =
  suite "Private.Area"
    [ interpolateTests
    , pathStringTests
    ]

interpolateTests : Test
interpolateTests =
  let
    xScale = Scale.linear (0, 3) (0, 300) 0
    yScale = Scale.linear (0, 3) (0, 300) 0
  in
    suite "interpolate"
      [ test "it interpolates the given area to the points within the range"
          <| assertEqual (createPoints [(200, 100), (300, 200), (300, 200), (200, 300)])
          <| interpolate (BoundingBox.create 100 300 100 300) xScale yScale [{ x = 2, y = 1, y2 = 3 }, { x = 3, y = 2, y2 = 2 }]
      ]

pathStringTests : Test
pathStringTests =
  suite "pathString"
    [ test "it returns the path string for a list of points"
        <| assertEqual "M0,1L2,0Z"
        <| pathString linear (createPoints [(0, 1), (2, 0)])
    , test "it handles a list of one point"
        <| assertEqual "M0,1Z"
        <| pathString linear (createPoints [(0,1)])
    , test "it returns the empty string for an emtpy list"
        <| assertEqual ""
        <| pathString linear []
    ]
