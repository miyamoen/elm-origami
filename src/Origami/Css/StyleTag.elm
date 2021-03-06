module Origami.Css.StyleTag exposing
    ( Block(..)
    , KeyframesSelector(..)
    , KeyframesStyleBlock
    , NonEmptyList
    , Properties
    , Property(..)
    , Selector(..)
    , print
    , printKeyframeSelector
    )

{-| A representation of the structure of a style tag.
-}

import Origami.Css.Selector as Selector exposing (MediaQuery(..), PseudoElement(..))


{-| A property consisting of key and value string.
-}
type Property
    = Property String String


type alias Properties =
    List Property


{-|

  - `MediaRule`: an [`@media`](https://developer.mozilla.org/docs/Web/CSS/@media) rule.
  - `FontFace`: an [`@font-face`](https://developer.mozilla.org/docs/Web/CSS/@font-face) rule.
  - `Keyframes`: an [`@keyframes`](https://developer.mozilla.org/docs/Web/CSS/@keyframes) rule.

-}
type Block
    = StyleBlock Selector Properties
    | MediaBlock MediaQuery (List Block)
    | FontFaceBlock Properties
    | KeyframesBlock String (List KeyframesStyleBlock)


{-| inline CSSから変換するのでSelectorはhash値のclass selector始まりに限定している
-}
type Selector
    = Selector String Selector.Single (List Selector.Single)
    | CustomSelector String


type alias KeyframesStyleBlock =
    ( NonEmptyList KeyframesSelector, Properties )


type KeyframesSelector
    = KeyframesSelectorFrom
    | KeyframesSelectorTo
    | KeyframesSelectorPercent Float


type alias NonEmptyList a =
    ( a, List a )


print : List Block -> String
print block =
    String.join "\n\n" (List.map (printBlock noIndent) block)


printBlock : String -> Block -> String
printBlock indentLevel block =
    case block of
        StyleBlock selector properties ->
            printStyleBlock indentLevel selector properties

        MediaBlock (MediaQuery query) blocks ->
            String.join ""
                [ indentLevel
                , "@media "
                , query
                , " {\n"
                , String.join "\n\n" (List.map (printBlock (indentLevel ++ spaceIndent)) blocks)
                , "\n"
                , indentLevel
                , "}"
                ]

        FontFaceBlock properties ->
            String.join ""
                [ indentLevel
                , "@font-face {\n"
                , printProperties (indentLevel ++ spaceIndent) properties
                , "\n"
                , indentLevel
                , "}"
                ]

        KeyframesBlock name blocks ->
            String.join ""
                [ indentLevel
                , "@keyframes "
                , name
                , " {\n"
                , List.map (printKeyframesStyleBlock (indentLevel ++ spaceIndent)) blocks
                    |> String.join "\n\n"
                , "\n"
                , indentLevel
                , "}"
                ]


printStyleBlock : String -> Selector -> Properties -> String
printStyleBlock indentLevel selector properties =
    String.join ""
        [ indentLevel
        , printSelector selector
        , " {\n"
        , printProperties (indentLevel ++ spaceIndent) properties
        , "\n"
        , indentLevel
        , "}"
        ]


printSelector : Selector -> String
printSelector selector =
    case selector of
        Selector classname s ss ->
            List.map (printSingleSelector classname) (s :: ss)
                |> String.join ", "

        CustomSelector raw ->
            raw


printSingleSelector : String -> Selector.Single -> String
printSingleSelector classname (Selector.Single repeatables pseudo) =
    String.concat <|
        "."
            :: classname
            :: List.map printRepeatableSelector repeatables
            ++ [ Maybe.map printPseudoElement pseudo |> Maybe.withDefault "" ]


printSelectorTag : Selector.Tag -> String
printSelectorTag tag =
    case tag of
        Selector.TypeSelector element ->
            element

        Selector.UniversalSelector ->
            "*"


printRepeatableSelector : Selector.Repeatable -> String
printRepeatableSelector repeatable =
    case repeatable of
        Selector.ClassSelector classname ->
            "." ++ classname

        Selector.PseudoClassSelector pseudoClass ->
            ":" ++ pseudoClass

        Selector.AttributeSelector attr ->
            String.concat [ "[", attr, "]" ]

        Selector.DescendantCombinator tag ->
            " " ++ printSelectorTag tag

        Selector.ChildCombinator tag ->
            " > " ++ printSelectorTag tag

        Selector.GeneralSiblingCombinator tag ->
            " ~ " ++ printSelectorTag tag

        Selector.AdjacentSiblingCombinator tag ->
            " + " ++ printSelectorTag tag


printPseudoElement : PseudoElement -> String
printPseudoElement (PseudoElement element) =
    "::" ++ element


printKeyframesStyleBlock : String -> ( NonEmptyList KeyframesSelector, Properties ) -> String
printKeyframesStyleBlock indentLevel ( ( selector, selectors ), properties ) =
    String.join ""
        [ indentLevel
        , List.map printKeyframeSelector (selector :: selectors) |> String.join ", "
        , " {\n"
        , printProperties (indentLevel ++ spaceIndent) properties
        , "\n"
        , indentLevel
        , "}"
        ]


printKeyframeSelector : KeyframesSelector -> String
printKeyframeSelector selector =
    case selector of
        KeyframesSelectorTo ->
            "to"

        KeyframesSelectorFrom ->
            "from"

        KeyframesSelectorPercent value ->
            String.fromFloat value ++ "%"


printProperties : String -> Properties -> String
printProperties indentLevel properties =
    List.map (\property -> printProperty property) properties
        |> String.join ("\n" ++ indentLevel)
        |> (++) indentLevel


printProperty : Property -> String
printProperty (Property key value) =
    key ++ ": " ++ value ++ ";"


spaceIndent : String
spaceIndent =
    "    "


noIndent : String
noIndent =
    ""
