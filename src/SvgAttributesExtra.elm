module SvgAttributesExtra where

import Svg
import Svg.Attributes exposing (transform)

translate : (number, number) -> Svg.Attribute
translate pos =
  transform <| "translate(" ++ (toString (fst pos)) ++ "," ++ (toString (snd pos)) ++ ")"

rotate : (number, number) -> Int -> Svg.Attribute
rotate pos rotation =
  transform <| "rotate(" ++ (toString rotation) ++ "," ++ (toString (fst pos)) ++ "," ++ (toString (snd pos)) ++ ")"

x1 : number -> Svg.Attribute
x1 x =
  Svg.Attributes.x1 (toString x)

y1 : number -> Svg.Attribute
y1 y =
  Svg.Attributes.y1 (toString y)

x2 : number -> Svg.Attribute
x2 x =
  Svg.Attributes.x2 (toString x)

y2 : number -> Svg.Attribute
y2 y =
  Svg.Attributes.y2 (toString y)

x : number -> Svg.Attribute
x num =
  Svg.Attributes.x (toString num)

y : number -> Svg.Attribute
y num =
  Svg.Attributes.y (toString num)

width : number -> Svg.Attribute
width w =
  Svg.Attributes.width (toString w)

height : number -> Svg.Attribute
height h =
  Svg.Attributes.height (toString h)

cx : number -> Svg.Attribute
cx num =
  Svg.Attributes.cx (toString num)

cy : number -> Svg.Attribute
cy num =
  Svg.Attributes.cy (toString num)

r : number -> Svg.Attribute
r num =
  Svg.Attributes.r (toString num)
