module Scale where

type alias Scale =
  { domain : (Float, Float)
  , range : (Float, Float)
  , rescale : Float -> Float
  }

identity : (Float, Float) -> Scale
identity domain =
  { domain = domain
  , range = domain
  , rescale = \x -> x
  }

linear : (Float, Float) -> (Float, Float) -> Scale
linear domain range =
  let
    b = if snd domain - fst domain < 0 then 1 / snd domain else snd domain - fst domain
    u = \x -> (x - fst domain) / b
    i = \x -> fst range * (1 - x) + snd range * x
    rescale = \x -> i(u x)
  in
    { domain = domain
    , range = range
    , rescale = rescale
    }
