module Polygon where

import Private.Models exposing (BoundingBox, Point)

type alias Point = { x : Float , y : Float}
type alias PosCheck = (Point -> Bool)

-- Uses Sutherland-Hodgman Polygon Clipping algorithm
-- https://www.cs.helsinki.fi/group/goa/viewing/leikkaus/intro2.html
clip : BoundingBox -> List Point -> List Point
clip bBox points =
  clipLeft bBox points
    |> clipRight bBox
    |> clipTop bBox
    |> clipBottom bBox

clipLeft : BoundingBox -> List Point -> List Point
clipLeft bBox points =
  let
    intersection = \p1 p2 ->
      let
        slope = (p2.y - p1.y) / (p2.x - p1.x)
        y = slope * (bBox.xStart - p1.x) + p1.y
      in
        Point bBox.xStart y
  in
    clipSide (\p -> p.x >= bBox.xStart) intersection (appendHead points)

clipRight : BoundingBox -> List Point -> List Point
clipRight bBox points =
  let
    intersection = \p1 p2 ->
      let
        slope = (p2.y - p1.y) / (p2.x - p1.x)
        y = slope * (bBox.xEnd - p1.x) + p1.y
      in
        Point bBox.xEnd y
  in
    clipSide (\p -> p.x <= bBox.xEnd) intersection (appendHead points)

clipBottom : BoundingBox -> List Point -> List Point
clipBottom bBox points =
  let
    intersection = \p1 p2 ->
      let
        slope = (p2.y - p1.y) / (p2.x - p1.x)
        x = p1.x + (bBox.yStart - p1.y) / slope
      in
        Point x bBox.yStart
  in
    clipSide (\p -> p.y >= bBox.yStart) intersection (appendHead points)

clipTop : BoundingBox -> List Point -> List Point
clipTop bBox points =
  let
    intersection = \p1 p2 ->
      let
        slope = (p2.y - p1.y) / (p2.x - p1.x)
        x = p1.x + (bBox.yEnd - p1.y) / slope
      in
        Point x bBox.yEnd
  in
    clipSide (\p -> p.y <= bBox.yEnd) intersection (appendHead points)

clipSide : (Point -> Bool) -> (Point -> Point -> Point) -> List Point -> List Point
clipSide insideClipRegion intersection points =
  case points of
    [] ->
      []
    hd :: [] ->
      []
    hd :: t :: tail ->
      let
        clipAgain = clipSide insideClipRegion intersection (t :: tail)
      in
        if insideClipRegion hd && insideClipRegion t then
          t :: clipAgain
        else if not (insideClipRegion hd) && not (insideClipRegion t) then
          clipAgain
        else if insideClipRegion hd then
          intersection hd t :: clipAgain
        else
          [(intersection hd t), t] ++ clipAgain

appendHead : List a -> List a
appendHead list =
  case List.head list of
    Nothing ->
      list
    Just h ->
      list ++ [h]
