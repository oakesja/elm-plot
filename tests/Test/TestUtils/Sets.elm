module Test.TestUtils.Sets where

import ElmTest exposing (..)
import Extras.Set as Set exposing (..)

assertSet : (Float, Float) -> Set -> Assertion
assertSet tuple =
  assertEqual (createFromTuple tuple)
