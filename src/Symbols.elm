module Symbols (circle, square, diamond, triangleUp, triangleDown) where

import Svg exposing (Svg)
import Svg.Attributes exposing (cx, cy, r, x, y, width, height, transform, d)
import Line.Interpolation exposing (linear)
import Points exposing (Points)

circle : Int -> List Svg.Attribute -> Float -> Float -> Svg
circle radius addionalAttrs x y =
  createSvg Svg.circle  addionalAttrs [cx (toString x), cy (toString y), r (toString radius)]

square : Float -> List Svg.Attribute -> Float -> Float -> Svg
square length addionalAttrs xPos yPos =
  createSvg Svg.rect addionalAttrs
    [ x <| toString (xPos - length / 2)
    , y <| toString (yPos - length / 2)
    , width <| toString length
    , height <| toString length
    ]

diamond : Float -> List Svg.Attribute -> Float -> Float -> Svg
diamond length addionalAttrs xPos yPos =
  let
    -- TODO rotation build up is repeated in axis/svg.elm
    t = transform <| "rotate(45," ++ (toString xPos) ++ "," ++ (toString yPos) ++ ")"
  in
  square length (t :: addionalAttrs) xPos yPos

triangleUp : Float -> List Svg.Attribute -> Float -> Float -> Svg
triangleUp length addionalAttrs xPos yPos =
  pathSvg addionalAttrs
      [ { x = xPos, y = yPos - length / 2 }
      , { x = xPos - length / 2, y = yPos + length / 2}
      , { x = xPos + length / 2, y = yPos + length / 2}
      ]

triangleDown : Float -> List Svg.Attribute -> Float -> Float -> Svg
triangleDown length addionalAttrs xPos yPos =
  pathSvg addionalAttrs
      [ { x = xPos, y = yPos + length / 2 }
      , { x = xPos - length / 2, y = yPos - length / 2}
      , { x = xPos + length / 2, y = yPos - length / 2}
      ]

pathSvg : List Svg.Attribute -> Points -> Svg
pathSvg addionalAttrs points =
  createSvg Svg.path addionalAttrs [ d <| "M" ++ linear points]

createSvg : (List Svg.Attribute -> List Svg -> Svg) -> List Svg.Attribute -> List Svg.Attribute -> Svg
createSvg svgFunc addionalAttrs posAttrs =
  svgFunc
    (List.append posAttrs addionalAttrs)
    []
