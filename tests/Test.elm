import Task
import Console
import ElmTest exposing (..)
import Test.Axis.ViewTest
import Test.Axis.TicksTest
import Test.Axis.TitleTest
import Test.Line.InterpolationTest
import Test.Scale.LinearTest
import Test.SetsTest
import Test.Extras.FloatTest
import Test.Scale.OrdinalPointsTest
import Test.Scale.OrdinalBandsTest
import Test.BarsTest
import Test.PointsTest
import Test.LineTest
import Test.PolygonTest
import Test.BoundingBoxTest
import Test.AreaTest
import Test.RulesTest

-- TODO autogenerate this
tests : Test
tests =
  suite "All Tests"
    [ Test.Axis.TicksTest.tests
    , Test.Axis.TitleTest.tests
    , Test.Axis.ViewTest.tests
    , Test.Extras.FloatTest.tests
    , Test.Line.InterpolationTest.tests
    , Test.Scale.LinearTest.tests
    , Test.Scale.OrdinalBandsTest.tests
    , Test.Scale.OrdinalPointsTest.tests
    , Test.AreaTest.tests
    , Test.BarsTest.tests
    , Test.BoundingBoxTest.tests
    , Test.LineTest.tests
    , Test.PointsTest.tests
    , Test.PolygonTest.tests
    , Test.RulesTest.tests
    , Test.SetsTest.tests
    ]

port runner : Signal (Task.Task x ())
port runner =
  Console.run (consoleRunner tests)
