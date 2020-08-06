module Origami exposing (Style, batch, property, qt)

{-| -}

import Origami.Css.Style as Style
import Origami.Css.StyleTag exposing (Property(..))


{-| -}
type alias Style =
    Style.Style


{-| For use with [`font-family`](https://developer.mozilla.org/docs/Web/CSS/font-family)

    fontFamily serif

    fontFamilies [ qt "Gill Sans Extrabold", "Helvetica", .value sansSerif ]

-}
qt : String -> String
qt str =
    "\"" ++ str ++ "\""


{-| Create a style from multiple other styles.

    underlineOnHover =
        batch
            [ textDecoration none

            , hover
                [ textDecoration underline ]
            ]

    css
        [ color (rgb 128 64 32)
        , underlineOnHover
        ]

...has the same result as:

    css
        [ color (rgb 128 64 32)
        , textDecoration none
        , hover
            [ textDecoration underline ]
        ]

-}
batch : List Style -> Style
batch =
    Style.BatchStyles


{-| Define a custom property.

    css [ property "-webkit-font-smoothing" "none" ]

...outputs

    -webkit-font-smoothing: none;

-}
property : String -> String -> Style
property key value =
    Property key value
        |> Style.PropertyStyle
