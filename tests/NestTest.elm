module NestTest exposing (suite)

import Expect exposing (equal)
import Fixtures exposing (..)
import Origami.Css.Selector exposing (..)
import Origami.Css.StyleTag exposing (Property(..))
import Test exposing (..)


suite : Test
suite =
    describe "nest two selectors"
        [ describe "1"
            [ testNest "1 * 1 = 0" initialSelector initialSelector Nothing
            , testNest "1 * class = class" initialSelector classSelector (Just classSelector)
            , testNest "class * 1 = 0" classSelector initialSelector Nothing
            , testNest "1 * child = child" initialSelector childSelector (Just childSelector)
            , testNest "child * 1 = 0" childSelector initialSelector Nothing
            , testNest "1 * pseudoElement = pseudoElement" initialSelector pseudoSelector (Just pseudoSelector)
            , testNest "pseudoElement * 1 = 0" pseudoSelector initialSelector Nothing
            , testNest "1 * media = 1 media" initialSelector mediaSelector (Just (Selector [ Single [] [] Nothing ] (Just (MediaQuery "media"))))
            , testNest "media * 1 = 1 media" mediaSelector initialSelector (Just (Selector [ Single [] [] Nothing ] (Just (MediaQuery "media"))))
            , testNest "1 * x = x" initialSelector allSelector (Just allSelector)
            , testNest "x * 1 = 0" allSelector initialSelector Nothing
            ]
        , describe "0"
            [ testNest "0 * 0 = 0" zeroSelector zeroSelector Nothing
            , testNest "0 * 1 = 0" zeroSelector initialSelector Nothing
            , testNest "1 * 0 = 0" initialSelector zeroSelector Nothing
            , testNest "0 * class = 0" zeroSelector classSelector Nothing
            , testNest "class * 0 = 0" classSelector zeroSelector Nothing
            , testNest "0 * child = 0" zeroSelector childSelector Nothing
            , testNest "child * 0 = 0" childSelector zeroSelector Nothing
            , testNest "0 * pseudoElement = 0" zeroSelector pseudoSelector Nothing
            , testNest "pseudoElement * 0 = 0" pseudoSelector zeroSelector Nothing
            , testNest "0 * media = 0" zeroSelector mediaSelector Nothing
            , testNest "media * 0 = 0" mediaSelector zeroSelector Nothing
            , testNest "0 * x = 0" zeroSelector allSelector Nothing
            , testNest "x * 0 = 0" allSelector zeroSelector Nothing
            ]
        , describe "pseudoElement"
            [ testNest "pseudoElement * class = 0" pseudoSelector classSelector Nothing
            , testNest "pseudoElement * child = 0" pseudoSelector childSelector Nothing
            , testNest "pseudoElement * pseudoElement = 0" pseudoSelector pseudoSelector Nothing
            , testNest "pseudoElement * x = 0" pseudoSelector allSelector Nothing
            ]
        , describe "media"
            [ testNest "media * media = 0" mediaSelector mediaSelector Nothing
            , testNest "media * class = class media"
                mediaSelector
                classSelector
                (Just (Selector [ Single [ ClassSelector "class" ] [] Nothing ] (Just (MediaQuery "media"))))
            , testNest "class * media = class media"
                classSelector
                mediaSelector
                (Just (Selector [ Single [ ClassSelector "class" ] [] Nothing ] (Just (MediaQuery "media"))))
            ]
        , describe "combination"
            [ testNest "repeatables * repeatables = sticked"
                (Selector [ Single [ ClassSelector "1", AttributeSelector "2" ] [] Nothing ] Nothing)
                (Selector [ Single [ ClassSelector "3", AttributeSelector "4" ] [] Nothing ] Nothing)
                (Just
                    (Selector
                        [ Single [ ClassSelector "1", AttributeSelector "2", ClassSelector "3", AttributeSelector "4" ] [] Nothing ]
                        Nothing
                    )
                )
            , testNest "sequences * sequences = sticked"
                (Selector
                    [ Single [ ClassSelector "1", AttributeSelector "2" ]
                        [ Sequence DescendantCombinator (TypeSelector "3") [ ClassSelector "4", AttributeSelector "5" ]
                        , Sequence ChildCombinator (TypeSelector "6") [ ClassSelector "7", AttributeSelector "8" ]
                        ]
                        Nothing
                    ]
                    Nothing
                )
                (Selector
                    [ Single [ ClassSelector "9", AttributeSelector "10" ]
                        [ Sequence DescendantCombinator (TypeSelector "11") [ ClassSelector "12", AttributeSelector "13" ]
                        , Sequence ChildCombinator (TypeSelector "14") [ ClassSelector "15", AttributeSelector "16" ]
                        ]
                        Nothing
                    ]
                    Nothing
                )
                (Just
                    (Selector
                        [ Single [ ClassSelector "1", AttributeSelector "2" ]
                            [ Sequence DescendantCombinator (TypeSelector "3") [ ClassSelector "4", AttributeSelector "5" ]
                            , Sequence ChildCombinator
                                (TypeSelector "6")
                                [ ClassSelector "7"
                                , AttributeSelector "8"
                                , ClassSelector "9"
                                , AttributeSelector "10"
                                ]
                            , Sequence DescendantCombinator (TypeSelector "11") [ ClassSelector "12", AttributeSelector "13" ]
                            , Sequence ChildCombinator (TypeSelector "14") [ ClassSelector "15", AttributeSelector "16" ]
                            ]
                            Nothing
                        ]
                        Nothing
                    )
                )
            , testNest "multiple * multiple = multiple"
                (Selector
                    [ Single [ ClassSelector "p1", AttributeSelector "p2" ] [] Nothing
                    , Single [ ClassSelector "p3", AttributeSelector "p4" ] [] Nothing
                    ]
                    Nothing
                )
                (Selector
                    [ Single [ ClassSelector "c1", AttributeSelector "c2" ] [] Nothing
                    , Single [ ClassSelector "c3", AttributeSelector "c4" ] [] Nothing
                    , Single [ ClassSelector "c5", AttributeSelector "c6" ] [] Nothing
                    ]
                    Nothing
                )
                (Just
                    (Selector
                        [ Single [ ClassSelector "p1", AttributeSelector "p2", ClassSelector "c1", AttributeSelector "c2" ] [] Nothing
                        , Single [ ClassSelector "p1", AttributeSelector "p2", ClassSelector "c3", AttributeSelector "c4" ] [] Nothing
                        , Single [ ClassSelector "p1", AttributeSelector "p2", ClassSelector "c5", AttributeSelector "c6" ] [] Nothing
                        , Single [ ClassSelector "p3", AttributeSelector "p4", ClassSelector "c1", AttributeSelector "c2" ] [] Nothing
                        , Single [ ClassSelector "p3", AttributeSelector "p4", ClassSelector "c3", AttributeSelector "c4" ] [] Nothing
                        , Single [ ClassSelector "p3", AttributeSelector "p4", ClassSelector "c5", AttributeSelector "c6" ] [] Nothing
                        ]
                        Nothing
                    )
                )
            ]
        ]


