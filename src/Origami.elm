module Origami exposing
    ( Style, property, batch
    , withClass, withAttribute, withPseudoClass, withPseudoElement, withMedia
    , withDescendants, withChildren, withGeneralSiblings, withAdjacentSiblings
    , Tag, tag, everyTag
    , RepeatableSelector, class, pseudoClass, attribute
    , with, withEach
    , Selector, selector, s, pseudoElement
    , SelectorSequence, descendant, child, generalSibling, adjacentSibling
    , withCustom
    , qt
    )

{-|

@docs Style, property, batch


## Nested Style

@docs withClass, withAttribute, withPseudoClass, withPseudoElement, withMedia

@docs withDescendants, withChildren, withGeneralSiblings, withAdjacentSiblings
@docs Tag, tag, everyTag
@docs RepeatableSelector, class, pseudoClass, attribute


## Custom

@docs with, withEach
@docs Selector, selector, s, pseudoElement
@docs SelectorSequence, descendant, child, generalSibling, adjacentSibling

@docs withCustom


## Helper

@docs qt

-}

import Origami.Css.Selector exposing (MediaQuery(..))
import Origami.Css.Style as Style
import Origami.Css.StyleTag exposing (Property(..))


{-| -}
type alias Style =
    Style.Style


type alias Selector =
    Origami.Css.Selector.Single


type alias RepeatableSelector =
    Origami.Css.Selector.Repeatable


type alias SelectorSequence =
    Origami.Css.Selector.Sequence


type alias Tag =
    Origami.Css.Selector.Head


{-| Create a property style.

    css [ property "-webkit-font-smoothing" "none" ]

...outputs

    -webkit-font-smoothing: none;

-}
property : String -> String -> Style
property key value =
    Property key value
        |> Style.PropertyStyle


{-| Create a batched style.

    underlineOnHover =
        batch
            [ textDecoration none
            , hover
                [ textDecoration underline ]
            ]

    css
        [ color (rgb 128 64 32)
        , underlineOnHover
        ]

...has the same result as:

    css
        [ color (rgb 128 64 32)
        , textDecoration none
        , hover
            [ textDecoration underline ]
        ]

-}
batch : List Style -> Style
batch =
    Style.BatchedStyle



----------------
-- NestedStyle
----------------


{-| Create a nested style.
-}
withCustom : List Selector -> String -> List Style -> Style
withCustom ss mq =
    Style.NestedStyle (Origami.Css.Selector.Selector ss <| Just <| MediaQuery mq)


with : Selector -> List Style -> Style
with s_ =
    Style.NestedStyle (Origami.Css.Selector.Selector [ s_ ] Nothing)


withEach : List Selector -> List Style -> Style
withEach ss =
    Style.NestedStyle (Origami.Css.Selector.Selector ss Nothing)


withMedia : String -> List Style -> Style
withMedia mq =
    Style.NestedStyle (Origami.Css.Selector.Selector [] <| Just <| MediaQuery mq)


selector : List RepeatableSelector -> List SelectorSequence -> Selector
selector rs ss =
    Origami.Css.Selector.Single rs ss Nothing


s : List RepeatableSelector -> List SelectorSequence -> Selector
s =
    selector


pseudoElement : List RepeatableSelector -> List SelectorSequence -> String -> Selector
pseudoElement rs ss pe =
    Origami.Css.Selector.Single rs ss <| Just <| Origami.Css.Selector.PseudoElement pe


class : String -> RepeatableSelector
class =
    Origami.Css.Selector.ClassSelector


pseudoClass : String -> RepeatableSelector
pseudoClass =
    Origami.Css.Selector.PseudoClassSelector


attribute : String -> RepeatableSelector
attribute =
    Origami.Css.Selector.AttributeSelector


descendant : Tag -> List RepeatableSelector -> SelectorSequence
descendant =
    Origami.Css.Selector.Sequence Origami.Css.Selector.DescendantCombinator


child : Tag -> List RepeatableSelector -> SelectorSequence
child =
    Origami.Css.Selector.Sequence Origami.Css.Selector.ChildCombinator


generalSibling : Tag -> List RepeatableSelector -> SelectorSequence
generalSibling =
    Origami.Css.Selector.Sequence Origami.Css.Selector.GeneralSiblingCombinator


adjacentSibling : Tag -> List RepeatableSelector -> SelectorSequence
adjacentSibling =
    Origami.Css.Selector.Sequence Origami.Css.Selector.AdjacentSiblingCombinator


tag : String -> Tag
tag =
    Origami.Css.Selector.TypeSelector


everyTag : Tag
everyTag =
    Origami.Css.Selector.UniversalSelector



----------------
-- NestedStyle
-- shorthand
----------------


withClass : String -> List Style -> Style
withClass val =
    with (s [ class val ] [])


withAttribute : String -> List Style -> Style
withAttribute val =
    with (s [ attribute val ] [])


withPseudoClass : String -> List Style -> Style
withPseudoClass val =
    with (s [ pseudoClass val ] [])


withPseudoElement : String -> List Style -> Style
withPseudoElement val =
    with (pseudoElement [] [] val)


withDescendants : List ( Tag, List RepeatableSelector ) -> List Style -> Style
withDescendants vals =
    withEach <| List.map (\( t, rs ) -> s [] [ descendant t rs ]) vals


withChildren : List ( Tag, List RepeatableSelector ) -> List Style -> Style
withChildren vals =
    withEach <| List.map (\( t, rs ) -> s [] [ child t rs ]) vals


withGeneralSiblings : List ( Tag, List RepeatableSelector ) -> List Style -> Style
withGeneralSiblings vals =
    withEach <| List.map (\( t, rs ) -> s [] [ generalSibling t rs ]) vals


withAdjacentSiblings : List ( Tag, List RepeatableSelector ) -> List Style -> Style
withAdjacentSiblings vals =
    withEach <| List.map (\( t, rs ) -> s [] [ adjacentSibling t rs ]) vals



----------------
-- Helper
----------------


{-| For use with [`font-family`](https://developer.mozilla.org/docs/Web/CSS/font-family)

    property "font-family" (qt "Gill Sans Extrabold")

-}
qt : String -> String
qt str =
    String.concat [ "\"", str, "\"" ]
