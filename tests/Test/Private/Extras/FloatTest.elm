module Test.Private.Extras.FloatTest where

import Private.Extras.Float exposing (..)
import ElmTest exposing (..)

tests : Test
tests =
  suite "FloatExtra"
    [ lnTests
    , roundTests
    ]

lnTests : Test
lnTests =
  suite "ln"
    [ test "ln of anything < 0"
        <| assert (isInfinite (ln 0))
    , test "ln 1 = 0"
        <| assertEqual 0
        <| ln 1
    , test "greater than 0 and != 1"
        <| assertEqual 1.609
        <| roundTo (ln 5) 3
    ]

roundTests : Test
roundTests =
  suite "roundTo"
    [ test "rounding float with no decimal places"
        <| assertEqual 3 (roundTo 3 0)
    , test "rounding float with more decimal places than it has"
        <| assertEqual 3.10 (roundTo 3.1 2)
    , test "rounding float down"
        <| assertEqual 3.14 (roundTo 3.14159 2)
    , test "rounding float up"
        <| assertEqual 3.142 (roundTo 3.14159 3)
    , test "when given a negative number returns the number"
        <| assertEqual 3 (roundTo 3 -1)
    ]
