module Private.BoundingBox where

import Private.Margins exposing (Margins)
import Private.Dimensions exposing (Dimensions)

type alias BoundingBox =
  { xStart : Float
  , xEnd : Float
  , yStart : Float
  , yEnd : Float
  }

init : BoundingBox
init =
  create 0 0 0 0

create : Float -> Float -> Float -> Float -> BoundingBox
create xStart xEnd yStart yEnd =
  { xStart = xStart
  , xEnd = xEnd
  , yStart = yStart
  , yEnd = yEnd
  }

from : Dimensions -> Margins -> BoundingBox
from dim marg =
  let
    bBox = create
              marg.left
              (dim.width - marg.right)
              marg.top
              (dim.height - marg.bottom)
  in
    if bBox.xStart > bBox.xEnd then
      init
    else if bBox.yStart > bBox.yEnd then
      init
    else
      bBox
