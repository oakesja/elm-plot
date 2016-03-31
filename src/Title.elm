module Title (..) where

import Svg exposing (svg, Svg, text', text)
import Svg.Attributes exposing (textAnchor)
import Extras.SvgAttributes exposing (x, y)
import BoundingBox exposing (BoundingBox)
import List
import String

type alias Model =
  { title : String
  , attrs : List Svg.Attribute
  }

create : String -> List Svg.Attribute -> Model
create title attrs =
  { title = title
  , attrs = attrs
  }

init : Model
init =
  create "" []

isEmpty : Model -> Bool
isEmpty title =
  String.isEmpty title.title

toSvg : Model -> BoundingBox -> Svg
toSvg model bBox =
  let
    titleAttrs =
      if List.isEmpty model.attrs then
        [ textAnchor "middle"
        , x (((bBox.xEnd - bBox.xStart) / 2) + bBox.xStart)
        , y 30
        ]
      else
        model.attrs
  in
    text'
      titleAttrs
      [ text model.title ]
