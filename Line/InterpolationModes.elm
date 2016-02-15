module Line.InterpolationModes where

type alias InterpolationMode = List {x : Float, y : Float} -> String

linear : InterpolationMode
linear points =
  List.foldr (++) "" (List.intersperse "L" (List.map (\p -> toString p.x ++ "," ++ toString p.y) points))
