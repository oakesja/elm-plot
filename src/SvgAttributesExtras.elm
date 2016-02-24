module SvgAttributesExtras where

import Svg
import Svg.Attributes exposing (transform)

translate : (number, number) -> Svg.Attribute
translate pos =
  transform <| "translate(" ++ (toString (fst pos)) ++ "," ++ (toString (snd pos)) ++ ")"

rotate : (number, number) -> Int -> Svg.Attribute
rotate pos rotation =
  transform <| "rotate(" ++ (toString rotation) ++ "," ++ (toString (fst pos)) ++ "," ++ (toString (snd pos)) ++ ")"
