module Private.Extras.Set where

type alias Set = { start : Float, end : Float }
-- TODO These may not be useful now
type alias Domain = Set
type alias Range = Set
type alias Extent = Set

create : Float -> Float -> Set
create start end =
  { start = start
  , end = end
  }

createFromTuple : (Float, Float) -> Set
createFromTuple set =
  create (fst set) (snd set)

extentOf : Set -> Set
extentOf set =
  if isAscending set then
    set
  else
    reverse set

span : Set -> Float
span set =
  abs (set.end - set.start)

isAscending : Set -> Bool
isAscending set =
  set.start < set.end

isDescending : Set -> Bool
isDescending set =
  set.start > set.end

reverse : Set -> Set
reverse set =
  create set.end set.start
