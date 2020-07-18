module Origami.Css.Style exposing (AccBlock, Style(..), accBlocksMerge, build, compile)

{-| A representation of the preprocessing to be done. The elm-css DSL generates
the data structures found in this module.
-}

import Dict exposing (Dict)
import Hash
import Origami.Css.Block exposing (..)


type Style
    = PropertyStyle Property
    | BatchStyles (List Style)
    | MediaStyle MediaQuery (List Style)
    | AnimationStyle (List KeyframesStyleBlock)


type AccBlock
    = AccStyleBlock Selector Properties
    | AccMediaBlock MediaQuery (Dict String AccBlock)
    | AccKeyframesBlock String (List KeyframesStyleBlock)


type alias AccumulatedStyle =
    { classnames : List String
    , blocks : Dict String AccBlock
    }


build : Dict String AccBlock -> List Block
build blocks =
    Dict.values blocks
        |> List.map buildHelp


buildHelp : AccBlock -> Block
buildHelp block =
    case block of
        AccStyleBlock selector properties ->
            StyleBlock selector properties

        AccMediaBlock query blocks ->
            MediaBlock query <| build blocks

        AccKeyframesBlock name keyframesBlocks ->
            KeyframesBlock name keyframesBlocks


compile : List Style -> AccumulatedStyle
compile styles =
    compileHelp "" styles


compileHelp : String -> List Style -> AccumulatedStyle
compileHelp classnameContext styles =
    let
        ( properties, { classnames, blocks } ) =
            List.foldr (walk classnameContext) ( [], { classnames = [], blocks = Dict.empty } ) styles

        styleBlockClassname =
            classnameContext ++ hashToStyleBlockClassname properties
    in
    { classnames = styleBlockClassname :: classnames
    , blocks = Dict.insert styleBlockClassname (AccStyleBlock (ClassSelector styleBlockClassname) properties) blocks
    }


walk : String -> Style -> ( List Property, AccumulatedStyle ) -> ( List Property, AccumulatedStyle )
walk classnameContext style ( properties, compiled ) =
    case style of
        PropertyStyle property ->
            ( property :: properties, compiled )

        BatchStyles batched ->
            List.foldr (walk classnameContext) ( properties, compiled ) batched

        MediaStyle query styles ->
            let
                queryHash =
                    classnameContext ++ hashMediaQuery query

                mediaCompiled =
                    compileHelp queryHash styles
            in
            ( properties
            , { classnames = mediaCompiled.classnames ++ compiled.classnames
              , blocks =
                    Dict.update queryHash
                        (\maybeMedia ->
                            case maybeMedia of
                                Nothing ->
                                    Just <| AccMediaBlock query mediaCompiled.blocks

                                Just (AccMediaBlock _ blocks) ->
                                    Just <| AccMediaBlock query <| accBlocksMerge mediaCompiled.blocks blocks

                                -- should not happen! Hash計算が正しければPreMediaBlock以外は引っかからない
                                _ ->
                                    Just <| AccMediaBlock query mediaCompiled.blocks
                        )
                        compiled.blocks
              }
            )

        AnimationStyle keyframesStyleBlocks ->
            let
                animationName =
                    classnameContext ++ hashToAnimationName keyframesStyleBlocks
            in
            ( Property "animation-name" animationName :: properties
            , { compiled | blocks = Dict.insert animationName (AccKeyframesBlock animationName keyframesStyleBlocks) compiled.blocks }
            )


accBlocksMerge : Dict String AccBlock -> Dict String AccBlock -> Dict String AccBlock
accBlocksMerge left right =
    Dict.merge
        Dict.insert
        (\hash leftBlock rightBlock result -> Dict.insert hash (accBlockMerge leftBlock rightBlock) result)
        Dict.insert
        left
        right
        Dict.empty


accBlockMerge : AccBlock -> AccBlock -> AccBlock
accBlockMerge left right =
    case ( left, right ) of
        ( AccMediaBlock query leftBlocks, AccMediaBlock _ rightBlocks ) ->
            AccMediaBlock query <| accBlocksMerge leftBlocks rightBlocks

        _ ->
            left


hashToStyleBlockClassname : Properties -> String
hashToStyleBlockClassname properties =
    toPropertiesString properties
        |> Hash.fromString
        |> (++) "_style_"


hashToAnimationName : List KeyframesStyleBlock -> String
hashToAnimationName blocks =
    List.map toKeyframesBlockString blocks
        |> String.join " "
        |> Hash.fromString
        |> (++) "_keyframes_"


hashMediaQuery : MediaQuery -> String
hashMediaQuery (MediaQuery query) =
    "_media_" ++ Hash.fromString query


toPropertiesString : Properties -> String
toPropertiesString properties =
    List.concatMap (\(Property attr value) -> [ attr, ":", value ]) properties
        |> String.join ";"


toKeyframesBlockString : KeyframesStyleBlock -> String
toKeyframesBlockString ( ( selector, selectors ), properties ) =
    String.join ","
        [ List.map printKeyframeSelector (selector :: selectors)
            |> String.join ","
        , toPropertiesString properties
        ]
