module Private.Dimensions where

type alias Dimensions = {width: Float, height: Float}

create : Float -> Float -> Dimensions
create w h =
  { width = w
  , height = h
  }
