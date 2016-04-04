module Private.Scale.OrdinalBands (interpolate, createTicks, createMapping, uninterpolate, inDomain) where

import Private.Models exposing (PointValue)
import Private.Tick as Tick exposing (Tick)
import Dict exposing (Dict)
import Private.Extras.Set exposing (Range)
import Private.Scale.Ordinal as OrdinalScale exposing (OrdinalMapping)

interpolate : (List String -> Range -> OrdinalMapping) -> List String -> Range -> String -> PointValue String
interpolate mapping domain range s =
  OrdinalScale.interpolate (mapping domain range) s

uninterpolate : (List String -> Range -> OrdinalMapping) -> List String -> Range -> Float -> String
uninterpolate mapping domain range x =
  OrdinalScale.uninterpolate (mapping domain range) x

createTicks : (List String -> Range -> OrdinalMapping) -> List String -> Range -> List Tick
createTicks mapping domain range =
  OrdinalScale.createTicks
    (mapping domain range)
    (\label pv -> Tick.create (pv.value + pv.width / 2) label)

inDomain : List String -> String -> Bool
inDomain domain x =
  List.member x domain

-- TODO clean up with functions from sets
-- https://github.com/mbostock/d3/blob/6cc03db0de3777f034dc910a7cae2cbecb0ed099/src/scale/ordinal.js#L61
createMapping : Float -> Float -> List String -> Range -> OrdinalMapping
createMapping padding outerPadding domain range =
  let
    start = min range.start range.end
    stop = max range.start range.end
    step = (stop - start) / ((toFloat <| List.length domain) - padding + 2 * outerPadding)
    bandWidth = abs <| step * (1 - padding)
    adjStart = start + step * outerPadding
    adjDomain =
      if range.start < range.end then
        domain
      else
        List.reverse domain
  in
    { lookup = OrdinalScale.buildLookup adjStart step bandWidth adjDomain Dict.empty
    , stepSize = step
    }
