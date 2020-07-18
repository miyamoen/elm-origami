module Origami.VirtualDom exposing
    ( Node, text, node, nodeNS
    , Attribute(..), style, property, attribute, attributeNS, batchAttributes
    , on
    , map, mapAttribute
    , keyedNode, keyedNodeNS
    , lazy, lazy2, lazy3, lazy4, lazy5, lazy6, lazy7
    , css, toPlainNode, toPlainNodes, plainNode, plainAttribute
    )

{-|


# Create

@docs Node, text, node, nodeNS


# Attributes

@docs Attribute, style, property, attribute, attributeNS, batchAttributes


# Events

@docs on


# Routing Messages

@docs map, mapAttribute


# Keyed Nodes

@docs keyedNode, keyedNodeNS


# Lazy Nodes

@docs lazy, lazy2, lazy3, lazy4, lazy5, lazy6, lazy7


# Style

@docs css, toPlainNode, toPlainNodes, plainNode, plainAttribute

-}

import Dict exposing (Dict)
import Json.Encode
import Origami.Css.Block
import Origami.Css.Style exposing (AccBlock, Style, accBlocksMerge)
import VirtualDom


type Node msg
    = Node String (List (Attribute msg)) (List (Node msg))
    | NodeNS String String (List (Attribute msg)) (List (Node msg))
    | KeyedNode String (List (Attribute msg)) (List ( String, Node msg ))
    | KeyedNodeNS String String (List (Attribute msg)) (List ( String, Node msg ))
    | PlainNode (VirtualDom.Node msg)


type Attribute msg
    = Attribute (List (VirtualDom.Attribute msg)) (Dict String AccBlock)


node : String -> List (Attribute msg) -> List (Node msg) -> Node msg
node =
    Node


nodeNS : String -> String -> List (Attribute msg) -> List (Node msg) -> Node msg
nodeNS =
    NodeNS


keyedNode :
    String
    -> List (Attribute msg)
    -> List ( String, Node msg )
    -> Node msg
keyedNode =
    KeyedNode


keyedNodeNS : String -> String -> List (Attribute msg) -> List ( String, Node msg ) -> Node msg
keyedNodeNS =
    KeyedNodeNS


plainNode : VirtualDom.Node msg -> Node msg
plainNode =
    PlainNode


text : String -> Node msg
text str =
    PlainNode (VirtualDom.text str)


map : (a -> b) -> Node a -> Node b
map transform vdomNode =
    case vdomNode of
        Node elemType attributes children ->
            Node
                elemType
                (List.map (mapAttribute transform) attributes)
                (List.map (map transform) children)

        NodeNS ns elemType attributes children ->
            NodeNS ns
                elemType
                (List.map (mapAttribute transform) attributes)
                (List.map (map transform) children)

        KeyedNode elemType attributes children ->
            KeyedNode
                elemType
                (List.map (mapAttribute transform) attributes)
                (List.map (\( key, child ) -> ( key, map transform child )) children)

        KeyedNodeNS ns elemType attributes children ->
            KeyedNodeNS ns
                elemType
                (List.map (mapAttribute transform) attributes)
                (List.map (\( key, child ) -> ( key, map transform child )) children)

        PlainNode vdom ->
            VirtualDom.map transform vdom
                |> PlainNode


property : String -> Json.Encode.Value -> Attribute msg
property key value =
    plainAttribute (VirtualDom.property key value)


attribute : String -> String -> Attribute msg
attribute key value =
    plainAttribute (VirtualDom.attribute key value)


style : String -> String -> Attribute msg
style key val =
    plainAttribute (VirtualDom.style key val)


attributeNS : String -> String -> String -> Attribute msg
attributeNS namespace key value =
    plainAttribute (VirtualDom.attributeNS namespace key value)


plainAttribute : VirtualDom.Attribute msg -> Attribute msg
plainAttribute attr =
    Attribute [ attr ] Dict.empty


batchAttributes : List (Attribute msg) -> Attribute msg
batchAttributes =
    List.foldr (\(Attribute attrs blocks) ( accAttrs, accBlocks ) -> ( attrs ++ accAttrs, accBlocksMerge blocks accBlocks ))
        ( [], Dict.empty )
        >> (\( attrs, blocks ) -> Attribute attrs blocks)


