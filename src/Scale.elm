module Scale where

type alias Scale =
  { domain : (Float, Float)
  , range : (Float, Float)
  , scale : (Float, Float) -> (Float, Float) -> Float -> Float
  }

scale : Scale -> Float -> Float
scale s x =
  s.scale s.domain s.range x

includeMargins : Float -> Float -> Scale -> Scale
includeMargins lowM highM scale =
  let
    rLow = (fst scale.range) + lowM
    rHigh = (snd scale.range) - highM
  in
    { scale | range = (rLow, rHigh) }

identity : (Float, Float) -> Scale
identity domain =
  { domain = domain
  , range = domain
  , scale = identityScale
  }

identityScale : (Float, Float) -> (Float, Float) -> Float -> Float
identityScale domain range x =
  x

linear : (Float, Float) -> (Float, Float) -> Scale
linear domain range =
  { domain = domain
  , range = range
  , scale = linearScale
  }

linearScale : (Float, Float) -> (Float, Float) -> Float -> Float
linearScale domain range x =
  let
    b = if snd domain - fst domain < 0 then 1 / snd domain else snd domain - fst domain
    u = \x -> (x - fst domain) / b
    i = \x -> fst range * (1 - x) + snd range * x
  in
    i (u x)
