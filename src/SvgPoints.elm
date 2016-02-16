module SvgPoints where

import SvgPoint exposing (SvgPoint)
import Scale exposing (Scale)
import Svg exposing (Svg)

type alias SvgPoints = List SvgPoint

rescale : Scale -> Scale -> SvgPoints -> SvgPoints
rescale xScale yScale points =
  List.map (SvgPoint.rescale xScale yScale) points

toHtml : SvgPoints -> List Svg
toHtml points =
  List.map SvgPoint.toHtml points
