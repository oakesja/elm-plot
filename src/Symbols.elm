module Symbols (circle, square, diamond, triangleUp, triangleDown) where

import Svg exposing (Svg)
import Svg.Attributes exposing (d)
import Line.Interpolation exposing (linear)
import Private.Models exposing (Points)
import SvgAttributesExtra exposing (rotate, cx, cy, r, x, y, width, height)

circle : Int -> List Svg.Attribute -> Float -> Float -> Svg
circle radius addionalAttrs x y =
  createSvg Svg.circle  addionalAttrs [cx x, cy y, r radius]

square : Float -> List Svg.Attribute -> Float -> Float -> Svg
square length addionalAttrs xPos yPos =
  createSvg Svg.rect addionalAttrs
    [ x (xPos - length / 2)
    , y (yPos - length / 2)
    , width length
    , height length
    ]

diamond : Float -> List Svg.Attribute -> Float -> Float -> Svg
diamond length addionalAttrs xPos yPos =
  square length ((rotate (xPos, yPos) 45) :: addionalAttrs) xPos yPos

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

pathSvg : List Svg.Attribute -> Points Float Float -> Svg
pathSvg addionalAttrs points =
  createSvg Svg.path addionalAttrs [ d <| "M" ++ linear points]

createSvg : (List Svg.Attribute -> List Svg -> Svg) -> List Svg.Attribute -> List Svg.Attribute -> Svg
createSvg svgFunc addionalAttrs posAttrs =
  svgFunc
    (List.append posAttrs addionalAttrs)
    []
