module OrigamiTest exposing (suite)

import Expect exposing (equal)
import Fixtures exposing (..)
import Origami exposing (..)
import Origami.Animation exposing (animation)
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
        , testEqual "withClass"
            (withClass "class" styles)
            (NestedStyle (Selector [ Single [ ClassSelector "class" ] [] Nothing ] Nothing) styles)
        , testEqual "withAttribute"
            (withAttribute "attr" styles)
            (NestedStyle (Selector [ Single [ AttributeSelector "attr" ] [] Nothing ] Nothing) styles)
        , testEqual "withPseudoClass"
            (withPseudoClass "class" styles)
            (NestedStyle (Selector [ Single [ PseudoClassSelector "class" ] [] Nothing ] Nothing) styles)
        , testEqual "withPseudoElement"
            (withPseudoElement "element" styles)
            (NestedStyle (Selector [ Single [] [] (Just (PseudoElement "element")) ] Nothing) styles)
        , testEqual "withMedia"
            (withMedia "media query" styles)
            (NestedStyle (Selector [] (Just (MediaQuery "media query"))) styles)
        , describe "withDescendants"
            [ testEqual "single"
                (withDescendants [ ( tag "tag", [] ) ] styles)
                (NestedStyle (Selector [ Single [] [ Sequence DescendantCombinator (TypeSelector "tag") [] ] Nothing ] Nothing) styles)
            , testEqual "multiple"
                (withDescendants [ ( tag "tag", [] ), ( everyTag, [] ) ] styles)
                (NestedStyle
                    (Selector
                        [ Single [] [ Sequence DescendantCombinator (TypeSelector "tag") [] ] Nothing
                        , Single [] [ Sequence DescendantCombinator UniversalSelector [] ] Nothing
                        ]
                        Nothing
                    )
                    styles
                )
            , testEqual "repeatable"
                (withDescendants [ ( tag "tag", [ class "class" ] ) ] styles)
                (NestedStyle (Selector [ Single [] [ Sequence DescendantCombinator (TypeSelector "tag") [ ClassSelector "class" ] ] Nothing ] Nothing) styles)
            , testEqual "empty" (withDescendants [] styles) (NestedStyle (Selector [] Nothing) styles)
            ]
        , describe "withChildren"
            [ testEqual "single"
                (withChildren [ ( tag "tag", [] ) ] styles)
                (NestedStyle (Selector [ Single [] [ Sequence ChildCombinator (TypeSelector "tag") [] ] Nothing ] Nothing) styles)
            , testEqual "multiple"
                (withChildren [ ( tag "tag", [] ), ( everyTag, [] ) ] styles)
                (NestedStyle
                    (Selector
                        [ Single [] [ Sequence ChildCombinator (TypeSelector "tag") [] ] Nothing
                        , Single [] [ Sequence ChildCombinator UniversalSelector [] ] Nothing
                        ]
                        Nothing
                    )
                    styles
                )
            , testEqual "repeatable"
                (withChildren [ ( tag "tag", [ class "class" ] ) ] styles)
                (NestedStyle (Selector [ Single [] [ Sequence ChildCombinator (TypeSelector "tag") [ ClassSelector "class" ] ] Nothing ] Nothing) styles)
            , testEqual "empty" (withChildren [] styles) (NestedStyle (Selector [] Nothing) styles)
            ]
        , describe "withGeneralSiblings"
            [ testEqual "single"
                (withGeneralSiblings [ ( tag "tag", [] ) ] styles)
                (NestedStyle (Selector [ Single [] [ Sequence GeneralSiblingCombinator (TypeSelector "tag") [] ] Nothing ] Nothing) styles)
            , testEqual "multiple"
                (withGeneralSiblings [ ( tag "tag", [] ), ( everyTag, [] ) ] styles)
                (NestedStyle
                    (Selector
                        [ Single [] [ Sequence GeneralSiblingCombinator (TypeSelector "tag") [] ] Nothing
                        , Single [] [ Sequence GeneralSiblingCombinator UniversalSelector [] ] Nothing
                        ]
                        Nothing
                    )
                    styles
                )
            , testEqual "repeatable"
                (withGeneralSiblings [ ( tag "tag", [ class "class" ] ) ] styles)
                (NestedStyle (Selector [ Single [] [ Sequence GeneralSiblingCombinator (TypeSelector "tag") [ ClassSelector "class" ] ] Nothing ] Nothing) styles)
            , testEqual "empty" (withGeneralSiblings [] styles) (NestedStyle (Selector [] Nothing) styles)
            ]
        , describe "withAdjacentSiblings"
            [ testEqual "single"
                (withAdjacentSiblings [ ( tag "tag", [] ) ] styles)
                (NestedStyle (Selector [ Single [] [ Sequence AdjacentSiblingCombinator (TypeSelector "tag") [] ] Nothing ] Nothing) styles)
            , testEqual "multiple"
                (withAdjacentSiblings [ ( tag "tag", [] ), ( everyTag, [] ) ] styles)
                (NestedStyle
                    (Selector
                        [ Single [] [ Sequence AdjacentSiblingCombinator (TypeSelector "tag") [] ] Nothing
                        , Single [] [ Sequence AdjacentSiblingCombinator UniversalSelector [] ] Nothing
                        ]
                        Nothing
                    )
                    styles
                )
            , testEqual "repeatable"
                (withAdjacentSiblings [ ( tag "tag", [ class "class" ] ) ] styles)
                (NestedStyle (Selector [ Single [] [ Sequence AdjacentSiblingCombinator (TypeSelector "tag") [ ClassSelector "class" ] ] Nothing ] Nothing) styles)
            , testEqual "empty" (withAdjacentSiblings [] styles) (NestedStyle (Selector [] Nothing) styles)
            ]
        , describe "selector"
            [ testEqual "empty" (selector [] []) (Single [] [] Nothing)
            , testEqual "class" (selector [ class "class" ] []) (Single [ ClassSelector "class" ] [] Nothing)
            , testEqual "attribute" (selector [ attribute "attr" ] []) (Single [ AttributeSelector "attr" ] [] Nothing)
            , testEqual "pseudoClass" (selector [ pseudoClass "pseudoClass" ] []) (Single [ PseudoClassSelector "pseudoClass" ] [] Nothing)
            , testEqual "descendant"
                (selector [] [ descendant everyTag [ class "class" ] ])
                (Single [] [ Sequence DescendantCombinator UniversalSelector [ ClassSelector "class" ] ] Nothing)
            , testEqual "child"
                (selector [] [ child everyTag [ class "class" ] ])
                (Single [] [ Sequence ChildCombinator UniversalSelector [ ClassSelector "class" ] ] Nothing)
            , testEqual "generalSibling"
                (selector [] [ generalSibling everyTag [ class "class" ] ])
                (Single [] [ Sequence GeneralSiblingCombinator UniversalSelector [ ClassSelector "class" ] ] Nothing)
            , testEqual "adjacentSibling"
                (selector [] [ adjacentSibling everyTag [ class "class" ] ])
                (Single [] [ Sequence AdjacentSiblingCombinator UniversalSelector [ ClassSelector "class" ] ] Nothing)
            , testEqual "pseudoElement" (pseudoElement [] [] "pseudoElement") (Single [] [] (Just (PseudoElement "pseudoElement")))
            , testEqual "all"
                (pseudoElement [ class "class", attribute "attr", pseudoClass "pseudoClass" ]
                    [ descendant everyTag [ class "class" ]
                    , child everyTag [ class "class" ]
                    , generalSibling everyTag [ class "class" ]
                    , adjacentSibling everyTag [ class "class" ]
                    ]
                    "pseudoElement"
                )
                (Single [ ClassSelector "class", AttributeSelector "attr", PseudoClassSelector "pseudoClass" ]
                    [ Sequence DescendantCombinator UniversalSelector [ ClassSelector "class" ]
                    , Sequence ChildCombinator UniversalSelector [ ClassSelector "class" ]
                    , Sequence GeneralSiblingCombinator UniversalSelector [ ClassSelector "class" ]
                    , Sequence AdjacentSiblingCombinator UniversalSelector [ ClassSelector "class" ]
                    ]
                    (Just (PseudoElement "pseudoElement"))
                )
            , testEqual "s == selector" s selector
            ]
        , testEqual "with"
            (with (s [ class "class" ] []) styles)
            (NestedStyle (Selector [ s [ class "class" ] [] ] Nothing) styles)
        , testEqual "withEach"
            (withEach [ s [ class "class" ] [], s [ attribute "attr" ] [] ] styles)
            (NestedStyle (Selector [ s [ class "class" ] [], s [ attribute "attr" ] [] ] Nothing) styles)
        , testEqual "withCustom"
            (withCustom [ s [ class "class" ] [], s [ attribute "attr" ] [] ] "media query" styles)
            (NestedStyle (Selector [ s [ class "class" ] [], s [ attribute "attr" ] [] ] (Just (MediaQuery "media query"))) styles)
        , testEqual "qt" (qt "quoted string") "\"quoted string\""
        , testEqual "animation" (animation []) (AnimationStyle [])
        ]


testEqual : String -> a -> a -> Test
testEqual label input result =
    test label <| \() -> input |> equal result
