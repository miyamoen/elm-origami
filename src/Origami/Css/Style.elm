module Origami.Css.Style exposing (FlatStyle, Style(..), compile, flatten, hashToClassname)

{-| -}

import Hash
import Origami.Css.Selector as Selector exposing (Selector(..), listToString)
import Origami.Css.StyleTag as StyleTag exposing (Block(..), KeyframeSelector(..), KeyframesStyleBlock, Properties, Property(..))


{-| ユーザー露出する構文的な型
-}
type Style
    = PropertyStyle Property
    | BatchStyles (List Style)
    | NestedStyle Selector (List Style)
    | AnimationStyle (List KeyframesStyleBlock)


{-| Styleの再帰構造をフラットにした型
-}
type FlatStyle
    = FlatStyle Selector Properties
    | FlatAnimationStyle String (List KeyframesStyleBlock)


flatten : List Style -> List FlatStyle
flatten styles =
    case styles of
        [] ->
            []

        nonEmpty ->
            let
                ( properties, accStyles ) =
                    List.foldr (walk Selector.empty) ( [], [] ) nonEmpty
            in
            FlatStyle Selector.empty properties :: accStyles


walk : Selector -> Style -> ( Properties, List FlatStyle ) -> ( Properties, List FlatStyle )
walk currentSelector style ( properties, styles ) =
    case style of
        PropertyStyle property ->
            ( property :: properties, styles )

        BatchStyles batched ->
            List.foldr (walk currentSelector) ( properties, styles ) batched

        NestedStyle _ [] ->
            ( properties, styles )

        NestedStyle nestSelector nestStyles ->
            case Selector.nest currentSelector nestSelector of
                Nothing ->
                    ( properties, styles )

                Just combined ->
                    let
                        ( nestProperties, accStyles ) =
                            List.foldr (walk combined) ( [], styles ) nestStyles
                    in
                    ( properties, FlatStyle combined nestProperties :: accStyles )

        AnimationStyle keyframesStyleBlocks ->
            let
                animationName =
                    hashToAnimationName keyframesStyleBlocks
            in
            ( Property "animation-name" animationName :: properties, FlatAnimationStyle animationName keyframesStyleBlocks :: styles )


compile : String -> List FlatStyle -> List Block
compile classname styles =
    List.map (toBlock classname) styles


{-| **CONSIDER**: media queryのネスト

  - media queryから更にネストすると`@media`がその分生成される
      - ネストすることはあんまりなさそう
  - media queryをキーにして集めてまとめることはできると思う
      - 記述順を維持したままやるのが難しそう

-}
toBlock : String -> FlatStyle -> Block
toBlock classname style =
    case style of
        FlatStyle (Selector rs ss pe Nothing) ps ->
            StyleBlock (StyleTag.Selector classname rs ss pe) ps

        FlatStyle (Selector rs ss pe (Just mq)) ps ->
            MediaBlock mq [ StyleBlock (StyleTag.Selector classname rs ss pe) ps ]

        FlatAnimationStyle an bs ->
            KeyframesBlock an bs



----------------
-- hash
----------------


hashToClassname : List FlatStyle -> String
hashToClassname styles =
    List.map flatStyleToString styles
        |> listToString
        |> Hash.fromString
        |> (++) "_"


hashToAnimationName : List KeyframesStyleBlock -> String
hashToAnimationName blocks =
    List.map keyframesStyleBlockToString blocks
        |> listToString
        |> Hash.fromString
        |> (++) "_keyframes_"


flatStyleToString : FlatStyle -> String
flatStyleToString style =
    case style of
        FlatStyle s ps ->
            String.concat
                [ "(FlatStyle"
                , Selector.toString s
                , List.map propertyToString ps |> listToString
                , ")"
                ]

        FlatAnimationStyle name kfbs ->
            String.concat
                [ "(FlatAnimationStyle\""
                , name
                , "\""
                , List.map keyframesStyleBlockToString kfbs |> listToString
                , ")"
                ]


keyframesStyleBlockToString : KeyframesStyleBlock -> String
keyframesStyleBlockToString ( ( s, ss ), ps ) =
    String.concat
        [ "(("
        , keyframeSelectorToString s
        , ","
        , List.map keyframeSelectorToString ss |> listToString
        , "),"
        , List.map propertyToString ps |> listToString
        , ")"
        ]


propertyToString : Property -> String
propertyToString (Property key val) =
    String.concat [ "(Property\"", key, "\" \"", val, "\")" ]


keyframeSelectorToString : KeyframeSelector -> String
keyframeSelectorToString s =
    case s of
        KeyframeSelectorFrom ->
            "(KeyframeSelectorFrom)"

        KeyframeSelectorTo ->
            "(KeyframeSelectorTo)"

        KeyframeSelectorPercent val ->
            String.concat [ "(KeyframeSelectorPercent ", String.fromFloat val, ")" ]
