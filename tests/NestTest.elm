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
            [ testNest "empty * empty" initialSelector initialSelector (Just initialSelector)
            , testNest "nest" initialSelector (selector ".test") (Just <| selector ".test")
            , testNest "combination" (selector ".test1") (selector ".test2") (Just <| selector ".test1.test2")
            , testNest "media" initialSelector mediaSelector (Just mediaSelector)
            ]
        , describe "media"
            [ testNest "not nest media" mediaSelector mediaSelector Nothing
            , testNest "media * selector"
                mediaSelector
                (selector ".test")
                (Just (Selector ".test" (Just (MediaQuery "media"))))
            , testNest "selector * media"
                (selector ".test")
                mediaSelector
                (Just (Selector ".test" (Just (MediaQuery "media"))))
            ]
        ]


testNest : String -> Selector -> Selector -> Maybe Selector -> Test
testNest label parent child result =
    test label <| \() -> nest parent child |> equal result
