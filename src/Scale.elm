module Scale where

import Scale.Linear

type alias Scale =
  { domain : (Float, Float)
  , range : (Float, Float)
  , scale : (Float, Float) -> (Float, Float) -> Float -> Float
  , createTicks : Int -> List Float
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

-- identity : (Float, Float) -> Scales
-- identity domain =
--   { domain = domain
--   , range = domain
--   , scale = identityScale
--   }

-- identityScale : (Float, Float) -> (Float, Float) -> Float -> Float
-- identityScale domain range x =
--   x

linear : (Float, Float) -> (Float, Float) -> Scale
linear domain range =
  { domain = domain
  , range = range
  , scale = Scale.Linear.scale
  , createTicks = Scale.Linear.createTicks domain
  }
