module Origami.VirtualDom exposing
    ( Node, text, node, nodeNS
    , Attribute(..), style, property, attribute, attributeNS, batchAttributes, noAttribute
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

@docs Attribute, style, property, attribute, attributeNS, batchAttributes, noAttribute


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

import Dict
import Json.Encode
import Origami.Css.Style exposing (FlatStyle, Style)
import Origami.Css.StyleTag
import VirtualDom


type Node msg
    = Node String (List (Attribute msg)) (List (Node msg))
    | NodeNS String String (List (Attribute msg)) (List (Node msg))
    | KeyedNode String (List (Attribute msg)) (List ( String, Node msg ))
    | KeyedNodeNS String String (List (Attribute msg)) (List ( String, Node msg ))
    | PlainNode (VirtualDom.Node msg)


type Attribute msg
    = Attribute (List (VirtualDom.Attribute msg)) (List ( String, List FlatStyle ))


node : String -> List (Attribute msg) -> List (Node msg) -> Node msg
node =
    Node


nodeNS : String -> String -> List (Attribute msg) -> List (Node msg) -> Node msg
nodeNS =
    NodeNS


keyedNode : String -> List (Attribute msg) -> List ( String, Node msg ) -> Node msg
keyedNode =
    KeyedNode


keyedNodeNS : String -> String -> List (Attribute msg) -> List ( String, Node msg ) -> Node msg
keyedNodeNS =
    KeyedNodeNS


plainNode : VirtualDom.Node msg -> Node msg
plainNode =
    PlainNode


text : String -> Node msg
text =
    PlainNode << VirtualDom.text


map : (a -> b) -> Node a -> Node b
map transform vdomNode =
    case vdomNode of
        Node elemType attributes children ->
            Node elemType (List.map (mapAttribute transform) attributes) (List.map (map transform) children)

        NodeNS ns elemType attributes children ->
            NodeNS ns elemType (List.map (mapAttribute transform) attributes) (List.map (map transform) children)

        KeyedNode elemType attributes children ->
            KeyedNode elemType (List.map (mapAttribute transform) attributes) (List.map (\( key, child ) -> ( key, map transform child )) children)

        KeyedNodeNS ns elemType attributes children ->
            KeyedNodeNS ns elemType (List.map (mapAttribute transform) attributes) (List.map (\( key, child ) -> ( key, map transform child )) children)

        PlainNode vdom ->
            PlainNode <| VirtualDom.map transform vdom


property : String -> Json.Encode.Value -> Attribute msg
property key value =
    plainAttribute <| VirtualDom.property key value


attribute : String -> String -> Attribute msg
attribute key value =
    plainAttribute <| VirtualDom.attribute key value


style : String -> String -> Attribute msg
style key value =
    plainAttribute <| VirtualDom.style key value


attributeNS : String -> String -> String -> Attribute msg
attributeNS namespace key value =
    plainAttribute <| VirtualDom.attributeNS namespace key value


plainAttribute : VirtualDom.Attribute msg -> Attribute msg
plainAttribute attr =
    Attribute [ attr ] []


batchAttributes : List (Attribute msg) -> Attribute msg
batchAttributes =
    List.foldr (\(Attribute attrs styles) ( accAttrs, accStyles ) -> ( attrs ++ accAttrs, styles ++ accStyles )) ( [], [] )
        >> (\( attrs, styles ) -> Attribute attrs styles)


noAttribute : Attribute msg
noAttribute =
    Attribute [] []


on : String -> VirtualDom.Handler msg -> Attribute msg
on eventName handler =
    plainAttribute (VirtualDom.on eventName handler)


mapAttribute : (a -> b) -> Attribute a -> Attribute b
mapAttribute transform (Attribute attrs styles) =
    Attribute (List.map (VirtualDom.mapAttribute transform) attrs) styles


lazy : (a -> Node msg) -> a -> Node msg
lazy fn arg =
    PlainNode <| VirtualDom.lazy2 lazyHelp fn arg


lazyHelp : (a -> Node msg) -> a -> VirtualDom.Node msg
lazyHelp fn arg =
    toPlainNode <| fn arg


lazy2 : (a -> b -> Node msg) -> a -> b -> Node msg
lazy2 fn arg1 arg2 =
    PlainNode <| VirtualDom.lazy3 lazyHelp2 fn arg1 arg2


lazyHelp2 : (a -> b -> Node msg) -> a -> b -> VirtualDom.Node msg
lazyHelp2 fn arg1 arg2 =
    toPlainNode <| fn arg1 arg2


lazy3 : (a -> b -> c -> Node msg) -> a -> b -> c -> Node msg
lazy3 fn arg1 arg2 arg3 =
    PlainNode <| VirtualDom.lazy4 lazyHelp3 fn arg1 arg2 arg3


lazyHelp3 : (a -> b -> c -> Node msg) -> a -> b -> c -> VirtualDom.Node msg
lazyHelp3 fn arg1 arg2 arg3 =
    toPlainNode <| fn arg1 arg2 arg3


lazy4 : (a -> b -> c -> d -> Node msg) -> a -> b -> c -> d -> Node msg
lazy4 fn arg1 arg2 arg3 arg4 =
    PlainNode <| VirtualDom.lazy5 lazyHelp4 fn arg1 arg2 arg3 arg4


lazyHelp4 : (a -> b -> c -> d -> Node msg) -> a -> b -> c -> d -> VirtualDom.Node msg
lazyHelp4 fn arg1 arg2 arg3 arg4 =
    toPlainNode <| fn arg1 arg2 arg3 arg4


lazy5 : (a -> b -> c -> d -> e -> Node msg) -> a -> b -> c -> d -> e -> Node msg
lazy5 fn arg1 arg2 arg3 arg4 arg5 =
    PlainNode <| VirtualDom.lazy6 lazyHelp5 fn arg1 arg2 arg3 arg4 arg5


lazyHelp5 : (a -> b -> c -> d -> e -> Node msg) -> a -> b -> c -> d -> e -> VirtualDom.Node msg
lazyHelp5 fn arg1 arg2 arg3 arg4 arg5 =
    toPlainNode <| fn arg1 arg2 arg3 arg4 arg5


lazy6 : (a -> b -> c -> d -> e -> f -> Node msg) -> a -> b -> c -> d -> e -> f -> Node msg
lazy6 fn arg1 arg2 arg3 arg4 arg5 arg6 =
    PlainNode <| VirtualDom.lazy7 lazyHelp6 fn arg1 arg2 arg3 arg4 arg5 arg6


lazyHelp6 : (a -> b -> c -> d -> e -> f -> Node msg) -> a -> b -> c -> d -> e -> f -> VirtualDom.Node msg
lazyHelp6 fn arg1 arg2 arg3 arg4 arg5 arg6 =
    toPlainNode <| fn arg1 arg2 arg3 arg4 arg5 arg6


lazy7 : (a -> b -> c -> d -> e -> f -> g -> Node msg) -> a -> b -> c -> d -> e -> f -> g -> Node msg
lazy7 fn arg1 arg2 arg3 arg4 arg5 arg6 arg7 =
    PlainNode <| VirtualDom.lazy8 lazyHelp7 fn arg1 arg2 arg3 arg4 arg5 arg6 arg7


lazyHelp7 : (a -> b -> c -> d -> e -> f -> g -> Node msg) -> a -> b -> c -> d -> e -> f -> g -> VirtualDom.Node msg
lazyHelp7 fn arg1 arg2 arg3 arg4 arg5 arg6 arg7 =
    toPlainNode <| fn arg1 arg2 arg3 arg4 arg5 arg6 arg7


css : List Style -> Attribute msg
css styles =
    case Origami.Css.Style.flatten styles of
        [] ->
            noAttribute

        nonEmpty ->
            let
                classname =
                    Origami.Css.Style.hashToClassname nonEmpty
            in
            Attribute [ VirtualDom.property "className" (Json.Encode.string classname) ] [ ( classname, nonEmpty ) ]


toPlainNode : Node msg -> VirtualDom.Node msg
toPlainNode vdom =
    case vdom of
        PlainNode vdomNode ->
            vdomNode

        Node elemType attributes children ->
            let
                ( plainAttributes, childNodes, styles ) =
                    unstyle attributes children
            in
            VirtualDom.node elemType plainAttributes (toStyleNode styles :: childNodes)

        NodeNS ns elemType attributes children ->
            let
                ( plainAttributes, childNodes, styles ) =
                    unstyle attributes children
            in
            VirtualDom.nodeNS ns elemType plainAttributes (toStyleNode styles :: childNodes)

        KeyedNode elemType attributes children ->
            let
                ( plainAttributes, childNodes, styles ) =
                    unstyleKeyed attributes children
            in
            VirtualDom.keyedNode elemType plainAttributes (toKeyedStyleNode styles childNodes :: childNodes)

        KeyedNodeNS ns elemType attributes children ->
            let
                ( plainAttributes, childNodes, styles ) =
                    unstyleKeyed attributes children
            in
            VirtualDom.keyedNodeNS ns elemType plainAttributes (toKeyedStyleNode styles childNodes :: childNodes)


toPlainNodes : List (Node msg) -> List (VirtualDom.Node msg)
toPlainNodes vdoms =
    let
        ( childNodes, styles ) =
            List.foldr accumulateStyledHtml ( [], [] ) vdoms
    in
    toStyleNode styles :: childNodes



-- _/_/_/_/_/_/_/_/ --
-- INTERNAL
-- _/_/_/_/_/_/_/_/ --


unstyle : List (Attribute msg) -> List (Node msg) -> ( List (VirtualDom.Attribute msg), List (VirtualDom.Node msg), List ( String, List FlatStyle ) )
unstyle attributes children =
    let
        ( plainAttributes, styles ) =
            partitionAttributes attributes

        ( childNodes, combinedStyles ) =
            List.foldr accumulateStyledHtml ( [], styles ) children
    in
    ( plainAttributes, childNodes, combinedStyles )


unstyleKeyed : List (Attribute msg) -> List ( String, Node msg ) -> ( List (VirtualDom.Attribute msg), List ( String, VirtualDom.Node msg ), List ( String, List FlatStyle ) )
unstyleKeyed attributes keyedChildren =
    let
        ( plainAttributes, styles ) =
            partitionAttributes attributes

        ( keyedChildNodes, combinedStyles ) =
            List.foldr accumulateKeyedStyledHtml ( [], styles ) keyedChildren
    in
    ( plainAttributes, keyedChildNodes, combinedStyles )


toKeyedStyleNode : List ( String, List FlatStyle ) -> List ( String, a ) -> ( String, VirtualDom.Node msg )
toKeyedStyleNode styles keyedChildNodes =
    ( getUnusedKey keyedChildNodes, toStyleNode styles )


toStyleNode : List ( String, List FlatStyle ) -> VirtualDom.Node msg
toStyleNode stylesList =
    Dict.fromList stylesList
        |> Dict.map Origami.Css.Style.compile
        |> Dict.values
        |> List.concat
        |> Origami.Css.StyleTag.print
        |> VirtualDom.text
        |> List.singleton
        |> VirtualDom.node "style" []


partitionAttributes : List (Attribute msg) -> ( List (VirtualDom.Attribute msg), List ( String, List FlatStyle ) )
partitionAttributes attributes =
    List.foldr (\(Attribute attrs styles) ( accAttrs, accStyles ) -> ( attrs ++ accAttrs, styles ++ accStyles )) ( [], [] ) attributes


accumulateStyledHtml :
    Node msg
    -> ( List (VirtualDom.Node msg), List ( String, List FlatStyle ) )
    -> ( List (VirtualDom.Node msg), List ( String, List FlatStyle ) )
accumulateStyledHtml styledNode ( accNodes, accStyles ) =
    case styledNode of
        PlainNode vdomNode ->
            ( vdomNode :: accNodes, accStyles )

        Node elemType attributes children ->
            let
                ( plainAttributes, childNodes, styles ) =
                    unstyle attributes children
            in
            ( VirtualDom.node elemType plainAttributes childNodes :: accNodes, styles ++ accStyles )

        NodeNS ns elemType attributes children ->
            let
                ( plainAttributes, childNodes, styles ) =
                    unstyle attributes children
            in
            ( VirtualDom.nodeNS ns elemType plainAttributes childNodes :: accNodes, styles ++ accStyles )

        KeyedNode elemType attributes children ->
            let
                ( plainAttributes, childNodes, styles ) =
                    unstyleKeyed attributes children
            in
            ( VirtualDom.keyedNode elemType plainAttributes childNodes :: accNodes, styles ++ accStyles )

        KeyedNodeNS ns elemType attributes children ->
            let
                ( plainAttributes, childNodes, styles ) =
                    unstyleKeyed attributes children
            in
            ( VirtualDom.keyedNodeNS ns elemType plainAttributes childNodes :: accNodes, styles ++ accStyles )


accumulateKeyedStyledHtml :
    ( String, Node msg )
    -> ( List ( String, VirtualDom.Node msg ), List ( String, List FlatStyle ) )
    -> ( List ( String, VirtualDom.Node msg ), List ( String, List FlatStyle ) )
accumulateKeyedStyledHtml ( key, html ) ( accNodes, accStyles ) =
    case html of
        PlainNode vdom ->
            ( ( key, vdom ) :: accNodes, accStyles )

        Node elemType attributes children ->
            let
                ( plainAttributes, childNodes, styles ) =
                    unstyle attributes children
            in
            ( ( key, VirtualDom.node elemType plainAttributes childNodes ) :: accNodes, styles ++ accStyles )

        NodeNS ns elemType attributes children ->
            let
                ( plainAttributes, childNodes, styles ) =
                    unstyle attributes children
            in
            ( ( key, VirtualDom.nodeNS ns elemType plainAttributes childNodes ) :: accNodes, styles ++ accStyles )

        KeyedNode elemType attributes children ->
            let
                ( plainAttributes, childNodes, styles ) =
                    unstyleKeyed attributes children
            in
            ( ( key, VirtualDom.keyedNode elemType plainAttributes childNodes ) :: accNodes, styles ++ accStyles )

        KeyedNodeNS ns elemType attributes children ->
            let
                ( plainAttributes, childNodes, styles ) =
                    unstyleKeyed attributes children
            in
            ( ( key, VirtualDom.keyedNodeNS ns elemType plainAttributes childNodes ) :: accNodes, styles ++ accStyles )


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