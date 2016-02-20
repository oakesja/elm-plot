module Test.FloatExtraTest where

import FloatExtra exposing (..)
import ElmTest exposing (..)

tests : Test
tests =
  suite "FloatExtra"
        [ roundTests
        ]

roundTests : Test
roundTests =
  suite "roundTo"
    [ test "rounding float with no decimal places"
        <| assertEqual 3 <| roundTo 3 0
    , test "rounding float with more decimal places than it has"
          <| assertEqual 3.10 <| roundTo 3.1 2
    , test "rounding float down"
          <| assertEqual 3.14 <| roundTo 3.14159 2
    , test "rounding float up"
          <| assertEqual 3.142 <| roundTo 3.14159 3
    ]
