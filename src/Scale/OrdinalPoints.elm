module Scale.OrdinalPoints (interpolate, createTicks, createMapping, uninterpolate) where

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
  Scale.Ordinal.createTicks (mapping range) (\label pv -> {position = pv.value, label = label})

-- https://github.com/mbostock/d3/blob/6cc03db0de3777f034dc910a7cae2cbecb0ed099/src/scale/ordinal.js#L39
createMapping : List String -> Int -> Range -> OrdinalMapping
createMapping domain padding range =
  let
    start = fst range
    stop = snd range
    step = calculateStep domain padding start stop
    adjustedStart = adjustStart domain padding start step
  in
    { lookup = buildLookup adjustedStart step 0 domain Dict.empty
    , stepSize = step
    }

calculateStep : List String -> Int -> Float -> Float -> Float
calculateStep domain padding start stop =
  if List.length domain < 2 then
    toFloat <| round <| (start + stop) / 2
  else
    toFloat <| floor <| (stop - start) / toFloat (List.length domain - 1 + padding)

adjustStart : List String -> Int -> Float -> Float -> Float
adjustStart domain padding start step =
  if List.length domain < 2 then
    step
  else
    start + step * (toFloat padding) / 2
