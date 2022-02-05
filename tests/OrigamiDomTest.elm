module OrigamiDomTest exposing (suite)

import Fixtures exposing (..)
import Origami.Html exposing (div, toHtml)
import Origami.Html.Attributes exposing (css)
import Origami.StyleTag exposing (fontFace, keyframes, media, style, styleTag)
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
                    , div [] [ div [ css [ ps "p1", ps "p2" ] ] [] ]
                    ]
                    |> toHtml
                    |> Query.fromHtml
                    |> Query.children []
                    |> Query.first
                    |> Query.has
                        [ Selector.text """._feb1f778 {
    p1_key: p1_val;
    p2_key: p2_val;
}"""
                        ]
            )
        , test "style tag"
            (\_ ->
                div []
                    [ styleTag
                        [ style "selector" [ p "p" ]
                        , media "media" [ style "in media" [ p "m" ] ]
                        , fontFace [ p "f" ]
                        , keyframes "animation"
                            [ ( "from", [ p "from" ] )
                            , ( "to, 50%", [ p "to" ] )
                            ]
                        ]
                    ]
                    |> toHtml
                    |> Query.fromHtml
                    |> Query.children []
                    |> Query.index 1
                    |> Query.has
                        [ Selector.text """selector {
    p_key: p_val;
}

@media media {
    in media {
        m_key: m_val;
    }
}

@font-face {
    f_key: f_val;
}

@keyframes animation {
    from {
        from_key: from_val;
    }

    to, 50% {
        to_key: to_val;
    }
}"""
                        ]
            )
        ]
