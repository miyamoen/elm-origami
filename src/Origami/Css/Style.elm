module Origami.Css.Style exposing (FlatStyle, Style(..), compile, flatten, hashToClassname)

{-| -}

import Hash
import Origami.Css.Selector as Selector exposing (Selector(..), listToString)
import Origami.Css.StyleTag as StyleTag exposing (Block(..), KeyframeSelector(..), KeyframesStyleBlock, Properties, Property(..))


{-| ユーザー露出する構文的な型
-}
type Style
    = PropertyStyle Property
    | BatchedStyle (List Style)
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
                    List.foldr (walk Selector.initial) ( [], [] ) nonEmpty
            in
            FlatStyle Selector.initial properties :: accStyles


walk : Selector -> Style -> ( Properties, List FlatStyle ) -> ( Properties, List FlatStyle )
walk parentSelector style ( properties, styles ) =
    case style of
        PropertyStyle property ->
            ( property :: properties, styles )

        BatchedStyle batched ->
            List.foldr (walk parentSelector) ( properties, styles ) batched

        NestedStyle _ [] ->
            ( properties, styles )

        NestedStyle childSelector childStyles ->
            case Selector.nest parentSelector childSelector of
                Nothing ->
                    ( properties, styles )

                Just nested ->
                    let
                        ( childProperties, accStyles ) =
                            List.foldr (walk nested) ( [], styles ) childStyles
                    in
                    ( properties, FlatStyle nested childProperties :: accStyles )

        AnimationStyle keyframesStyleBlocks ->
            case keyframesStyleBlocks of
                [] ->
                    ( properties, styles )

                nonEmpty ->
                    let
                        animationName =
                            hashToAnimationName nonEmpty
                    in
                    ( Property "animation-name" animationName :: properties, FlatAnimationStyle animationName nonEmpty :: styles )


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
        FlatStyle (Selector selectors Nothing) ps ->
            StyleBlock (convertSelector classname selectors) ps

        FlatStyle (Selector selectors (Just mq)) ps ->
            MediaBlock mq [ StyleBlock (convertSelector classname selectors) ps ]

        FlatAnimationStyle an bs ->
            KeyframesBlock an bs


convertSelector : String -> List Selector.Single -> StyleTag.Selector
convertSelector classname selectors =
    StyleTag.Selector <| List.map (convertSingleSelector classname) selectors


convertSingleSelector : String -> Selector.Single -> StyleTag.SingleSelector
convertSingleSelector classname (Selector.Single rs ss pe) =
    StyleTag.SingleSelector classname rs ss pe



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
