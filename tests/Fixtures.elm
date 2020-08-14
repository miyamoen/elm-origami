module Fixtures exposing (initialSelector, p, ps, styles)

import Origami exposing (..)
import Origami.Css.Selector as Selector exposing (..)
import Origami.Css.StyleTag exposing (Property(..))


ps : String -> Style
ps val =
    property (val ++ "_key") (val ++ "_val")


p : String -> Property
p val =
    Property (val ++ "_key") (val ++ "_val")


styles : List Style
styles =
    [ ps "1", batch [ ps "1_1" ], ps "2", batch [ ps "2_1", ps "2_2" ], ps "3" ]


initialSelector : Selector.Selector
initialSelector =
    Selector (Single [] Nothing) [] Nothing
