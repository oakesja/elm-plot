module Scale where

import Scale.Linear

type alias Scale =
  { range : (Float, Float)
  , transform : ((Float, Float) -> Float -> Float)
  , createTicks : (Int -> List Float)
  }

transform : Scale -> Float -> Float
transform scale x =
  scale.transform scale.range x

createTicks : Scale -> Int -> List Float
createTicks {createTicks} numTicks =
  createTicks numTicks

includeMargins : Float -> Float -> Scale -> Scale
includeMargins lowM highM scale =
  let
    rLow = (fst scale.range) + lowM
    rHigh = (snd scale.range) - highM
  in
    { scale | range = (rLow, rHigh) }

linear : (Float, Float) -> (Float, Float) -> Scale
linear domain range =
  { range = range
  , transform = Scale.Linear.transform domain
  , createTicks = Scale.Linear.createTicks domain
  }
