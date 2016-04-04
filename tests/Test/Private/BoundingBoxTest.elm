module Test.Private.BoundingBoxTest where

import Private.BoundingBox as BoundingBox
import Private.Dimensions as Dimensions
import ElmTest exposing (..)

tests : Test
tests =
  suite "Private.BoundingBox"
    [ fromTests ]

fromTests : Test
fromTests =
  let
    dims = Dimensions.create 100 50
  in
    suite "from"
      [ test "with margins that are not too large"
          <| assertEqual (BoundingBox.create 30 60 10 30)
          <| BoundingBox.from dims { left = 30, right = 40, top = 10, bottom = 20 }
      , test "horizontal margins that are too large"
          <| assertEqual (BoundingBox.create 0 0 0 0)
          <| BoundingBox.from dims { left = 60, right = 45, top = 10, bottom = 20 }
      , test "vertical margins that are too large"
          <| assertEqual (BoundingBox.create 0 0 0 0)
          <| BoundingBox.from dims { left = 30, right = 40, top = 30, bottom = 40 }
      ]
