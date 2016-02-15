module Scale where


identity : Float -> Float
identity point =
  point

linear : (Float, Float) -> (Float, Float) -> Float -> Float
linear domain range p =
  let
    u = \x -> (x - fst domain) / snd domain
    i = \x -> fst range * (1 - x) + snd range * x
  in
    i(u p)
