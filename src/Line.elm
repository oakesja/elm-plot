module Line where

import Private.Models exposing (BoundingBox, Path)

type alias Point = { x : Float, y : Float }
type alias Line = { p0 : Point, p1 : Point }

clipPath : BoundingBox -> Path Float Float -> List (Path Float Float)
clipPath bBox path =
  let
    lines = pathToLines path
    clippedlines = List.map (clip bBox) lines
  in
    linesToPath clippedlines [] []

pathToLines : Path Float Float -> List Line
pathToLines path =
  case path of
    [] ->
      []
    hd :: tail ->
      case List.head tail of
        Just t ->
          (Line hd t) :: pathToLines tail
        Nothing ->
          []

-- TODO this is awful, find a better solution
linesToPath : List (Maybe Line) -> Path Float Float -> List (Path Float Float) -> List (Path Float Float)
linesToPath lines currentPath paths =
  case lines of
    [] ->
      if List.isEmpty currentPath then
        paths
      else
        paths ++ [currentPath]
    hd :: tail ->
      case hd of
        Nothing ->
          linesToPath tail [] (paths ++ [currentPath])
        Just h ->
          case List.head tail of
            Nothing ->
              linesToPath tail (currentPath ++ [h.p0, h.p1]) paths
            Just t ->
              case t of
                Nothing ->
                  linesToPath tail (currentPath ++ [h.p0, h.p1]) paths
                Just t ->
                  if h.p1 == t.p0 then
                    linesToPath tail (currentPath ++ [h.p0]) paths
                  else
                    linesToPath tail [] (paths ++ [(currentPath ++ [h.p0, h.p1])])


-- Uses Liang-Barsky line clipping algorithm but modified to return Nothing
-- if outside of bounding box
-- http://www.skytopia.com/project/articles/compsci/clipping.html
clip : BoundingBox -> Line -> Maybe Line
clip bBox line =
  let
    reversed = line.p0.x > line.p1.x
    p0 = if reversed then line.p1 else line.p0
    p1 = if reversed then line.p0 else line.p1
    xDelta = p1.x - p0.x
    yDelta = p1.y - p0.y
    times =
      leftCheck p0 xDelta bBox (0, 1)
        |> bottomCheck p0 yDelta bBox
        |> rightCheck p0 xDelta bBox
        |> topCheck p0 yDelta bBox
    t0 = fst times
    t1 = snd times
    clippedStart = Point (p0.x + t0 * xDelta) (p0.y + t0 * yDelta)
    clippedEnd = Point (p0.x + t1 * xDelta) (p0.y + t1 * yDelta)
  in
    if outsideBoundingBox times then
      Nothing
    else if reversed then
      Just (Line clippedEnd clippedStart)
    else
      Just (Line clippedStart clippedEnd)

leftCheck : Point -> Float -> BoundingBox -> (Float, Float) -> (Float, Float)
leftCheck p0 xDelta bBox times =
  updateTimes -xDelta -(bBox.xStart - p0.x) times

bottomCheck : Point -> Float -> BoundingBox -> (Float, Float) -> (Float, Float)
bottomCheck p0 yDelta bBox times =
  updateTimes -yDelta -(bBox.yStart - p0.y) times

rightCheck : Point -> Float -> BoundingBox -> (Float, Float) -> (Float, Float)
rightCheck p0 xDelta bBox times =
  updateTimes xDelta (bBox.xEnd - p0.x) times

topCheck : Point -> Float -> BoundingBox -> (Float, Float) -> (Float, Float)
topCheck p0 yDelta bBox times =
  updateTimes yDelta (bBox.yEnd - p0.y) times

updateTimes : Float -> Float -> (Float, Float) -> (Float, Float)
updateTimes p q times =
  let
    r = q / p
  in
    if p < 0 && r > fst times then
      (r, snd times)
    else if p >= 0 && r < snd times then
      (fst times, r)
    else
      times

outsideBoundingBox : (Float, Float) -> Bool
outsideBoundingBox times =
  if isNaN (fst times) || isNaN (snd times) then
    True
  else if (fst times) >= (snd times) then
    True
  else
    False
