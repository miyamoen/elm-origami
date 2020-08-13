module PrintTest exposing (suite)

import Expect exposing (equal)
import Fixtures exposing (..)
import Origami exposing (..)
import Origami.Css.Selector exposing (..)
import Origami.Css.Style exposing (FlatStyle(..), Style, compile, flatten)
import Origami.Css.StyleTag exposing (Property(..), print)
import Test exposing (..)


suite : Test
suite =
    describe "print styles applied to DOM"
        [ testPrint "empty" [] ""
        , testPrint "property" [ ps "p" ] """._test {
    p_key: p_val;
}"""
        , testPrint "property 2" [ ps "p1", ps "p2" ] """._test {
    p1_key: p1_val;
    p2_key: p2_val;
}"""
        , testPrint "nest class"
            [ ps "p1"
            , withClass "class" [ ps "c1", ps "c2" ]
            , ps "p2"
            ]
            """._test {
    p1_key: p1_val;
    p2_key: p2_val;
}

._test.class {
    c1_key: c1_val;
    c2_key: c2_val;
}"""
        , testPrint "nest 2"
            [ ps "p1"
            , withClass "class"
                [ ps "c1"
                , ps "c2"
                , withChildren [ tag "tag", everyTag ]
                    [ ps "child1", ps "child2" ]
                ]
            , ps "p2"
            ]
            """._test {
    p1_key: p1_val;
    p2_key: p2_val;
}

._test.class {
    c1_key: c1_val;
    c2_key: c2_val;
}

._test.class > tag, ._test.class > * {
    child1_key: child1_val;
    child2_key: child2_val;
}"""
        , testPrint "combinators"
            [ ps "p1"
            , withChildren [ tag "tag1", everyTag ]
                [ ps "c"
                , withDescendants [ tag "tag2", everyTag ] [ ps "d" ]
                ]
            , withGeneralSiblings [ tag "tag3", everyTag ] [ ps "g" ]
            , withAdjacentSiblings [ tag "tag4", everyTag ] [ ps "a" ]
            , ps "p2"
            ]
            """._test {
    p1_key: p1_val;
    p2_key: p2_val;
}

._test > tag1, ._test > * {
    c_key: c_val;
}

._test > tag1 tag2, ._test > tag1 *, ._test > * tag2, ._test > * * {
    d_key: d_val;
}

._test ~ tag3, ._test ~ * {
    g_key: g_val;
}

._test + tag4, ._test + * {
    a_key: a_val;
}"""
        , testPrint "media"
            [ ps "p1"
            , withMedia "screen and (max-width: 1200px)"
                [ ps "m"
                , withClass "class" [ ps "c" ]
                ]
            , ps "p2"
            ]
            """._test {
    p1_key: p1_val;
    p2_key: p2_val;
}

@media screen and (max-width: 1200px) {
    ._test {
        m_key: m_val;
    }
}

@media screen and (max-width: 1200px) {
    ._test.class {
        c_key: c_val;
    }
}"""
        , testPrint "animation"
            [ ps "p1"
            , withMedia "screen and (max-width: 1200px)"
                [ ps "m"
                , animation [ ( ( from, [] ), [ p "p" ] ) ]
                ]
            , animation [ ( ( from, [] ), [ p "p" ] ) ]
            , ps "p2"
            ]
            """._test {
    p1_key: p1_val;
    animation-name: _keyframes_f89d3c68;
    p2_key: p2_val;
}

@media screen and (max-width: 1200px) {
    ._test {
        m_key: m_val;
        animation-name: _keyframes_f89d3c68;
    }
}

@keyframes _keyframes_f89d3c68 {
    from {
        p_key: p_val;
    }
}

@keyframes _keyframes_f89d3c68 {
    from {
        p_key: p_val;
    }
}"""
        , testPrint "pseudoElement"
            [ ps "p1"
            , withPseudoElement "after" [ ps "a" ]
            , withPseudoElement "before" [ ps "b" ]
            , ps "p2"
            ]
            """._test {
    p1_key: p1_val;
    p2_key: p2_val;
}

._test::after {
    a_key: a_val;
}

._test::before {
    b_key: b_val;
}"""
        , testPrint "selector"
            [ ps "p1"
            , with (pseudoElement [ class "class" ] [ descendant (tag "tag") [ attribute "attr" ] ] "after") [ ps "s" ]
            , ps "p2"
            ]
            """._test {
    p1_key: p1_val;
    p2_key: p2_val;
}

._test.class tag[attr]::after {
    s_key: s_val;
}"""
        ]


testPrint : String -> List Style -> String -> Test
testPrint label input result =
    test label <| \() -> flatten input |> compile "_test" |> print |> equal result
