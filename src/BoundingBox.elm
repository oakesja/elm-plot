module BoundingBox where

import Dimensions exposing (Dimensions, Margins)

type alias BoundingBox =
  { xStart : Float
  , xEnd : Float
  , yStart : Float
  , yEnd : Float
  }

from : Dimensions -> Margins -> BoundingBox
from dim marg =
  { xStart = marg.left
  , xEnd = dim.width - marg.right
  , yStart = marg.top
  , yEnd = dim.height - marg.bottom
  }
