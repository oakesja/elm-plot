module Test.Private.Extras.SetTest where

import Private.Extras.Set as Set exposing (..)
import ElmTest exposing (..)
import Test.TestUtils.Sets exposing (assertSet)

tests : Test
tests =
  suite "Private.Extras.Set"
    [ extentOfTests ]

extentOfTests : Test
extentOfTests =
  suite "extentOf"
    [ test "for a set"
        <| assertSet (0, 1)
        <| extentOf
        <| createFromTuple (0, 1)
    , test "for a reversed set"
        <| assertSet (0, 1)
        <| extentOf
        <| createFromTuple (1, 0)
    ]