on : String -> VirtualDom.Handler msg -> Attribute msg
on eventName handler =
    plainAttribute (VirtualDom.on eventName handler)


mapAttribute : (a -> b) -> Attribute a -> Attribute b
mapAttribute transform (Attribute attrs styles) =
    Attribute (List.map (VirtualDom.mapAttribute transform) attrs) styles


lazy : (a -> Node msg) -> a -> Node msg
lazy fn arg =
    VirtualDom.lazy2 lazyHelp fn arg
        |> PlainNode


lazyHelp : (a -> Node msg) -> a -> VirtualDom.Node msg
lazyHelp fn arg =
    fn arg
        |> toPlainNode


lazy2 : (a -> b -> Node msg) -> a -> b -> Node msg
lazy2 fn arg1 arg2 =
    VirtualDom.lazy3 lazyHelp2 fn arg1 arg2
        |> PlainNode


lazyHelp2 : (a -> b -> Node msg) -> a -> b -> VirtualDom.Node msg
lazyHelp2 fn arg1 arg2 =
    fn arg1 arg2
        |> toPlainNode


lazy3 : (a -> b -> c -> Node msg) -> a -> b -> c -> Node msg
lazy3 fn arg1 arg2 arg3 =
    VirtualDom.lazy4 lazyHelp3 fn arg1 arg2 arg3
        |> PlainNode


lazyHelp3 : (a -> b -> c -> Node msg) -> a -> b -> c -> VirtualDom.Node msg
lazyHelp3 fn arg1 arg2 arg3 =
    fn arg1 arg2 arg3
        |> toPlainNode


lazy4 : (a -> b -> c -> d -> Node msg) -> a -> b -> c -> d -> Node msg
lazy4 fn arg1 arg2 arg3 arg4 =
    VirtualDom.lazy5 lazyHelp4 fn arg1 arg2 arg3 arg4
        |> PlainNode


lazyHelp4 : (a -> b -> c -> d -> Node msg) -> a -> b -> c -> d -> VirtualDom.Node msg
lazyHelp4 fn arg1 arg2 arg3 arg4 =
    fn arg1 arg2 arg3 arg4
        |> toPlainNode


lazy5 : (a -> b -> c -> d -> e -> Node msg) -> a -> b -> c -> d -> e -> Node msg
lazy5 fn arg1 arg2 arg3 arg4 arg5 =
    VirtualDom.lazy6 lazyHelp5 fn arg1 arg2 arg3 arg4 arg5
        |> PlainNode


lazyHelp5 : (a -> b -> c -> d -> e -> Node msg) -> a -> b -> c -> d -> e -> VirtualDom.Node msg
lazyHelp5 fn arg1 arg2 arg3 arg4 arg5 =
    fn arg1 arg2 arg3 arg4 arg5
        |> toPlainNode


lazy6 : (a -> b -> c -> d -> e -> f -> Node msg) -> a -> b -> c -> d -> e -> f -> Node msg
lazy6 fn arg1 arg2 arg3 arg4 arg5 arg6 =
    VirtualDom.lazy7 lazyHelp6 fn arg1 arg2 arg3 arg4 arg5 arg6
        |> PlainNode


lazyHelp6 : (a -> b -> c -> d -> e -> f -> Node msg) -> a -> b -> c -> d -> e -> f -> VirtualDom.Node msg
lazyHelp6 fn arg1 arg2 arg3 arg4 arg5 arg6 =
    fn arg1 arg2 arg3 arg4 arg5 arg6
        |> toPlainNode


lazy7 : (a -> b -> c -> d -> e -> f -> g -> Node msg) -> a -> b -> c -> d -> e -> f -> g -> Node msg
lazy7 fn arg1 arg2 arg3 arg4 arg5 arg6 arg7 =
    VirtualDom.lazy8 lazyHelp7 fn arg1 arg2 arg3 arg4 arg5 arg6 arg7
        |> PlainNode


