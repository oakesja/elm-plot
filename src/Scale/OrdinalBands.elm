module Scale.OrdinalBands (transform, createTicks, createMapping) where

import Private.Models exposing (Tick, PointValue)
import Dict exposing (Dict)

transform : ((Float, Float) -> Dict String PointValue) -> (Float, Float) -> String -> PointValue
transform mapping range s =
  case Dict.get s (mapping range) of
    Just x ->
      x
    Nothing ->
      { value = 0, bandWidth = 0 }

createTicks : ((Float, Float) -> Dict String PointValue) -> (Float, Float) -> List Tick
createTicks mapping range =
  List.map (\x -> {position = .value (snd x), label = fst x}) (Dict.toList (mapping range))

-- https://github.com/mbostock/d3/blob/6cc03db0de3777f034dc910a7cae2cbecb0ed099/src/scale/ordinal.js#L61
createMapping : List String -> Float -> Float -> (Float, Float) -> Dict String PointValue
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
    buildMapping adjStart step bandWidth adjDomain Dict.empty

buildMapping : Float -> Float -> Float -> List String -> Dict String PointValue -> Dict String PointValue
buildMapping start step bandWidth domain dict =
  if List.length domain == 0 then
    dict
  else
    buildMapping (start + step) step bandWidth (List.drop 1 domain)
      <| Dict.insert (maybeStringToString (List.head domain)) { value = start, bandWidth = bandWidth } dict

maybeStringToString : Maybe String -> String
maybeStringToString s =
  case s of
    Just s ->
      s
    Nothing ->
      ""
