module Scale.Ordinal where

import Dict exposing (Dict)
import ListExtra exposing (find)
import StringExtra exposing (maybeStringToString)
import Private.Models exposing (PointValue, Tick)

type alias OrdinalMapping =
  { lookup : Dict String (PointValue String)
  , stepSize : Float
  }

interpolate : OrdinalMapping -> String -> PointValue String
interpolate mapping s =
  case Dict.get s (.lookup mapping) of
    Just x ->
      x
    Nothing ->
      { value = 0, width = 0, originalValue = s }

uninterpolate : OrdinalMapping -> Float -> String
uninterpolate mapping x =
  let
    withinHalfStepSize = (\kv -> (abs (.value (snd kv) - x)) <= mapping.stepSize / 2 )
  in
    case find withinHalfStepSize (Dict.toList mapping.lookup) of
      Just kv ->
        fst kv
      Nothing ->
        ""

buildLookup : Float -> Float -> Float -> List String -> Dict String (PointValue String) -> Dict String (PointValue String)
buildLookup start step width domain dict =
  if List.length domain == 0 then
    dict
  else
    let
      orgValue = maybeStringToString (List.head domain)
      pv = { value = start, width = width, originalValue = orgValue }
    in
      buildLookup (start + step) step width (List.drop 1 domain)
        <| Dict.insert orgValue pv dict
