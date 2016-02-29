import Task
import Console
import ElmTest exposing (..)
import Test.Line.InterpolationTest as InterpolationTest
import Test.Scale.LinearTest as ScaleLinearTest
import Test.Axis.ViewTest as AxisViewTest
import Test.Axis.TicksTest as TicksTest
import Test.Axis.TitleTest as TitleTest
import Test.SetsTest as SetsTest
import Test.FloatExtraTest as FloatExtraTest
import Test.Scale.OrdinalPointsTest as OrdinalPointsTest
import Test.Scale.OrdinalBandsTest as OrdinalBandsTest
import Test.BarsTest as BarsTest
import Test.PointsTest as PointsTest

tests : Test
tests =
    suite "All Tests"
        [ InterpolationTest.tests
        , AxisViewTest.tests
        , TicksTest.tests
        , TitleTest.tests
        , SetsTest.tests
        , ScaleLinearTest.tests
        , FloatExtraTest.tests
        , OrdinalPointsTest.tests
        , OrdinalBandsTest.tests
        , BarsTest.tests
        , PointsTest.tests
        ]

port runner : Signal (Task.Task x ())
port runner =
    Console.run (consoleRunner tests)
