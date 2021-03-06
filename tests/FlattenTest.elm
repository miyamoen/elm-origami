module FlattenTest exposing (suite)

import Expect exposing (equal)
import Fixtures exposing (..)
import Origami exposing (..)
import Origami.Css.Selector exposing (..)
import Origami.Css.Style exposing (FlatStyle(..), Style, flatten)
import Origami.Css.StyleTag exposing (Property(..))
import Test exposing (..)


suite : Test
suite =
    describe "flatten styles applied to DOM"
        [ testFlatten "empty" [] []
        , testFlatten "single property" [ ps "p" ] [ FlatStyle initialSelector [ p "p" ] ]
        , testFlatten "multiple property"
            [ ps "1", ps "2", ps "3" ]
            [ FlatStyle initialSelector [ p "1", p "2", p "3" ] ]
        , testFlatten "batch empty" [ batch [] ] []
        , testFlatten "batch single" [ batch [ ps "p" ] ] [ FlatStyle initialSelector [ p "p" ] ]
        , testFlatten "batch multiple"
            [ batch [ ps "1", ps "2", ps "3" ] ]
            [ FlatStyle initialSelector [ p "1", p "2", p "3" ] ]
        , testFlatten "multiple batch"
            [ ps "1", batch [ ps "2", ps "3", ps "4" ], ps "5", ps "6", batch [ ps "7", batch [ ps "8", ps "9" ], ps "10" ], ps "11" ]
            [ FlatStyle initialSelector [ p "1", p "2", p "3", p "4", p "5", p "6", p "7", p "8", p "9", p "10", p "11" ] ]
        , describe "animation style"
            [ testFlatten "empty" [ animation [] ] []
            , testFlatten "single"
                [ animation [ ( ( from, [] ), [ p "p" ] ) ] ]
                [ FlatStyle initialSelector [ Property "animation-name" "_keyframes_f89d3c68" ]
                , FlatAnimationStyle "_keyframes_f89d3c68" [ ( ( from, [] ), [ p "p" ] ) ]
                ]
            , testFlatten "REVIEW: empty properties pass"
                [ animation [ ( ( from, [] ), [] ) ] ]
                [ FlatStyle initialSelector [ Property "animation-name" "_keyframes_2a2381ad" ]
                , FlatAnimationStyle "_keyframes_2a2381ad" [ ( ( from, [] ), [] ) ]
                ]
            ]
        , describe "nested style"
            [ testFlatten "withClass"
                [ withClass "class" [ ps "p" ] ]
                [ FlatStyle (Selector (Single [ ClassSelector "class" ] Nothing) [] Nothing) [ p "p" ] ]
            , testFlatten "withClass multiple batch"
                [ withClass "class" [ ps "1", batch [ ps "2", ps "3", ps "4" ], ps "5", ps "6", batch [ ps "7", batch [ ps "8", ps "9" ], ps "10" ], ps "11" ] ]
                [ FlatStyle (Selector (Single [ ClassSelector "class" ] Nothing) [] Nothing) [ p "1", p "2", p "3", p "4", p "5", p "6", p "7", p "8", p "9", p "10", p "11" ] ]
            , testFlatten "empty selectors" [ withEach [] [ ps "p" ] ] []
            , testFlatten "empty styles" [ withClass "class" [] ] []
            , testFlatten "nest media"
                [ ps "p1"
                , withMedia "media query"
                    [ ps "m1"
                    , withMedia "nested media query"
                        [ ps "nm1"
                        , withClass "class" [ ps "nmc" ]
                        , ps "nm2"
                        ]
                    , ps "m2"
                    , withClass "class" [ ps "mc" ]
                    ]
                , ps "p2"
                ]
                [ FlatStyle initialSelector [ p "p1", p "p2" ]
                , FlatStyle (Selector (Single [] Nothing) [] (Just (MediaQuery "media query"))) [ p "m1", p "m2" ]
                , FlatStyle (Selector (Single [ ClassSelector "class" ] Nothing) [] (Just (MediaQuery "media query"))) [ p "mc" ]
                ]
            ]
        ]


testFlatten : String -> List Style -> List FlatStyle -> Test
testFlatten label input result =
    test label <| \() -> flatten input |> equal result
