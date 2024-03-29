module Origami.Css.Style exposing (FlatStyle(..), Style(..), compile, flatten, hashToClassname)

{-| -}

import Hash
import Origami.Css.Selector as Selector exposing (Selector(..), listToString)
import Origami.Css.StyleTag as StyleTag exposing (Block(..), KeyframesStyleBlock, Properties, Property(..))


{-| ユーザー露出する構文的な型
-}
type Style
    = PropertyStyle Property
    | BatchedStyle (List Style)
    | NestedStyle Selector (List Style)
      -- NestedStyleとAnimationStyleを入れても無視される
    | AnimationStyle (List ( String, List Style ))


{-| Styleの再帰構造をフラットにした型
-}
type FlatStyle
    = FlatStyle Selector Properties
    | FlatAnimationStyle String (List KeyframesStyleBlock)


flatten : List Style -> List FlatStyle
flatten styles =
    case List.foldr (walk Selector.initial) ( [], [] ) styles of
        ( [], flatStyles ) ->
            flatStyles

        ( properties, flatStyles ) ->
            FlatStyle Selector.initial properties :: flatStyles


walk : Selector -> Style -> ( Properties, List FlatStyle ) -> ( Properties, List FlatStyle )
walk parentSelector style ( properties, styles ) =
    case style of
        PropertyStyle property ->
            ( property :: properties, styles )

        BatchedStyle batched ->
            List.foldr (walk parentSelector) ( properties, styles ) batched

        NestedStyle childSelector childStyles ->
            case Selector.nest parentSelector childSelector of
                Nothing ->
                    ( properties, styles )

                Just nested ->
                    case List.foldr (walk nested) ( [], styles ) childStyles of
                        ( [], flatStyles ) ->
                            ( properties, flatStyles )

                        ( childProperties, flatStyles ) ->
                            ( properties, FlatStyle nested childProperties :: flatStyles )

        -- **CONSIDER**: 同じkeyframes定義があったら同じものが２個生成されてしまうが許容
        AnimationStyle keyframes ->
            case List.map (\( selector, block ) -> ( selector, List.foldr walkInAnimation [] block )) keyframes of
                [] ->
                    ( properties, styles )

                nonEmpty ->
                    let
                        animationName =
                            hashToAnimationName nonEmpty
                    in
                    ( Property "animation-name" animationName :: properties, FlatAnimationStyle animationName nonEmpty :: styles )


walkInAnimation : Style -> Properties -> Properties
walkInAnimation style properties =
    case style of
        PropertyStyle property ->
            property :: properties

        BatchedStyle batched ->
            List.foldr walkInAnimation properties batched

        _ ->
            properties


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
        FlatStyle (Selector selector Nothing) ps ->
            StyleBlock (StyleTag.Selector classname selector) ps

        FlatStyle (Selector selector (Just mq)) ps ->
            MediaBlock mq [ StyleBlock (StyleTag.Selector classname selector) ps ]

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
keyframesStyleBlockToString ( s, ps ) =
    String.concat
        [ "(\""
        , s
        , "\""
        , List.map propertyToString ps |> listToString
        , ")"
        ]


propertyToString : Property -> String
propertyToString (Property key val) =
    String.concat [ "(Property\"", key, "\" \"", val, "\")" ]
