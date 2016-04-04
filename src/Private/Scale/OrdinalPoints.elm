module Private.Scale.OrdinalPoints (interpolate, createTicks, createMapping, uninterpolate, inDomain) where

import Private.PointValue exposing (PointValue)
import Private.Tick as Tick exposing (Tick)
import Dict exposing (Dict)
import Private.Extras.Set exposing (Set)
import Private.Scale.Ordinal as OrdinalScale exposing (OrdinalMapping)

interpolate : (List String -> Set -> OrdinalMapping) -> List String -> Set -> String -> PointValue String
interpolate mapping domain range s =
  OrdinalScale.interpolate (mapping domain range) s

uninterpolate : (List String -> Set -> OrdinalMapping) -> List String -> Set -> Float -> String
uninterpolate mapping domain range x =
  OrdinalScale.uninterpolate (mapping domain range) x

createTicks : (List String -> Set -> OrdinalMapping) -> List String -> Set -> List Tick
createTicks mapping domain range =
  OrdinalScale.createTicks
    (mapping domain range)
    (\label pv -> Tick.create pv.value label)

inDomain : List String -> String -> Bool
inDomain domain x =
  List.member x domain

-- https://github.com/mbostock/d3/blob/6cc03db0de3777f034dc910a7cae2cbecb0ed099/src/scale/ordinal.js#L39
createMapping : Int -> List String -> Set -> OrdinalMapping
createMapping padding domain range =
  let
    start = range.start
    stop = range.end
    step = calculateStep domain padding start stop
    adjustedStart = adjustStart domain padding start step
  in
    { lookup = OrdinalScale.buildLookup adjustedStart step 0 domain Dict.empty
    , stepSize = step
    }

calculateStep : List String -> Int -> Float -> Float -> Float
calculateStep domain padding start stop =
  if List.length domain < 2 then
    toFloat (round (start + stop)) / 2
  else
    toFloat (floor ((stop - start) / toFloat (List.length domain - 1 + padding)))

adjustStart : List String -> Int -> Float -> Float -> Float
adjustStart domain padding start step =
  if List.length domain < 2 then
    step
  else
    start + step * (toFloat padding) / 2
