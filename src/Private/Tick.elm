module Private.Tick where

type alias Tick =
  { position : Float
  , label : String
  }

create : Float -> String -> Tick
create position label =
  { position = position
  , label = label
  }
