module Origami.StyleTag exposing
    ( styleTag, Block, Property, property
    , style, media, fontFace
    , keyframes, KeyframesSelector, from, to, pct
    )

{-|

@docs styleTag, Block, Property, property
@docs style, media, fontFace
@docs keyframes, KeyframesSelector, from, to, pct

-}

import Origami.Css.Selector exposing (MediaQuery(..))
import Origami.Css.StyleTag as StyleTag exposing (..)
import Origami.VirtualDom as VirtualDom exposing (Node)


type alias Block =
    StyleTag.Block


type alias KeyframesSelector =
    StyleTag.KeyframesSelector


type alias Property =
    StyleTag.Property


styleTag : List Block -> Node msg
styleTag blocks =
    VirtualDom.node "style" [] [ VirtualDom.text <| print blocks ]


style : String -> List Property -> Block
style selector ps =
    StyleBlock (CustomSelector selector) ps


media : String -> List Block -> Block
media selector bs =
    MediaBlock (MediaQuery selector) bs


keyframes : String -> List ( ( KeyframesSelector, List KeyframesSelector ), List Property ) -> Block
keyframes animationName bs =
    KeyframesBlock animationName bs


from : KeyframesSelector
from =
    KeyframesSelectorFrom


to : KeyframesSelector
to =
    KeyframesSelectorTo


pct : Float -> KeyframesSelector
pct =
    KeyframesSelectorPercent


fontFace : List Property -> Block
fontFace ps =
    FontFaceBlock ps


{-| -}
property : String -> String -> Property
property =
    Property
