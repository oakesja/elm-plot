module Scale.Linear (interpolate, createTicks, uninterpolate, pan, zoom) where

import FloatExtra exposing (ln, roundTo)
import Sets exposing (extentOf)
import Private.Models exposing (Tick, PointValue)
import Sets exposing (Domain, Range, Set)
import Zoom

interpolate : Domain -> Range -> Float -> PointValue Float
interpolate domain range x =
  let
    value =
      if fst domain == snd domain then
        fst range
      else
        (((x - fst domain) * (snd range - fst range)) / (snd domain - fst domain)) + fst range
  in
    { value = value, width = 0, originalValue = x }

uninterpolate : Domain -> Range -> Float -> Float
uninterpolate domain range y =
  if fst range == snd range then
    fst domain
  else
    ((y - fst range) * (snd domain - fst domain) / (snd range - fst range)) + fst domain

zoom : Domain -> Float -> Zoom.Direction -> Domain
zoom domain percentZoom direction =
  let
    change = (snd domain - fst domain) * percentZoom
  in
    case direction of
      Zoom.Out ->
        ((fst domain) - change, (snd domain) + change)
      Zoom.In ->
        ((fst domain) + change, (snd domain) - change)

pan : Domain -> Float -> Domain
pan domain change =
  (fst domain + change, snd domain + change)

-- https://github.com/mbostock/d3/blob/78ce531f79e82275fe50f975e784ee2be097226b/src/scale/linear.js#L96
createTicks : Int -> Domain -> Range -> List Tick
createTicks numTicks domain range =
  let
    extent = extentOf domain
    step = stepSize extent (toFloat numTicks)
    min = (toFloat (ceiling (fst extent / step))) * step
    max = (toFloat (floor (snd extent / step))) * step + step * 0.5
  in
    makeTicks min max step
      |> List.map (createTick (significantDigits step) domain range)

createTick : Int -> Domain -> Range -> Float -> Tick
createTick sigDigits domain range position =
  { position = roundTo (interpolate domain range position).value sigDigits
  , label = toString position
  }

stepSize : Set -> Float -> Float
stepSize extent numTicks =
  let
    span = snd extent - fst extent
    step = toFloat (10 ^ (floor((ln (span/ numTicks) /ln 10))))
    err = numTicks / span * step
  in
    if err <= 0.15 then
      step * 10
    else if err < 0.35 then
      step * 5
    else if err < 0.75 then
      step * 2
    else
      step

makeTicks : Float -> Float -> Float -> List Float
makeTicks min max step =
  if min >= max then
    []
  else
    [min] ++ makeTicks (min + step) max step

significantDigits : Float -> Int
significantDigits step =
  negate (floor ((ln step) / (ln 10) + 0.01))
