module Origami.Animation exposing (Property, Selector, animation, from, pct, property, to)

{-| -}

import Origami exposing (Style)
import Origami.Css.Style as Style
import Origami.Css.StyleTag as StyleTag exposing (KeyframesSelector(..), Property(..))


type alias Selector =
    KeyframesSelector


type alias Property =
    StyleTag.Property


{-| -}
animation : List ( ( Selector, List Selector ), List Property ) -> Style
animation =
    Style.AnimationStyle


from : Selector
from =
    KeyframesSelectorFrom


to : Selector
to =
    KeyframesSelectorTo


pct : Float -> Selector
pct =
    KeyframesSelectorPercent


property : String -> String -> Property
property =
    Property
