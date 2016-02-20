import Task
import Console
import ElmTest exposing (..)
import Test.Line.InterpolationTest as InterpolationTest
import Test.Scale.LinearTest as ScaleLinearTest
import Test.AxisTest as AxisTest
import Test.FloatExtraTest as FloatExtraTest

tests : Test
tests =
    suite "All Tests"
        [ InterpolationTest.tests
        , AxisTest.tests
        , ScaleLinearTest.tests
        , FloatExtraTest.tests
        ]

port runner : Signal (Task.Task x ())
port runner =
    Console.run (consoleRunner tests)
