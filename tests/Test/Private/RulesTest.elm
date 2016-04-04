module Test.Private.RulesTest where

import Private.Rules exposing (..)
import Private.BoundingBox as BoundingBox exposing (BoundingBox)
import ElmTest exposing (..)
import Private.Extras.SvgAttributes exposing (x1, x2, y1, y2)
import Svg.Attributes exposing (stroke)

tests : Test
tests =
  suite "Private.Rules"
    [ lineAttrsTests ]

lineAttrsTests : Test
lineAttrsTests =
  let
    bBox = BoundingBox.create 1 10 2 8
    point = { value = 5, width = 0, originalValue = 100 }
  in
    suite "lineAttrs"
      [ test "for a vertical rule"
          <| assertEqual
              [ x1 point.value
              , y1 bBox.yStart
              , x2 point.value
              , y2 bBox.yEnd
              , stroke "black"
              ]
          <| lineAttrs bBox [] Vertical point
      , test "for a horizontal rule"
          <| assertEqual
              [ x1 bBox.xStart
              , y1 point.value
              , x2 bBox.xEnd
              , y2 point.value
              , stroke "black"
              ]
          <| lineAttrs bBox [] Horizontal point
      , test "when additonal svg attributes are used instead of the default when provided"
          <| assertEqual
              [ x1 bBox.xStart
              , y1 point.value
              , x2 bBox.xEnd
              , y2 point.value
              , stroke "red"
              ]
          <| lineAttrs bBox [stroke "red"] Horizontal point
      ]
