module Scale.OrdinalBands (interpolate, createTicks, createMapping) where

import Private.Models exposing (Tick, PointValue)
import Dict exposing (Dict)
import Sets exposing (Range)

interpolate : (Range -> Dict String (PointValue String)) -> Range -> String -> PointValue String
interpolate mapping range s =
  case Dict.get s (mapping range) of
    Just x ->
      x
    Nothing ->
      { value = 0, width = 0, originalValue = s }

createTicks : (Range -> Dict String (PointValue String)) -> Range -> List Tick
createTicks mapping range =
  List.map
    (\x -> {position = .value (snd x) + (.width (snd x) / 2), label = fst x})
    (Dict.toList (mapping range))

-- https://github.com/mbostock/d3/blob/6cc03db0de3777f034dc910a7cae2cbecb0ed099/src/scale/ordinal.js#L61
createMapping : List String -> Float -> Float -> Range -> Dict String (PointValue String)
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

buildMapping : Float -> Float -> Float -> List String -> Dict String (PointValue String) -> Dict String (PointValue String)
buildMapping start step width domain dict =
  if List.length domain == 0 then
    dict
  else
    buildMapping (start + step) step width (List.drop 1 domain)
      <| Dict.insert (maybeStringToString (List.head domain)) { value = start, width = width, originalValue = (maybeStringToString (List.head domain)) } dict

maybeStringToString : Maybe String -> String
maybeStringToString s =
  case s of
    Just s ->
      s
    Nothing ->
      ""
