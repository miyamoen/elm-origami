module NestTest exposing (suite)

import Expect exposing (equal)
import Fixtures exposing (..)
import Origami.Css.Selector exposing (..)
import Origami.Css.StyleTag exposing (Property(..))
import Test exposing (..)


suite : Test
suite =
    describe "nest two selectors"
        [ describe "empty"
            [ testNest "empty * empty = 0" initialSelector initialSelector Nothing
            , testNest "empty * class = class" initialSelector classSelector (Just classSelector)
            , testNest "class * empty = 0" classSelector initialSelector Nothing
            , testNest "empty * child = child" initialSelector childSelector (Just childSelector)
            , testNest "child * empty = 0" childSelector initialSelector Nothing
            , testNest "empty * pseudoElement = pseudoElement" initialSelector pseudoSelector (Just pseudoSelector)
            , testNest "pseudoElement * empty = 0" pseudoSelector initialSelector Nothing
            , testNest "empty * media = media" initialSelector mediaSelector (Just (Selector (Single [] Nothing) [] (Just (MediaQuery "media"))))
            , testNest "media * empty = 0" mediaSelector initialSelector Nothing
            , testNest "empty * x = x" initialSelector allSelector (Just allSelector)
            , testNest "x * empty = 0" allSelector initialSelector Nothing
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
                (Just (Selector (Single [ ClassSelector "class" ] Nothing) [] (Just (MediaQuery "media"))))
            , testNest "class * media = class media"
                classSelector
                mediaSelector
                (Just (Selector (Single [ ClassSelector "class" ] Nothing) [] (Just (MediaQuery "media"))))
            ]
        , describe "combination"
            [ testNest "repeatables * repeatables = stucked"
                (Selector (Single [ ClassSelector "1", AttributeSelector "2" ] Nothing) [] Nothing)
                (Selector (Single [ ClassSelector "3", AttributeSelector "4" ] Nothing) [] Nothing)
                (Just
                    (Selector
                        (Single [ ClassSelector "1", AttributeSelector "2", ClassSelector "3", AttributeSelector "4" ] Nothing)
                        []
                        Nothing
                    )
                )
            , testNest "combinator repeatables * combinator repeatables = stucked"
                (Selector
                    (Single
                        [ ClassSelector "1"
                        , AttributeSelector "2"
                        , DescendantCombinator (TypeSelector "3")
                        , ClassSelector "4"
                        , AttributeSelector "5"
                        , ChildCombinator (TypeSelector "6")
                        , ClassSelector "7"
                        , AttributeSelector "8"
                        ]
                        Nothing
                    )
                    []
                    Nothing
                )
                (Selector
                    (Single
                        [ ClassSelector "9"
                        , AttributeSelector "10"
                        , DescendantCombinator (TypeSelector "11")
                        , ClassSelector "12"
                        , AttributeSelector "13"
                        , ChildCombinator (TypeSelector "14")
                        , ClassSelector "15"
                        , AttributeSelector "16"
                        ]
                        Nothing
                    )
                    []
                    Nothing
                )
                (Just
                    (Selector
                        (Single
                            [ ClassSelector "1"
                            , AttributeSelector "2"
                            , DescendantCombinator (TypeSelector "3")
                            , ClassSelector "4"
                            , AttributeSelector "5"
                            , ChildCombinator (TypeSelector "6")
                            , ClassSelector "7"
                            , AttributeSelector "8"
                            , ClassSelector "9"
                            , AttributeSelector "10"
                            , DescendantCombinator (TypeSelector "11")
                            , ClassSelector "12"
                            , AttributeSelector "13"
                            , ChildCombinator (TypeSelector "14")
                            , ClassSelector "15"
                            , AttributeSelector "16"
                            ]
                            Nothing
                        )
                        []
                        Nothing
                    )
                )
            , testNest "multiple * multiple = multiple"
                (Selector (Single [ ClassSelector "p1", AttributeSelector "p2" ] Nothing)
                    [ Single [ ClassSelector "p3", AttributeSelector "p4" ] Nothing ]
                    Nothing
                )
                (Selector (Single [ ClassSelector "c1", AttributeSelector "c2" ] Nothing)
                    [ Single [ ClassSelector "c3", AttributeSelector "c4" ] Nothing
                    , Single [ ClassSelector "c5", AttributeSelector "c6" ] Nothing
                    ]
                    Nothing
                )
                (Just
                    (Selector
                        (Single [ ClassSelector "p1", AttributeSelector "p2", ClassSelector "c1", AttributeSelector "c2" ] Nothing)
                        [ Single [ ClassSelector "p1", AttributeSelector "p2", ClassSelector "c3", AttributeSelector "c4" ] Nothing
                        , Single [ ClassSelector "p1", AttributeSelector "p2", ClassSelector "c5", AttributeSelector "c6" ] Nothing
                        , Single [ ClassSelector "p3", AttributeSelector "p4", ClassSelector "c1", AttributeSelector "c2" ] Nothing
                        , Single [ ClassSelector "p3", AttributeSelector "p4", ClassSelector "c3", AttributeSelector "c4" ] Nothing
                        , Single [ ClassSelector "p3", AttributeSelector "p4", ClassSelector "c5", AttributeSelector "c6" ] Nothing
                        ]
                        Nothing
                    )
                )
            ]
        ]


testNest : String -> Selector -> Selector -> Maybe Selector -> Test
testNest label parent child result =
    test label <| \() -> nest parent child |> equal result


allSelector : Selector
allSelector =
    Selector
        (Single
            [ ClassSelector "class"
            , GeneralSiblingCombinator (TypeSelector "tag")
            , AttributeSelector "attr"
            ]
            (Just (PseudoElement "element"))
        )
        [ Single [ ClassSelector "class" ] Nothing
        , Single
            [ ClassSelector "class"
            , GeneralSiblingCombinator (TypeSelector "tag")
            , AttributeSelector "attr"
            , ChildCombinator UniversalSelector
            , PseudoClassSelector "pclass"
            ]
            Nothing
        ]
        (Just (MediaQuery "media"))


classSelector : Selector
classSelector =
    Selector (Single [ ClassSelector "class" ] Nothing) [] Nothing


pseudoSelector : Selector
pseudoSelector =
    Selector (Single [] (Just (PseudoElement "pseudoElement"))) [] Nothing


childSelector : Selector
childSelector =
    Selector (Single [ ChildCombinator UniversalSelector ] Nothing) [] Nothing


mediaSelector : Selector
mediaSelector =
    Selector (Single [] Nothing) [] (Just (MediaQuery "media"))