testNest : String -> Selector -> Selector -> Maybe Selector -> Test
testNest label parent child result =
    test label <| \() -> nest parent child |> equal result


zeroSelector : Selector
zeroSelector =
    Selector [] Nothing


allSelector : Selector
allSelector =
    Selector
        [ Single [ ClassSelector "class" ]
            [ Sequence GeneralSiblingCombinator (TypeSelector "tag") [ AttributeSelector "attr" ] ]
            (Just (PseudoElement "element"))
        , Single [ ClassSelector "class" ] [] Nothing
        , Single
            [ ClassSelector "class" ]
            [ Sequence GeneralSiblingCombinator (TypeSelector "tag") [ AttributeSelector "attr" ]
            , Sequence ChildCombinator UniversalSelector [ PseudoClassSelector "pclass" ]
            ]
            Nothing
        ]
        (Just (MediaQuery "media"))


classSelector : Selector
classSelector =
    Selector [ Single [ ClassSelector "class" ] [] Nothing ] Nothing


pseudoSelector : Selector
pseudoSelector =
    Selector [ Single [] [] (Just (PseudoElement "pseudoElement")) ] Nothing


childSelector : Selector
childSelector =
    Selector [ Single [] [ Sequence ChildCombinator UniversalSelector [] ] Nothing ] Nothing


mediaSelector : Selector
mediaSelector =
    Selector [] (Just (MediaQuery "media"))
