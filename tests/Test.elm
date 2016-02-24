import Task
import Console
import ElmTest exposing (..)
import Test.Line.InterpolationTest as InterpolationTest
import Test.Scale.LinearTest as ScaleLinearTest
import Test.Axis.AxisTest as AxisTest
import Test.Axis.TicksTest as TicksTest
import Test.Axis.TitleTest as TitleTest
import Test.Axis.ExtentTest as ExtentTest
import Test.FloatExtraTest as FloatExtraTest
import Test.Scale.OrdinalPointsTest as OrdinalPointsTest
import Test.Scale.OrdinalBandsTest as OrdinalBandsTest

tests : Test
tests =
    suite "All Tests"
        [ InterpolationTest.tests
        , AxisTest.tests
        , TicksTest.tests
        , TitleTest.tests
        , ExtentTest.tests
        , ScaleLinearTest.tests
        , FloatExtraTest.tests
        , OrdinalPointsTest.tests
        , OrdinalBandsTest.tests
        ]

port runner : Signal (Task.Task x ())
port runner =
    Console.run (consoleRunner tests)
