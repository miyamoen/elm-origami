module OrigamiTest exposing (suite)

import Expect exposing (equal)
import Fixtures exposing (..)
import Origami exposing (..)
import Origami.Css.Selector exposing (..)
import Origami.Css.Style exposing (Style(..))
import Origami.Css.StyleTag exposing (Property(..))
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Origami interface"
        [ testEqual "property" (ps "p") (PropertyStyle (Property "p_key" "p_val"))
        , testEqual "batch empty" (batch []) (BatchedStyle [])
        , testEqual "batch properties"
            (batch [ ps "1", ps "2", ps "3" ])
            (BatchedStyle
                [ PropertyStyle (Property "1_key" "1_val")
                , PropertyStyle (Property "2_key" "2_val")
                , PropertyStyle (Property "3_key" "3_val")
                ]
            )
        , testEqual "batch batches"
            (batch [ ps "1", batch [ ps "1_1" ], ps "2", batch [ ps "2_1", ps "2_2" ], ps "3" ])
            (BatchedStyle
                [ PropertyStyle (Property "1_key" "1_val")
                , BatchedStyle [ PropertyStyle (Property "1_1_key" "1_1_val") ]
                , PropertyStyle (Property "2_key" "2_val")
                , BatchedStyle
                    [ PropertyStyle (Property "2_1_key" "2_1_val")
                    , PropertyStyle (Property "2_2_key" "2_2_val")
                    ]
                , PropertyStyle (Property "3_key" "3_val")
                ]
            )
        , testEqual "withMedia"
            (withMedia "media query" styles)
            (NestedStyle (Selector "" (Just (MediaQuery "media query"))) styles)
        , testEqual "with"
            (with ".class" styles)
            (NestedStyle (Selector ".class" Nothing) styles)
        , testEqual "withCustom"
            (withCustom "media query" ".class" styles)
            (NestedStyle (Selector ".class" (Just (MediaQuery "media query"))) styles)
        , testEqual "withCustom empty"
            (withCustom "media query" "" styles)
            (NestedStyle (Selector "" (Just (MediaQuery "media query"))) styles)
        , testEqual "qt" (qt "quoted string") "\"quoted string\""
        , testEqual "animation" (animation []) (AnimationStyle [])
        ]


testEqual : String -> a -> a -> Test
testEqual label input result =
    test label <| \() -> input |> equal result
