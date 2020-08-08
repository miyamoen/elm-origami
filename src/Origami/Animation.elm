module Origami.Animation exposing (Property, Selector, animation, from, pct, property, to)

{-| -}

import Origami exposing (Style)
import Origami.Css.Style as Style
import Origami.Css.StyleTag as StyleTag exposing (KeyframeSelector(..), Property(..))


type alias Selector =
    KeyframeSelector


type alias Property =
    StyleTag.Property


{-| -}
animation : List ( ( Selector, List Selector ), List Property ) -> Style
animation =
    Style.AnimationStyle


from : Selector
from =
    KeyframeSelectorFrom


to : Selector
to =
    KeyframeSelectorTo


pct : Float -> Selector
pct =
    KeyframeSelectorPercent


property : String -> String -> Property
property =
    Property
