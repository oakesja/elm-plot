module Private.Margins where

type alias Margins =
  { top: Float
  , bottom: Float
  , right: Float
  , left: Float
  }

create : Float -> Float -> Float -> Float -> Margins
create top right bottom left =
  { top = top
  , right = right
  , bottom = bottom
  , left = left
  }

init : Margins
init =
  create 50 50 50 50
