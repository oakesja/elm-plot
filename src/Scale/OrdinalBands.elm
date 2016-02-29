module Scale.OrdinalBands (interpolate, createTicks, createMapping, uninterpolate, inDomain) where

import Private.Models exposing (Tick, PointValue)
import Dict exposing (Dict)
import Sets exposing (Range)
import Scale.Ordinal exposing (..)

interpolate : (List String -> Range -> OrdinalMapping) -> List String -> Range -> String -> PointValue String
interpolate mapping domain range s =
  Scale.Ordinal.interpolate (mapping domain range) s

uninterpolate : (List String -> Range -> OrdinalMapping) -> List String -> Range -> Float -> String
uninterpolate mapping domain range x =
  Scale.Ordinal.uninterpolate (mapping domain range) x

createTicks : (List String -> Range -> OrdinalMapping) -> List String -> Range -> List Tick
createTicks mapping domain range =
  Scale.Ordinal.createTicks (mapping domain range) (\label pv -> {position = pv.value + pv.width / 2, label = label})

inDomain : List String -> String -> Bool
inDomain domain x =
  List.member x domain

-- https://github.com/mbostock/d3/blob/6cc03db0de3777f034dc910a7cae2cbecb0ed099/src/scale/ordinal.js#L61
createMapping : Float -> Float -> List String -> Range -> OrdinalMapping
createMapping padding outerPadding domain range =
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
