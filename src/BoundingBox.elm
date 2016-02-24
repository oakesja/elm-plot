module BoundingBox where

import Private.Models exposing (Dimensions, Margins, BoundingBox)

from : Dimensions -> Margins -> BoundingBox
from dim marg =
  { xStart = marg.left
  , xEnd = dim.width - marg.right
  , yStart = marg.top
  , yEnd = dim.height - marg.bottom
  }
