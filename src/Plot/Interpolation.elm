module Plot.Interpolation (Interpolation, linear) where

import Private.Models exposing (Points)

type alias Interpolation = Points Float Float -> String

linear : Interpolation
linear points =
  let
    pointStrings = List.map (\p -> toString p.x ++ "," ++ toString p.y) points
  in
    if List.length points == 1 then
      join pointStrings ++ "Z"
    else
      join (List.intersperse "L" pointStrings)

join : List String -> String
join list =
  List.foldr (++) "" list
