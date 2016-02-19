import Task
import Console
import ElmTest exposing (..)
import Test.Line.InterpolationTest as InterpolationTest
import Test.AxisTest as AxisTest

tests : Test
tests =
    suite "All Tests"
        [ InterpolationTest.tests
        , AxisTest.tests
        ]

port runner : Signal (Task.Task x ())
port runner =
    Console.run (consoleRunner tests)
