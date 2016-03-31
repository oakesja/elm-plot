module Private.Models where

-- TODO move somewhere else
type alias Point a b = {x: a, y: b}
type alias PointValue a = { value: Float, width: Float, originalValue : a }
type alias InterpolatedPoint a b = {x: PointValue a, y: PointValue b}
type alias Points a b = List (Point a b)
type alias InterpolatedPoints a b = List (InterpolatedPoint a b)
type alias Path a b = List (Point a b)
