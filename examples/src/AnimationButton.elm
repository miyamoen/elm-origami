module AnimationButton exposing (main)

{-| -}

import Browser
import Origami exposing (..)
import Origami.Html exposing (..)
import Origami.Html.Attributes exposing (css)
import Origami.Html.Events exposing (onClick)
import Origami.StyleTag as StyleTag exposing (styleTag)


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = \model -> { title = "Elm • SpinnerButton styled by elm-origami", body = toHtmls [ globalCss, view model ] }
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    State


type State
    = Initial
    | Loading
    | Completed


init : () -> ( Model, Cmd Msg )
init _ =
    ( Initial
    , Cmd.none
    )


type Msg
    = Reset
    | Load
    | Complete


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        Reset ->
            ( Initial, Cmd.none )

        Load ->
            ( Loading, Cmd.none )

        Complete ->
            ( Completed, Cmd.none )


globalCss : Html msg
globalCss =
    styleTag
        [ StyleTag.style "*"
            [ StyleTag.property "box-sizing" "border-box"
            ]
        ]


view : Model -> Html Msg
view model =
    div
        [ css
            [ property "width" "100vw"
            , property "height" "100vh"
            , property "display" "flex"
            , property "justify-content" "center"
            , property "align-items" "center"
            ]
        ]
        [ button
            [ css
                [ property "display" "flex"
                , property "justify-content" "center"
                , property "align-items" "center"
                , property "position" "relative"
                , property "height" "50px"
                , property "width" "200px"
                , property "outline" "none"
                , property "border-width" "0"
                , property "background-color" "#f58c64"
                , property "color" "white"
                , property "font-size" "20px"
                , property "letter-spacing" "2px"
                , property "cursor" "pointer"
                , property "transition" "all 0.3s cubic-bezier(0.13, 0.99, 0.39, 1.01)"
                , property "box-shadow" "0 3px 5px rgba(0, 0, 0, 0.3)"
                , withPseudoClass "hover" [ property "background-color" "#ef794c" ]
                , case model of
                    Initial ->
                        noStyle

                    Loading ->
                        batch
                            [ property "border-radius" "50px"
                            , property "width" "50px"
                            , -- [Copyright (c) 2019 Epicmax LLC](https://epic-spinners.epicmax.co/)
                              withEach [ pseudoElement [] "after", pseudoElement [] "before" ]
                                [ property "content" <| qt ""
                                , property "position" "absolute"
                                , property "width" "60%"
                                , property "height" "60%"
                                , property "border-radius" "100%"
                                , property "border" "calc(30px / 10) solid transparent"
                                , animation
                                    [ ( ( from, [] ), [ propertyA "transform" "rotate(0deg)" ] )
                                    , ( ( to, [] ), [ propertyA "transform" "rotate(360deg)" ] )
                                    ]
                                , property "animation-duration" "1s"
                                , property "animation-iteration-count" "infinite"
                                ]
                            , withPseudoElement "after" [ property "border-top-color" "#ffe9ef" ]
                            , withPseudoElement "before"
                                [ property "border-bottom-color" "#ffe9ef"
                                , property "animation-direction" "alternate"
                                ]
                            ]

                    Completed ->
                        batch
                            [ property "border-radius" "50px"
                            , property "width" "50px"
                            , withPseudoElement "after"
                                [ property "content" <| qt ""
                                , property "position" "absolute"
                                , property "width" "60%"
                                , property "height" "30%"
                                , property "border-left" "3px solid #fff"
                                , property "border-bottom" "3px solid #fff"
                                , property "transform" "rotate(-45deg)"
                                ]
                            ]
                ]
            , onClick <|
                case model of
                    Initial ->
                        Load

                    Loading ->
                        Complete

                    Completed ->
                        Reset
            ]
            [ if model == Initial then
                span
                    [ css
                        [ animation
                            [ ( ( from, [] ), [ propertyA "opacity" "0" ] )
                            , ( ( to, [] ), [ propertyA "opacity" "1" ] )
                            ]
                        , property "animation-duration" "1s"
                        ]
                    ]
                    [ text "Click Me!" ]

              else
                text ""
            ]
        ]
