module Private.Scale.Linear (interpolate, createTicks, uninterpolate, pan, zoom, panInPixels, inDomain) where

import Private.Extras.Float exposing (ln, roundTo)
import Private.Models exposing (PointValue)
import Private.Tick as Tick exposing (Tick)
import Private.Extras.Set as Set exposing (Domain, Range, Set)
import Plot.Zoom as Zoom

interpolate : Domain -> Range -> Float -> PointValue Float
interpolate domain range x =
  let
    value =
      if domain.start == domain.end then
        range.start
      else
        (((x - domain.start) * (range.end - range.start)) / (domain.end - domain.start)) + range.start
  in
    { value = value, width = 0, originalValue = x }

uninterpolate : Domain -> Range -> Float -> Float
uninterpolate domain range y =
  if range.start == range.end then
    domain.start
  else
    ((y - range.start) * (domain.end - domain.start) / (range.end - range.start)) + domain.start

zoom : Domain -> Float -> Zoom.Direction -> Domain
zoom domain percentZoom direction =
  let
    change = (domain.end - domain.start) * percentZoom
  in
    case direction of
      Zoom.Out ->
        Set.create (domain.start - change) (domain.end + change)
      Zoom.In ->
        Set.create (domain.start + change) (domain.end - change)

pan : Domain -> Float -> Domain
pan domain change =
  Set.create (domain.start + change) (domain.end + change)

panInPixels : Domain -> Range -> Float -> Domain
panInPixels domain range pxChange =
  let
    dExtent = Set.extentOf domain
    rExtent = Set.extentOf range
    change = (pxChange / (rExtent.end - rExtent.start)) * (dExtent.end - dExtent.start)
  in
    if isInfinite change then
      domain
    else
      pan domain change

inDomain : Domain -> Float -> Bool
inDomain domain x =
  let
    extent = Set.extentOf (domain)
  in
    (x >= extent.start) && (x <= extent.end)

-- https://github.com/mbostock/d3/blob/78ce531f79e82275fe50f975e784ee2be097226b/src/scale/linear.js#L96
createTicks : Int -> Domain -> Range -> List Tick
createTicks numTicks domain range =
  let
    extent = Set.extentOf domain
    step = stepSize extent (toFloat numTicks)
    min = (toFloat (ceiling (extent.start / step))) * step
    max = (toFloat (floor (extent.end / step))) * step + step * 0.5
  in
    makeTicks min max step
      |> List.map (createTick (significantDigits step) domain range)

createTick : Int -> Domain -> Range -> Float -> Tick
createTick sigDigits domain range position =
  Tick.create
    (roundTo (interpolate domain range position).value sigDigits)
    (toString position)

stepSize : Set -> Float -> Float
stepSize extent numTicks =
  let
    span = Set.span extent
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
