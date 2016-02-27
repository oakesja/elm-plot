module Test.BarsTest where

import Bars exposing (..)
import ElmTest exposing (..)
import Svg.Attributes exposing (x, y, width, height, stroke)

tests : Test
tests =
  suite "BoundingBox"
    [ barAttrsTests
    ]

barAttrsTests : Test
barAttrsTests =
  let
    point =
      { x = {value = 50, width = 20, originalValue = 5}
      , y = {value = 40, width = 10, originalValue = 4}
      }
    boundingBox =
      { xStart = 10
      , xEnd = 90
      , yStart = 20
      , yEnd = 100
      }
  in
    suite "barAttrs"
      [ test "for a top orient"
          <| assertEqual [x "50", y "40", width "20", height "60"]
          <| barAttrs boundingBox Bars.Vertical [] point
      , test "for a vertical orient"
          <| assertEqual [x "10", y "40", width "40", height "10"]
          <| barAttrs boundingBox Bars.Horizontal [] point
      , test "additional svg attributes are added to the position attributes"
          <| assertEqual [x "10", y "40", width "40", height "10", stroke "red"]
          <| barAttrs boundingBox Bars.Horizontal [stroke "red"] point
      ]
