module Sets where

type alias Domain = (Float, Float)
type alias Range = (Float, Float)
type alias Set = (Float, Float)

extentOf : Set -> Set
extentOf set =
  if fst set < snd set then
    set
  else
    (snd set, fst set)
