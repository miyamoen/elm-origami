module OrigamiDomTest exposing (suite)

import Expect exposing (equal)
import Fixtures exposing (..)
import Origami exposing (..)
import Origami.Animation exposing (animation)
import Origami.Css.Selector exposing (..)
import Origami.Css.Style exposing (Style(..))
import Origami.Css.StyleTag exposing (Property(..))
import Origami.Html exposing (..)
import Origami.Html.Attributes exposing (css)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


suite : Test
suite =
    describe "Origami DOM"
        [ test "reduce duplicated"
            (\_ ->
                div []
                    [ div [ css [ ps "p1", ps "p2" ] ] []
                    , div [ css [ ps "p1", ps "p2" ] ] []
                    ]
                    |> toHtml
                    |> Query.fromHtml
                    |> Query.children []
                    |> Query.first
                    |> Query.has
                        [ Selector.text """._99e21d4a {
    p1_key: p1_val;
    p2_key: p2_val;
}"""
                        ]
            )
        ]
