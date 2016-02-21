module Utils where

extentOf : (Float, Float) -> (Float, Float)
extentOf domain =
  if fst domain < snd domain then
    domain
  else
    (snd domain, fst domain)
