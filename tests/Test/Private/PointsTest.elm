module Test.Private.PointsTest where

import Private.Points exposing (..)
import ElmTest exposing (..)
import Plot.Scale as Scale

tests : Test
tests =
  suite "Private.Points"
        [ interpolateTests ]

interpolateTests : Test
interpolateTests =
  let
    xScale = Scale.linear (0, 1) (0, 1) 0
    yScale = Scale.linear (0, 1) (0, 1) 0
    interpolate' = \points -> List.length (interpolate xScale yScale points)
  in
    suite "interpolate"
      [ test "points within the domain of the x and y scale are not filtered out"
          <| assertEqual 2
          <| interpolate' [{ x = 1, y = 1 }, { x = 0.5, y = 0.5 }]
      , test "points ouside of the x domain are filtered out"
          <| assertEqual 0
          <| interpolate' [{ x = 1.5, y = 1 }, { x = -1, y = 1 }]
      , test "points ouside of the y domain are filtered out"
          <| assertEqual 0
          <| interpolate' [{ x = 1, y = 1.5 }, { x = 1, y = -1 }]
      ]
