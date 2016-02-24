module Test.Axis.TitleTest where

import Axis.Title exposing (..)
import Axis.Orient
import Axis.Extent exposing (createExtent)
import Svg.Attributes exposing (x, y, textAnchor, stroke, transform)
import ElmTest exposing (..)

tests : Test
tests =
  suite "Axis.Axis"
        [ createTitleTests
        , titleAttrsTests
        ]

createTitleTests : Test
createTitleTests =
  let
    createTitle' = createTitle (createExtent 0 100) Axis.Orient.Top 0 0 [] Nothing
  in
    suite "createTitle"
      [ test "when a title string is given an svg is created for it"
          <| assertEqual 1 <| List.length <| createTitle' (Just "title")
      , test "when no title string is given then nothing is created "
          <| assertEqual 0 <| List.length <| createTitle' Nothing
      ]

titleAttrsTests : Test
titleAttrsTests =
    let
      titleAttrs' =  titleAttrs (createExtent 0 100)
    in
      suite "titleAttrs"
        [ test "for a top orient it places it above the axis"
            <| assertEqual [textAnchor "middle", x "50", y "-42"] <| titleAttrs' Axis.Orient.Top 1 1 [] Nothing
        , test "for a bottom orient it places it bellow the axis"
            <| assertEqual [textAnchor "middle", x "50", y "42"] <| titleAttrs' Axis.Orient.Bottom 1 1 [] Nothing
        , test "for a left orient it places it to the left of the axis"
            <| assertEqual [textAnchor "middle", x "-42", y "50", transform "rotate(-90,-42,50)" ]
              <| titleAttrs' Axis.Orient.Left 1 1 [] Nothing
        , test "for a right orient it places it to the right of the axis"
            <| assertEqual [textAnchor "middle", x "42", y "50", transform "rotate(90,42,50)"]
              <| titleAttrs' Axis.Orient.Right 1 1 [] Nothing
        , test "when an offset is given then it is used instead"
            <| assertEqual [textAnchor "middle", x "50", y "-21"] <| titleAttrs' Axis.Orient.Top 1 1 [] (Just 21)
        , test "it is placed in the middle of the axis"
            <| assertEqual [textAnchor "middle", x "150", y "-21"]
              <| titleAttrs (createExtent 100 200) Axis.Orient.Top 1 1 [] (Just 21)
        , test "additional attrs are appended to the end"
            <| assertEqual [textAnchor "middle", x "50", y "-42", stroke "red"]
              <| titleAttrs' Axis.Orient.Top 1 1 [stroke "red"] Nothing
        ]
