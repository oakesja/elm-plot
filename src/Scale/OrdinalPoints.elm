module Scale.OrdinalPoints (interpolate, createTicks, createMapping, uninterpolate) where

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
  Scale.Ordinal.createTicks (mapping domain range) (\label pv -> {position = pv.value, label = label})

-- https://github.com/mbostock/d3/blob/6cc03db0de3777f034dc910a7cae2cbecb0ed099/src/scale/ordinal.js#L39
createMapping : Int -> List String -> Range -> OrdinalMapping
createMapping padding domain range =
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
