module Origami.StyleTag exposing
    ( Block, styleTag, styleTag_
    , style, media, fontFace
    , Property, property
    , keyframes
    )

{-| Create a style tag.

全体に適用したいCSSを書けます。


## Create

@docs Block, styleTag, styleTag_


## Blocks

@docs style, media, fontFace
@docs Property, property


### Keyframes

@docs keyframes

-}

import Origami.Css.Selector exposing (MediaQuery(..))
import Origami.Css.StyleTag as StyleTag exposing (..)
import Origami.VirtualDom as VirtualDom exposing (Node)
import VirtualDom as OriginalVirtualDom


{-| -}
type alias Block =
    StyleTag.Block


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
            [ ( "from", [ property "key" "value" ] )
            , ( "20%, 80%", [ property "key" "value" ] )
            , ( "to", [ property "key" "value" ] )
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
keyframes : String -> List ( String, List Property ) -> Block
keyframes animationName bs =
    KeyframesBlock animationName bs


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

  - `Origami.property`とは非互換

-}
property : String -> String -> Property
property =
    Property
