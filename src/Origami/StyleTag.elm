module Origami.StyleTag exposing
    ( Block, styleTag, styleTag_
    , style, media, fontFace
    , Property, property
    , keyframes, KeyframesSelector, from, to, pct
    )

{-| Create a style tag.

全体に適用したいCSSを書けます。


## Create

@docs Block, styleTag, styleTag_


## Blocks

@docs style, media, fontFace
@docs Property, property


### Keyframes

@docs keyframes, KeyframesSelector, from, to, pct

-}

import Origami.Css.Selector exposing (MediaQuery(..))
import Origami.Css.StyleTag as StyleTag exposing (..)
import Origami.VirtualDom as VirtualDom exposing (Node)
import VirtualDom as OriginalVirtualDom


{-| -}
type alias Block =
    StyleTag.Block


{-| -}
type alias KeyframesSelector =
    StyleTag.KeyframesSelector


{-| -}
type alias Property =
    StyleTag.Property


{-| Create a style tag.

    styleTag
        [ style ".class" [ property "key" "value" ] ]

...outputs

```.css
    <style>
    .class {
        key: value;
    }
    </style>
```

-}
styleTag : List Block -> Node msg
styleTag blocks =
    VirtualDom.node "style" [] [ VirtualDom.text <| print blocks ]


{-| Version of `VirtualDom.Node`.
-}
styleTag_ : List Block -> OriginalVirtualDom.Node msg
styleTag_ blocks =
    OriginalVirtualDom.node "style" [] [ OriginalVirtualDom.text <| print blocks ]


{-| Create a style block.

    styleTag
        [ style ".class" [ property "key" "value" ] ]

...outputs

```.css
    <style>
    .class {
        key: value;
    }
    </style>
```

-}
style : String -> List Property -> Block
style selector ps =
    StyleBlock (CustomSelector selector) ps


{-| Create a media block.

    styleTag
        [ media "screen" [ style ".class" [ property "key" "value" ] ] ]

...outputs

```.css
    <style>
    @media screen {
        .class {
            key: value;
        }
    }
    </style>
```

-}
media : String -> List Block -> Block
media selector bs =
    MediaBlock (MediaQuery selector) bs


{-| Create a keyframes block.

    styleTag
        [ keyframes "spin"
            [ ( ( from, [] ), [ property "key" "value" ] )
            , ( ( pct 20, [ pct 80 ] ), [ property "key" "value" ] )
            , ( ( to, [] ), [ property "key" "value" ] )
            ]
        ]

...outputs

```.css
    <style>
    @keyframes spin {
        from {
            key: value;
        }

        20%, 80% {
            key: value;
        }

        to {
            key: value;
        }
    }
    </style>
```

-}
keyframes : String -> List ( ( KeyframesSelector, List KeyframesSelector ), List Property ) -> Block
keyframes animationName bs =
    KeyframesBlock animationName bs


{-| `from` token.

  - `Origami.from`と同一

-}
from : KeyframesSelector
from =
    KeyframesSelectorFrom


{-| `to` token.

  - `Origami.to`と同一

-}
to : KeyframesSelector
to =
    KeyframesSelectorTo


{-| `30%`, `70%` and so on.

  - `Origami.pct`と同一

-}
pct : Float -> KeyframesSelector
pct =
    KeyframesSelectorPercent


{-| Create a font-face block.

    styleTag
        [ fontFace [ property "key" "value" ] ]

...outputs

```.css
    <style>
    @font-face {
        key: value;
    }
    </style>
```

-}
fontFace : List Property -> Block
fontFace ps =
    FontFaceBlock ps


{-|

  - `Origami.propertyA`と同一

-}
property : String -> String -> Property
property =
    Property
