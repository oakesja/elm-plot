import Task
import Console
import ElmTest exposing (..)
import Test.Line.InterpolationTest as InterpolationTest

tests : Test
tests =
    suite "All Tests"
        [ InterpolationTest.tests
        ]

port runner : Signal (Task.Task x ())
port runner =
    Console.run (consoleRunner tests)