lazyHelp7 : (a -> b -> c -> d -> e -> f -> g -> Node msg) -> a -> b -> c -> d -> e -> f -> g -> VirtualDom.Node msg
lazyHelp7 fn arg1 arg2 arg3 arg4 arg5 arg6 arg7 =
    fn arg1 arg2 arg3 arg4 arg5 arg6 arg7
        |> toPlainNode


css : List Style -> Attribute msg
css styles =
    let
        { classnames, blocks } =
            Origami.Css.Style.compile styles
    in
    Attribute [ VirtualDom.property "className" (Json.Encode.string <| String.join " " classnames) ] blocks


toPlainNode : Node msg -> VirtualDom.Node msg
toPlainNode vdom =
    case vdom of
        PlainNode vdomNode ->
            vdomNode

        Node elemType attributes children ->
            let
                ( plainAttributes, childNodes, cssBlocks ) =
                    unstyle attributes children
            in
            VirtualDom.node elemType plainAttributes (toStyleNode cssBlocks :: childNodes)

        NodeNS ns elemType attributes children ->
            let
                ( plainAttributes, childNodes, cssBlocks ) =
                    unstyle attributes children
            in
            VirtualDom.nodeNS ns elemType plainAttributes (toStyleNode cssBlocks :: childNodes)

        KeyedNode elemType attributes children ->
            let
                ( plainAttributes, childNodes, cssBlocks ) =
                    unstyleKeyed attributes children
            in
            VirtualDom.keyedNode elemType plainAttributes (toKeyedStyleNode cssBlocks childNodes :: childNodes)

        KeyedNodeNS ns elemType attributes children ->
            let
                ( plainAttributes, childNodes, cssBlocks ) =
                    unstyleKeyed attributes children
            in
            VirtualDom.keyedNodeNS ns elemType plainAttributes (toKeyedStyleNode cssBlocks childNodes :: childNodes)


toPlainNodes : List (Node msg) -> List (VirtualDom.Node msg)
toPlainNodes vdoms =
    let
        ( childNodes, cssBlocks ) =
            List.foldr accumulateStyledHtml ( [], Dict.empty ) vdoms
    in
    toStyleNode cssBlocks :: childNodes



-- _/_/_/_/_/_/_/_/ --
-- INTERNAL
-- _/_/_/_/_/_/_/_/ --


unstyle : List (Attribute msg) -> List (Node msg) -> ( List (VirtualDom.Attribute msg), List (VirtualDom.Node msg), Dict String AccBlock )
unstyle attributes children =
    let
        ( plainAttributes, cssBlocks ) =
            partitionAttributes attributes

        ( childNodes, integratedCssBlocks ) =
            List.foldr accumulateStyledHtml ( [], cssBlocks ) children
    in
    ( plainAttributes, childNodes, integratedCssBlocks )


unstyleKeyed : List (Attribute msg) -> List ( String, Node msg ) -> ( List (VirtualDom.Attribute msg), List ( String, VirtualDom.Node msg ), Dict String AccBlock )
unstyleKeyed attributes keyedChildren =
    let
        ( plainAttributes, cssBlocks ) =
            partitionAttributes attributes

        ( keyedChildNodes, integratedCssBlocks ) =
            List.foldr accumulateKeyedStyledHtml ( [], cssBlocks ) keyedChildren
    in
    ( plainAttributes, keyedChildNodes, integratedCssBlocks )


toKeyedStyleNode :
    Dict String AccBlock
    -> List ( String, a )
    -> ( String, VirtualDom.Node msg )
toKeyedStyleNode cssBlocks keyedChildNodes =
    ( getUnusedKey keyedChildNodes, toStyleNode cssBlocks )


toStyleNode : Dict String AccBlock -> VirtualDom.Node msg
toStyleNode cssBlocks =
    Origami.Css.Style.build cssBlocks
        |> Origami.Css.Block.print
        |> VirtualDom.text
        |> List.singleton
        |> VirtualDom.node "style" []


partitionAttributes : List (Attribute msg) -> ( List (VirtualDom.Attribute msg), Dict String AccBlock )
partitionAttributes attributes =
    List.foldr (\(Attribute attrs blocks) ( accAttrs, accBlocks ) -> ( attrs ++ accAttrs, accBlocksMerge blocks accBlocks ))
        ( [], Dict.empty )
        attributes


