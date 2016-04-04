import Task
import Console
import ElmTest exposing (..)
import Test.Private.Axis.ViewTest
import Test.Private.Axis.TicksTest
import Test.Private.Axis.TitleTest
import Test.Plot.InterpolationTest
import Test.Private.Scale.LinearTest
import Test.Private.Extras.SetTest
import Test.Private.Extras.FloatTest
import Test.Private.Scale.OrdinalPointsTest
import Test.Private.Scale.OrdinalBandsTest
import Test.Private.BarsTest
import Test.Private.PointsTest
import Test.Private.LineTest
import Test.Private.PolygonTest
import Test.Private.BoundingBoxTest
import Test.Private.AreaTest
import Test.Private.RulesTest
import Test.Private.Scale.UtilsTest

-- TODO autogenerate this file
tests : Test
tests =
  suite "All Tests"
    [ Test.Private.Axis.TicksTest.tests
    , Test.Private.Axis.TitleTest.tests
    , Test.Private.Axis.ViewTest.tests
    , Test.Private.Extras.FloatTest.tests
    , Test.Plot.InterpolationTest.tests
    , Test.Private.Scale.LinearTest.tests
    , Test.Private.Scale.OrdinalBandsTest.tests
    , Test.Private.Scale.OrdinalPointsTest.tests
    , Test.Private.AreaTest.tests
    , Test.Private.BarsTest.tests
    , Test.Private.BoundingBoxTest.tests
    , Test.Private.LineTest.tests
    , Test.Private.PointsTest.tests
    , Test.Private.PolygonTest.tests
    , Test.Private.RulesTest.tests
    , Test.Private.Extras.SetTest.tests
    , Test.Private.Scale.UtilsTest.tests
    ]

port runner : Signal (Task.Task x ())
port runner =
  Console.run (consoleRunner tests)
