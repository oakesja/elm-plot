module Plot.Symbols (circle, square, diamond, triangleUp, triangleDown, cross) where

import Svg exposing (Svg, g, line)
import Svg.Attributes exposing (d, stroke, strokeWidth)
import Plot.Interpolation exposing (linear)
import Private.Models exposing (Points)
import Private.Extras.SvgAttributes exposing (rotate, cx, cy, r, x, y, width, height, x1, x2, y1, y2)

circle : Int -> List Svg.Attribute -> Float -> Float -> a -> b -> Svg
circle radius additionalAttrs xPos yPos origX origY =
  createSvg Svg.circle additionalAttrs
    [ cx xPos
    , cy yPos
    , r radius
    ]

square : Float -> List Svg.Attribute -> Float -> Float -> a -> b -> Svg
square length additionalAttrs xPos yPos origX origY =
  createSvg Svg.rect additionalAttrs
    [ x (xPos - length / 2)
    , y (yPos - length / 2)
    , width length
    , height length
    ]

diamond : Float -> List Svg.Attribute -> Float -> Float -> a -> b -> Svg
diamond length additionalAttrs xPos yPos origX origY =
  let
    attrs = (rotate (xPos, yPos) 45) :: additionalAttrs
  in
    square length attrs xPos yPos origX origY

triangleUp : Float -> List Svg.Attribute -> Float -> Float -> a -> b -> Svg
triangleUp length additionalAttrs xPos yPos origX origY =
  pathSvg additionalAttrs
      [ { x = xPos, y = yPos - length / 2 }
      , { x = xPos - length / 2, y = yPos + length / 2}
      , { x = xPos + length / 2, y = yPos + length / 2}
      ]

triangleDown : Float -> List Svg.Attribute -> Float -> Float -> a -> b -> Svg
triangleDown length additionalAttrs xPos yPos origX origY =
  pathSvg additionalAttrs
      [ { x = xPos, y = yPos + length / 2 }
      , { x = xPos - length / 2, y = yPos - length / 2}
      , { x = xPos + length / 2, y = yPos - length / 2}
      ]

cross : Float -> List Svg.Attribute -> Float -> Float -> a -> b -> Svg
cross length additionalAttrs xPos yPos origX origY =
  let
    attrs =
      if List.isEmpty additionalAttrs then
        [ stroke "black" ]
      else
        additionalAttrs
  in
    g
      additionalAttrs
      [ line
          ( [ x1 (xPos - length / 2)
            , y1 (yPos - length / 2)
            , x2 (xPos + length / 2)
            , y2 (yPos + length / 2)
            ] ++ attrs )
          []
      , line
          ( [ x1 (xPos - length / 2)
            , y1 (yPos + length / 2)
            , x2 (xPos + length / 2)
            , y2 (yPos - length / 2)
            ] ++ attrs )
          []
      ]

pathSvg : List Svg.Attribute -> Points Float Float -> Svg
pathSvg additionalAttrs points =
  createSvg Svg.path additionalAttrs [ d ("M" ++ linear points) ]

createSvg : (List Svg.Attribute -> List Svg -> Svg) -> List Svg.Attribute -> List Svg.Attribute -> Svg
createSvg svgFunc additionalAttrs posAttrs =
  svgFunc
    (List.append posAttrs additionalAttrs)
    []
