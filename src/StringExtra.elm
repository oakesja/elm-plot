module StringExtra where

maybeStringToString : Maybe String -> String
maybeStringToString s =
  case s of
    Just s ->
      s
    Nothing ->
      ""
