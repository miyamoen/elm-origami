module TodoMVC exposing (main)

{-| Forked from [evancz/elm-todomvc](https://github.com/evancz/elm-todomvc).

TodoMVC implemented in Elm, using plain HTML and CSS for rendering.

This application is broken up into three key parts:

1.  Model - a full definition of the application's state
2.  Update - a way to step the application state forward
3.  View - a way to visualize our application state with HTML

This clean division of concerns is a core part of Elm. You can read more about
this in <http://guide.elm-lang.org/architecture/index.html>

-}

import Browser
import Browser.Dom as Dom
import Json.Decode as Json
import Origami exposing (..)
import Origami.Html exposing (..)
import Origami.Html.Attributes exposing (autofocus, checked, classList, css, for, hidden, href, id, name, placeholder, type_, value)
import Origami.Html.Events exposing (..)
import Origami.Html.Keyed as Keyed
import Origami.Html.Lazy exposing (lazy, lazy2)
import Origami.StyleTag as StyleTag exposing (styleTag)
import Task


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = \model -> { title = "Elm • TodoMVC styled by elm-origami", body = toHtmls [ globalStyles, view model ] }
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL
-- The full application state of our todo app.


type alias Model =
    { entries : List Entry
    , field : String
    , uid : Int
    , visibility : String
    }


type alias Entry =
    { description : String
    , completed : Bool
    , editing : Bool
    , id : Int
    }


newEntry : String -> Int -> Entry
newEntry desc id =
    { description = desc
    , completed = False
    , editing = False
    , id = id
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { entries = []
      , visibility = "All"
      , field = ""
      , uid = 0
      }
    , Cmd.none
    )



-- UPDATE


{-| Users of our app can trigger messages by clicking and typing. These
messages are fed into the `update` function as they occur, letting us react
to them.
-}
type Msg
    = NoOp
    | UpdateField String
    | EditingEntry Int Bool
    | UpdateEntry Int String
    | Add
    | Delete Int
    | DeleteComplete
    | Check Int Bool
    | CheckAll Bool
    | ChangeVisibility String



-- How we update our Model on a given Msg?


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Add ->
            ( { model
                | uid = model.uid + 1
                , field = ""
                , entries =
                    if String.isEmpty model.field then
                        model.entries

                    else
                        model.entries ++ [ newEntry model.field model.uid ]
              }
            , Cmd.none
            )

        UpdateField str ->
            ( { model | field = str }
            , Cmd.none
            )

        EditingEntry id isEditing ->
            let
                updateEntry t =
                    if t.id == id then
                        { t | editing = isEditing }

                    else
                        t

                focus =
                    Dom.focus ("todo-" ++ String.fromInt id)
            in
            ( { model | entries = List.map updateEntry model.entries }
            , Task.attempt (\_ -> NoOp) focus
            )

        UpdateEntry id task ->
            let
                updateEntry t =
                    if t.id == id then
                        { t | description = task }

                    else
                        t
            in
            ( { model | entries = List.map updateEntry model.entries }
            , Cmd.none
            )

        Delete id ->
            ( { model | entries = List.filter (\t -> t.id /= id) model.entries }
            , Cmd.none
            )

        DeleteComplete ->
            ( { model | entries = List.filter (not << .completed) model.entries }
            , Cmd.none
            )

        Check id isCompleted ->
            let
                updateEntry t =
                    if t.id == id then
                        { t | completed = isCompleted }

                    else
                        t
            in
            ( { model | entries = List.map updateEntry model.entries }
            , Cmd.none
            )

        CheckAll isCompleted ->
            let
                updateEntry t =
                    { t | completed = isCompleted }
            in
            ( { model | entries = List.map updateEntry model.entries }
            , Cmd.none
            )

        ChangeVisibility visibility ->
            ( { model | visibility = visibility }
            , Cmd.none
            )



-- VIEW


globalStyles : Html msg
globalStyles =
    styleTag
        [ StyleTag.style "html, body"
            [ StyleTag.property "margin" "0"
            , StyleTag.property "padding" "0"
            ]
        , StyleTag.style "button"
            [ StyleTag.property "margin" "0"
            , StyleTag.property "padding" "0"
            , StyleTag.property "border" "0"
            , StyleTag.property "background" "none"
            , StyleTag.property "font-size" "100%"
            , StyleTag.property "vertical-align" "baseline"
            , StyleTag.property "font-family" "inherit"
            , StyleTag.property "font-weight" "inherit"
            , StyleTag.property "color" "inherit"
            , StyleTag.property "-webkit-appearance" "none"
            , StyleTag.property "appearance" "none"
            , StyleTag.property "-webkit-font-smoothing" "antialiased"
            , StyleTag.property "-moz-font-smoothing" "antialiased"
            , StyleTag.property "font-smoothing" "antialiased"
            , StyleTag.property "outline" "none"
            ]
        , StyleTag.style "body"
            [ StyleTag.property "font" "14px 'Helvetica Neue', Helvetica, Arial, sans-serif"
            , StyleTag.property "line-height" "1.4em"
            , StyleTag.property "background" "#f5f5f5"
            , StyleTag.property "color" "#4d4d4d"
            , StyleTag.property "min-width" "230px"
            , StyleTag.property "max-width" "550px"
            , StyleTag.property "margin" "0 auto"
            , StyleTag.property "-webkit-font-smoothing" "antialiased"
            , StyleTag.property "-moz-font-smoothing" "antialiased"
            , StyleTag.property "font-smoothing" "antialiased"
            , StyleTag.property "font-weight" "300"
            ]
        , StyleTag.style """input[type="checkbox"]""" [ StyleTag.property "outline" "none" ]
        ]


view : Model -> Html Msg
view model =
    div [ css [ property "visibility" "visible" ] ]
        [ section
            [ css
                [ property "background" "#fff"
                , property "margin" "130px 0 40px 0"
                , property "position" "relative"
                , property "box-shadow" "0 2px 4px 0 rgba(0, 0, 0, 0.2), 0 25px 50px 0 rgba(0, 0, 0, 0.1)"
                , let
                    styles =
                        [ property "font-style" "italic"
                        , property "font-weight" "300"
                        , property "color" "#e6e6e6"
                        ]
                  in
                  with " input"
                    [ with "::-webkit-input-placeholder" styles
                    , with "::-moz-placeholder" styles
                    , with "::input-placeholder" styles
                    ]
                , with " h1"
                    [ property "position" "absolute"
                    , property "top" "-155px"
                    , property "width" "100%"
                    , property "font-size" "100px"
                    , property "font-weight" "100"
                    , property "text-align" "center"
                    , property "color" "rgba(175, 47, 47, 0.15)"
                    , property "-webkit-text-rendering" "optimizeLegibility"
                    , property "-moz-text-rendering" "optimizeLegibility"
                    , property "text-rendering" "optimizeLegibility"
                    ]
                ]
            ]
            [ lazy viewInput model.field
            , lazy2 viewEntries model.visibility model.entries
            , lazy2 viewControls model.visibility model.entries
            ]
        , infoFooter
        ]


viewInput : String -> Html Msg
viewInput task =
    header []
        [ h1 [] [ text "todos" ]
        , input
            [ css
                [ batch stylesForInput
                , property "padding" "16px 16px 16px 60px"
                , property "border" "none"
                , property "background" "rgba(0, 0, 0, 0.003)"
                , property "box-shadow" "inset 0 -2px 1px rgba(0,0,0,0.03)"
                ]
            , placeholder "What needs to be done?"
            , autofocus True
            , value task
            , name "newTodo"
            , onInput UpdateField
            , onEnter Add
            ]
            []
        ]


stylesForInput : List Style
stylesForInput =
    [ property "position" "relative"
    , property "margin" "0"
    , property "width" "100%"
    , property "font-size" "24px"
    , property "font-family" "inherit"
    , property "font-weight" "inherit"
    , property "line-height" "1.4em"
    , property "outline" "none"
    , property "color" "inherit"
    , property "padding" "6px"
    , property "border" "1px solid #999"
    , property "box-shadow" "inset 0 -1px 5px 0 rgba(0, 0, 0, 0.2)"
    , property "box-sizing" "border-box"
    , property "-webkit-font-smoothing" "antialiased"
    , property "-moz-font-smoothing" "antialiased"
    , property "font-smoothing" "antialiased"
    ]


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg

            else
                Json.fail "not ENTER"
    in
    on "keydown" (Json.andThen isEnter keyCode)



-- VIEW ALL ENTRIES


viewEntries : String -> List Entry -> Html Msg
viewEntries visibility entries =
    let
        isVisible todo =
            case visibility of
                "Completed" ->
                    todo.completed

                "Active" ->
                    not todo.completed

                _ ->
                    True

        allCompleted =
            List.all .completed entries
    in
    section
        [ css
            [ property "position" "relative"
            , property "z-index" "2"
            , property "border-top" "1px solid #e6e6e6"
            , property "visibility" <|
                if List.isEmpty entries then
                    "hidden"

                else
                    "visible"
            ]
        ]
        [ input
            [ type_ "checkbox"
            , name "toggle-all"
            , checked allCompleted
            , onClick (CheckAll (not allCompleted))
            , css
                [ property "position" "absolute"
                , property "top" "-55px"
                , property "left" "-12px"
                , property "width" "60px"
                , property "height" "34px"
                , property "text-align" "center"
                , property "border" "none" -- Mobile Safari
                , with "::before"
                    [ property "content" <| qt "❯"
                    , property "font-size" "22px"
                    , property "color" "#e6e6e6"
                    , property "padding" "10px 27px 10px 27px"
                    ]
                , with ":checked::before"
                    [ property "color" "#737373" ]
                , -- Hack to remove background from Mobile Safari.
                  -- Can't use it globally since it destroys checkboxes in Firefox
                  withMedia "screen and (-webkit-min-device-pixel-ratio:0)"
                    [ property "background" "none"
                    , property "-webkit-transform" "rotate(90deg)"
                    , property "transform" "rotate(90deg)"
                    , property "-webkit-appearance" "none"
                    , property "appearance" "none"
                    ]
                ]
            ]
            []
        , label [ for "toggle-all", css [ property "display" "none" ] ]
            [ text "Mark all as complete" ]
        , Keyed.ul
            [ css
                [ property "margin" "0"
                , property "padding" "0"
                , property "list-style" "none"
                ]
            ]
          <|
            List.map viewKeyedEntry (List.filter isVisible entries)
        ]



-- VIEW INDIVIDUAL ENTRIES


viewKeyedEntry : Entry -> ( String, Html Msg )
viewKeyedEntry todo =
    ( String.fromInt todo.id, lazy viewEntry todo )


viewEntry : Entry -> Html Msg
viewEntry todo =
    li
        [ classList [ ( "completed", todo.completed ), ( "editing", todo.editing ) ]
        , css
            [ property "position" "relative"
            , property "font-size" "24px"
            , property "border-bottom" "1px solid #ededed"
            , with ":last-child" [ property "border-bottom" "none" ]
            , if todo.editing then
                batch
                    [ property "border-bottom" "none"
                    , property "padding" "0"
                    , with ":last-child" [ property "margin-bottom" "-1px" ]
                    ]

              else
                noStyle
            , with ":hover" [ property "display" "block" ]
            , with " button" [ property "display" "block" ]
            ]
        ]
        [ div
            [ css
                [ if todo.editing then
                    property "display" "none"

                  else
                    noStyle
                ]
            ]
            [ input
                [ css
                    [ property "text-align" "center"
                    , property "width" "40px"
                    , -- auto, since non-WebKit browsers doesn't support input styling
                      property "height" "auto"
                    , property "position" "absolute"
                    , property "top" "0"
                    , property "bottom" "0"
                    , property "margin" "auto 0"
                    , property "border" "none" -- Mobile Safari
                    , property "-webkit-appearance" "none"
                    , property "appearance" "none"
                    , with "::after"
                        [ property "content" """url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="-10 -18 100 135"><circle cx="50" cy="50" r="50" fill="none" stroke="#ededed" stroke-width="3"/></svg>')""" ]
                    , with ":checked::after"
                        [ property "content" """url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="-10 -18 100 135"><circle cx="50" cy="50" r="50" fill="none" stroke="#bddad5" stroke-width="3"/><path fill="#5dc2af" d="M72 25L42 71 27 56l-4 4 20 20 34-52z"/></svg>')""" ]
                    , -- Hack to remove background from Mobile Safari.
                      -- Can't use it globally since it destroys checkboxes in Firefox
                      withMedia "screen and (-webkit-min-device-pixel-ratio:0)"
                        [ property "background" "none"
                        , property "height" "40px"
                        ]
                    ]
                , type_ "checkbox"
                , checked todo.completed
                , onClick (Check todo.id (not todo.completed))
                ]
                []
            , label
                [ css
                    [ property "white-space" "pre-line"
                    , property "word-break" "break-all"
                    , property "padding" "15px 60px 15px 15px"
                    , property "margin-left" "45px"
                    , property "display" "block"
                    , property "line-height" "1.2"
                    , property "transition" "color 0.4s"
                    , if todo.completed then
                        batch
                            [ property "color" "#d9d9d9"
                            , property "text-decoration" "line-through"
                            ]

                      else
                        noStyle
                    ]
                , onDoubleClick (EditingEntry todo.id True)
                ]
                [ text todo.description ]
            , button
                [ css
                    [ property "display" "none"
                    , property "position" "absolute"
                    , property "top" "0"
                    , property "right" "10px"
                    , property "bottom" "0"
                    , property "width" "40px"
                    , property "height" "40px"
                    , property "margin" "auto 0"
                    , property "font-size" "30px"
                    , property "color" "#cc9a9a"
                    , property "margin-bottom" "11px"
                    , property "transition" "color 0.2s ease-out"
                    , with ":hover" [ property "color" "#af5b5e" ]
                    , with "::after" [ property "content" "'×'" ]
                    ]
                , onClick (Delete todo.id)
                ]
                []
            ]
        , input
            [ css
                [ batch stylesForInput
                , property "display" "none"
                , if todo.editing then
                    batch
                        [ property "display" "block"
                        , property "width" "506px"
                        , property "padding" "13px 17px 12px 17px"
                        , property "margin" "0 0 0 43px"
                        ]

                  else
                    noStyle
                ]
            , value todo.description
            , name "title"
            , id ("todo-" ++ String.fromInt todo.id)
            , onInput (UpdateEntry todo.id)
            , onBlur (EditingEntry todo.id False)
            , onEnter (EditingEntry todo.id False)
            ]
            []
        ]



-- VIEW CONTROLS AND FOOTER


viewControls : String -> List Entry -> Html Msg
viewControls visibility entries =
    let
        entriesCompleted =
            List.length (List.filter .completed entries)

        entriesLeft =
            List.length entries - entriesCompleted
    in
    footer
        [ css
            [ property "color" "#777"
            , property "padding" "10px 15px"
            , property "height" "20px"
            , property "text-align" "center"
            , property "border-top" "1px solid #e6e6e6"
            , with "::before"
                [ property "content" <| qt ""
                , property "position" "absolute"
                , property "right" "0"
                , property "bottom" "0"
                , property "left" "0"
                , property "height" "50px"
                , property "overflow" "hidden"
                , property "box-shadow" """0 1px 1px rgba(0, 0, 0, 0.2),
                                           0 8px 0 -3px #f6f6f6,
                                           0 9px 1px -3px rgba(0, 0, 0, 0.2),
                                           0 16px 0 -6px #f6f6f6,
                                           0 17px 2px -6px rgba(0, 0, 0, 0.2)"""
                ]
            , withMedia "(max-width: 430px)" [ property "height" "50px" ]
            ]
        , hidden (List.isEmpty entries)
        ]
        [ lazy viewControlsCount entriesLeft
        , lazy viewControlsFilters visibility
        , lazy viewControlsClear entriesCompleted
        ]


viewControlsCount : Int -> Html Msg
viewControlsCount entriesLeft =
    let
        item_ =
            if entriesLeft == 1 then
                " item"

            else
                " items"
    in
    span
        [ css [ property "float" "left", property "text-align" "left" ] ]
        [ strong [ css [ property "font-weight" "300" ] ]
            [ text (String.fromInt entriesLeft) ]
        , text (item_ ++ " left")
        ]


viewControlsFilters : String -> Html Msg
viewControlsFilters visibility =
    ul
        [ css
            [ property "margin" "0"
            , property "padding" "0"
            , property "list-style" "none"
            , property "position" "absolute"
            , property "right" "0"
            , property "left" "0"
            , withMedia "(max-width: 430px)" [ property "bottom" "10px" ]
            ]
        ]
        [ visibilitySwap "#/" "All" visibility
        , text " "
        , visibilitySwap "#/active" "Active" visibility
        , text " "
        , visibilitySwap "#/completed" "Completed" visibility
        ]


visibilitySwap : String -> String -> String -> Html Msg
visibilitySwap uri visibility actualVisibility =
    li
        [ onClick (ChangeVisibility visibility)
        , css [ property "display" "inline" ]
        ]
        [ a
            [ href uri
            , css
                [ property "color" "inherit"
                , property "margin" "3px"
                , property "padding" "3px 7px"
                , property "text-decoration" "none"
                , property "border" "1px solid transparent"
                , property "border-radius" "3px"
                , with ":hover" [ property "border-color" "rgba(175, 47, 47, 0.1)" ]
                , if visibility == actualVisibility then
                    property "border-color" "rgba(175, 47, 47, 0.2)"

                  else
                    noStyle
                ]
            ]
            [ text visibility ]
        ]


viewControlsClear : Int -> Html Msg
viewControlsClear entriesCompleted =
    button
        [ css
            [ clearCompletedStyle
            , with ":hover" [ property "text-decoration" "underline" ]
            , with ":active" [ clearCompletedStyle ]
            ]
        , hidden (entriesCompleted == 0)
        , onClick DeleteComplete
        ]
        [ text ("Clear completed (" ++ String.fromInt entriesCompleted ++ ")")
        ]


clearCompletedStyle : Style
clearCompletedStyle =
    batch
        [ property "float" "right"
        , property "position" "relative"
        , property "line-height" "20px"
        , property "text-decoration" "none"
        , property "cursor" "pointer"
        , property "position" "relative"
        ]


infoFooter : Html msg
infoFooter =
    footer
        [ css
            [ property "margin" "65px auto 0"
            , property "color" "#bfbfbf"
            , property "font-size" "10px"
            , property "text-shadow" "0 1px 0 rgba(255, 255, 255, 0.5)"
            , property "text-align" "center"
            , with " p" [ property "line-height" "1" ]
            , with " a"
                [ property "color" "inherit"
                , property "text-decoration" "none"
                , property "font-weight" "400"
                , with ":hover" [ property "text-decoration" "underline" ]
                ]
            ]
        ]
        [ p [] [ text "Double-click to edit a todo" ]
        , p []
            [ text "Written by "
            , a [ href "https://github.com/evancz" ] [ text "Evan Czaplicki" ]
            ]
        , p []
            [ text "Part of "
            , a [ href "http://todomvc.com" ] [ text "TodoMVC" ]
            ]
        ]
