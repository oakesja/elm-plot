module Scale.OrdinalPoints (transform, createTicks, createMapping) where

import Axis.Tick exposing (Tick)
import Dict exposing (Dict)

transform : ((Float, Float) -> Dict String Float) -> (Float, Float) -> String -> Float
transform mapping range s =
  case Dict.get s (mapping range) of
    Just x ->
      x
    Nothing ->
      0

-- https://github.com/mbostock/d3/blob/6cc03db0de3777f034dc910a7cae2cbecb0ed099/src/scale/ordinal.js#L39
createTicks : ((Float, Float) -> Dict String Float) -> (Float, Float) -> Int -> List Tick
createTicks mapping range numTicks =
  List.map (\x -> {position = snd x, label = fst x}) (Dict.toList (mapping range))

createMapping : List String -> Int -> (Float, Float) -> Dict String Float
createMapping domain padding range =
  let
    min = fst range
    max = snd range
    step = if List.length domain < 2 then
      toFloat <| round <| (min + max) / 2
    else
      toFloat <| floor <| (max - min) / toFloat (List.length domain - 1 + padding)
    start = if List.length domain < 2 then
      step
    else
      min + step * (toFloat padding) / 2
  in
    buildMapping start step domain Dict.empty

buildMapping : Float -> Float -> List String -> Dict String Float -> Dict String Float
buildMapping start step domain dict =
  if List.length domain == 0 then
    dict
  else
    buildMapping (start + step) step (List.drop 1 domain) (Dict.insert (maybeStringToString (List.head domain)) start dict)

maybeStringToString : Maybe String -> String
maybeStringToString s =
  case s of
    Just s ->
      s
    Nothing ->
      ""