accumulateStyledHtml :
    Node msg
    -> ( List (VirtualDom.Node msg), Dict String AccBlock )
    -> ( List (VirtualDom.Node msg), Dict String AccBlock )
accumulateStyledHtml styledNode ( accNodes, accCssBlocks ) =
    case styledNode of
        PlainNode vdomNode ->
            ( vdomNode :: accNodes, accCssBlocks )

        Node elemType attributes children ->
            let
                ( plainAttributes, childNodes, cssBlocks ) =
                    unstyle attributes children
            in
            ( VirtualDom.node elemType plainAttributes childNodes :: accNodes
            , accBlocksMerge cssBlocks accCssBlocks
            )

        NodeNS ns elemType attributes children ->
            let
                ( plainAttributes, childNodes, cssBlocks ) =
                    unstyle attributes children
            in
            ( VirtualDom.nodeNS ns elemType plainAttributes childNodes :: accNodes
            , accBlocksMerge cssBlocks accCssBlocks
            )

        KeyedNode elemType attributes children ->
            let
                ( plainAttributes, childNodes, cssBlocks ) =
                    unstyleKeyed attributes children
            in
            ( VirtualDom.keyedNode elemType plainAttributes childNodes :: accNodes
            , accBlocksMerge cssBlocks accCssBlocks
            )

        KeyedNodeNS ns elemType attributes children ->
            let
                ( plainAttributes, childNodes, cssBlocks ) =
                    unstyleKeyed attributes children
            in
            ( VirtualDom.keyedNodeNS ns elemType plainAttributes childNodes :: accNodes
            , accBlocksMerge cssBlocks accCssBlocks
            )


accumulateKeyedStyledHtml :
    ( String, Node msg )
    -> ( List ( String, VirtualDom.Node msg ), Dict String AccBlock )
    -> ( List ( String, VirtualDom.Node msg ), Dict String AccBlock )
accumulateKeyedStyledHtml ( key, html ) ( accNodes, accCssBlocks ) =
    case html of
        PlainNode vdom ->
            ( ( key, vdom ) :: accNodes, accCssBlocks )

        Node elemType attributes children ->
            let
                ( plainAttributes, childNodes, cssBlocks ) =
                    unstyle attributes children
            in
            ( ( key, VirtualDom.node elemType plainAttributes childNodes ) :: accNodes
            , accBlocksMerge cssBlocks accCssBlocks
            )

        NodeNS ns elemType attributes children ->
            let
                ( plainAttributes, childNodes, cssBlocks ) =
                    unstyle attributes children
            in
            ( ( key, VirtualDom.nodeNS ns elemType plainAttributes childNodes ) :: accNodes
            , accBlocksMerge cssBlocks accCssBlocks
            )

        KeyedNode elemType attributes children ->
            let
                ( plainAttributes, childNodes, cssBlocks ) =
                    unstyleKeyed attributes children
            in
            ( ( key, VirtualDom.keyedNode elemType plainAttributes childNodes ) :: accNodes
            , accBlocksMerge cssBlocks accCssBlocks
            )

        KeyedNodeNS ns elemType attributes children ->
            let
                ( plainAttributes, childNodes, cssBlocks ) =
                    unstyleKeyed attributes children
            in
            ( ( key, VirtualDom.keyedNodeNS ns elemType plainAttributes childNodes ) :: accNodes
            , accBlocksMerge cssBlocks accCssBlocks
            )


{-| returns a String key that is not already one of the keys in the list of
key-value pairs. We need this in order to prepend to a list of StyledHtml.Keyed
nodes with a guaranteed-unique key.
-}
getUnusedKey : List ( String, a ) -> String
getUnusedKey pairs =
    case pairs of
        [] ->
            "_"

        ( firstKey, _ ) :: rest ->
            let
                newKey =
                    "_" ++ firstKey
            in
            if List.any (Tuple.first >> (==) newKey) rest then
                getUnusedKey rest

            else
                newKey
