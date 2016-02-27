module Test.BoundingBoxTest where

import BoundingBox
import ElmTest exposing (..)

tests : Test
tests =
  suite "BoundingBox"
        [ fromTests
        ]

fromTests : Test
fromTests =
  suite "from"
    [ test "with margins that are not too large"
        <| assertEqual { xStart = 30, xEnd = 60, yStart = 10, yEnd = 30 }
        <| BoundingBox.from { width = 100, height = 50 } { top = 10, bottom = 20, left = 30, right = 40 }
      -- test "with margins that are too large"
      --   <| assertEqual { xStart = 0, xEnd = 0, yStart = 0, yEnd = 0 }
      --     <| BoundingBox.from { width = 100, height = 50 } { top = 60, bottom = 60, left = 30, right = 40 }
    ]
