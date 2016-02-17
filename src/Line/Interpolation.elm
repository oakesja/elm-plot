module Line.Interpolation where

import Points exposing (Points)

type alias Interpolation = Points -> String

linear : Interpolation
linear points =
  List.foldr (++) "" (List.intersperse "L" (List.map (\p -> toString p.x ++ "," ++ toString p.y) points))
