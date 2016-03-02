module ListExtra where

find : (a -> Bool) -> List a -> Maybe a
find predicate list =
  case list of
    [] ->
      Nothing
    first :: rest ->
      if predicate first then
        Just first
      else
        find predicate rest

toList : a -> List a
toList x =
  [x]
