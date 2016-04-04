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
  create
    marg.left
    (dim.width - marg.right)
    marg.top
    (dim.height - marg.bottom)
