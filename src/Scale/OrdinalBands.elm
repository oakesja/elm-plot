module Scale.OrdinalBands (interpolate, createTicks, createMapping, uninterpolate) where

import Private.Models exposing (Tick, PointValue)
import Dict exposing (Dict)
import Sets exposing (Range)
import Scale.Ordinal exposing (..)

interpolate : (Range -> OrdinalMapping) -> Range -> String -> PointValue String
interpolate mapping range s =
  Scale.Ordinal.interpolate (mapping range) s

uninterpolate : (Range -> OrdinalMapping) -> Range -> Float -> String
uninterpolate mapping range x =
  Scale.Ordinal.uninterpolate (mapping range) x

createTicks : (Range -> OrdinalMapping) -> Range -> List Tick
createTicks mapping range =
  Scale.Ordinal.createTicks (mapping range) (\label pv -> {position = pv.value + pv.width / 2, label = label})

-- https://github.com/mbostock/d3/blob/6cc03db0de3777f034dc910a7cae2cbecb0ed099/src/scale/ordinal.js#L61
createMapping : List String -> Float -> Float -> Range -> OrdinalMapping
createMapping domain padding outerPadding range =
  let
    start = min (fst range) (snd range)
    stop = max (fst range) (snd range)
    step = (stop - start) / ((toFloat <| List.length domain) - padding + 2 * outerPadding)
    bandWidth = abs <| step * (1 - padding)
    adjStart = start + step * outerPadding
    adjDomain =
      if (fst range) < (snd range) then
        domain
      else
        List.reverse domain
  in
    { lookup = buildLookup adjStart step bandWidth adjDomain Dict.empty
    , stepSize = step
    }
