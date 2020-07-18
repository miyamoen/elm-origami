module Origami.Css.Block exposing
    ( Block(..)
    , KeyframeSelector(..)
    , KeyframesStyleBlock
    , MediaQuery(..)
    , NonEmptyList
    , Properties
    , Property(..)
    , Selector(..)
    , print
    , printKeyframeSelector
    )

{-| A representation of the structure of a stylesheet. This module is concerned
solely with representing valid stylesheets; it is not concerned with the
elm-css DSL, collecting warnings, or
-}


{-| A property consisting of a key:value string.
-}
type Property
    = Property String String


type alias Properties =
    List Property


{-| A Declaration, meaning either a [`StyleBlock`](#StyleBlock) declaration
or an [at-rule](https://developer.mozilla.org/docs/Web/CSS/At-rule)
declaration. Since each at-rule works differently, the supported ones are
enumerated as follows.

  - `MediaRule`: an [`@media`](https://developer.mozilla.org/docs/Web/CSS/@media) rule.
  - `SupportsRule`: an [`@supports`](https://developer.mozilla.org/docs/Web/CSS/@supports) rule.
  - `DocumentRule`: an [`@document`](https://developer.mozilla.org/docs/Web/CSS/@document) rule.
  - `PageRule`: an [`@page`](https://developer.mozilla.org/docs/Web/CSS/@page) rule.
  - `FontFace`: an [`@font-face`](https://developer.mozilla.org/docs/Web/CSS/@font-face) rule.
  - `Keyframes`: an [`@keyframes`](https://developer.mozilla.org/docs/Web/CSS/@keyframes) rule.
  - `Viewport`: an [`@viewport`](https://developer.mozilla.org/docs/Web/CSS/@viewport) rule.
  - `CounterStyle`: an [`@counter-style`](https://developer.mozilla.org/docs/Web/CSS/@counter-style) rule.
  - `FontFeatureValues`: an [`@font-feature-values`](https://developer.mozilla.org/docs/Web/CSS/@font-feature-values) rule.

-}
type Block
    = StyleBlock Selector Properties
    | MediaBlock MediaQuery (List Block)
    | FontFaceBlock Properties
    | KeyframesBlock String (List KeyframesStyleBlock)


type Selector
    = ClassSelector String
    | CustomSelector String


type MediaQuery
    = MediaQuery String


type alias KeyframesStyleBlock =
    ( NonEmptyList KeyframeSelector, Properties )


type KeyframeSelector
    = KeyframeSelectorFrom
    | KeyframeSelectorTo
    | KeyframeSelectorPercent Float


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
                , "@font-face  {\n"
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
        ClassSelector classname ->
            "." ++ classname

        CustomSelector raw ->
            raw


printKeyframesStyleBlock : String -> ( NonEmptyList KeyframeSelector, Properties ) -> String
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


printKeyframeSelector : KeyframeSelector -> String
printKeyframeSelector selector =
    case selector of
        KeyframeSelectorTo ->
            "to"

        KeyframeSelectorFrom ->
            "from"

        KeyframeSelectorPercent value ->
            String.fromFloat value ++ "%"


printProperties : String -> Properties -> String
printProperties indentLevel properties =
    List.map (\property -> printProperty property) properties
        |> String.join (indentLevel ++ "\n")
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
