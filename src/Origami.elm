module Origami exposing
    ( Style, property, batch, noStyle
    , with
    , withMedia
    , withCustom
    , animation
    , qt
    )

{-| Define CSS in Elm.

    input
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

  - See [`examples/TodoMVC`](https://github.com/miyamoen/elm-origami/blob/master/examples)
      - styled by Origami
      - forked from [`evancz/elm-todomvc`](https://github.com/evancz/elm-todomvc)


# How to Use

  - use `property` and `with`!


## `css` and basic functions

    label
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

  - `Origami.Html.Attributes.css`を使ってDOMにStyleを適用します
  - `Style`型は大体CSS Propertyのようなものです
  - 基本的な関数が3つあります
      - [`property`](#property)でpropertyを記述します
          - Origamiでは型安全なproperty関数は提供しません
      - [`batch`](#batch)でpropertyをまとめることができます
      - [`noStyle`](#noStyle)は条件分岐などで使えます

@docs Style, property, batch, noStyle


## Create a Style Tag

  - [`Origami.Html.Html`](./Origami-Html#Html)は[`Html.Html`](https://package.elm-lang.org/packages/elm/html/latest/Html#Html)と同じように扱えます
  - [`Origami.Html.toHtml`](./Origami-Html#toHtml)などを使って`Html.Html`に変換してください
      - `toHtml`などで`css`で適用されているstyleが収集されてstyle tagを生成します
  - 上記`label`に適用されたstyleは以下のようにstyle tag内に書き出されます

```css
._1e7eb6f2 {
    white-space: pre-line;
    word-break: break-all;
    padding: 15px 60px 15px 15px;
    margin-left: 45px;
    display: block;
    line-height: 1.2;
    transition: color 0.4s;
}
```

`label`側は以下のように記述されたのと同様になります

    label
        [ class "_1e7eb6f2"
        , onDoubleClick (EditingEntry todo.id True)
        ]
        [ text todo.description ]

  - `_1e7eb6f2`というクラス名が付与されています
      - この値は適用されているstyleから計算されたhash値です


## Nested Style

  - CSS preprocessorを使用するときのようにセレクターを入れ子にしてstyleを定義できます
  - use `with` for nested CSS!

```.elm
button
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
```

これは以下のように書き出されます

```css
._b75a75af {
    display: none;
    position: absolute;
    top: 0;
    right: 10px;
    bottom: 0;
    width: 40px;
    height: 40px;
    margin: auto 0;
    font-size: 30px;
    color: #cc9a9a;
    margin-bottom: 11px;
    transition: color 0.2s ease-out;
}

_b75a75af:hover {
    color: #af5b5e;
}

._b75a75af::after {
    content: '×';
}
```

  - hash値に続く形でセレクターが付加されます
      - space sensitive. Add space, then descendant selector.
  - 入れ子もできます

@docs with


### Media Query

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
        ] [..]

...outputs

```css
._a85c725b {
    margin: 0;
    padding: 0;
    list-style: none;
    position: absolute;
    right: 0;
    left: 0;
}

@media (max-width: 430px) {
    ._a85c725b {
        bottom: 10px;
    }
}
```

  - セレクターと同じようにMedia Queryを使用することができます

@docs withMedia

@docs withCustom


## Animation Style

    let
        loadingStyle =
            batch
                [ property "content" <| qt ""
                , property "position" "absolute"
                , property "width" "60%"
                , property "height" "60%"
                , property "border-radius" "100%"
                , property "border" "calc(30px / 10) solid transparent"
                , animation
                    [ ( "from", [ property "transform" "rotate(0deg)" ] )
                    , ( "to", [ property "transform" "rotate(360deg)" ] )
                    ]
                , property "animation-duration" "1s"
                , property "animation-iteration-count" "infinite"
                ]
    in
    batch
        [ property "border-radius" "50px"
        , property "width" "50px"

        -- [Copyright (c) 2019 Epicmax LLC](https://epic-spinners.epicmax.co/)
        , with "::after" [ loadingStyle, property "border-top-color" "#ffe9ef" ]
        , with "::before"
            [ loadingStyle
            , property "border-bottom-color" "#ffe9ef"
            , property "animation-direction" "alternate"
            ]
        ]

  - [`animation`](#animation)関数を使ってDOMに直接アニメーションを定義することができます
  - `animation`プロパティのみ暗黙に生成されるのでその他のアニメーションプロパティは別に定義します

@docs animation


# Helper

@docs qt


# Advanced topics


## CSSの重複除去は行われる？

    div []
        [ div [ css [ property "key" "value" ] ] []
        , div [ css [ property "key" "value" ] ] []
        , div [] [ div [ css [ property "key" "value" ] ] [] ]
        ]

...outputs only

```css
._xxx {
    key: value;
}
```


## `css`関数を複数使ったらどうなる？

    div
        [ css [ property "display" "none" ]
        , css [ property "display" "block" ]
        ]
        [ text "表示されますか？" ]

...outputs

```css
._xxx {
    display: none;
    display: block;
}
```

  - 合成されます


## クラス名がハッシュ値で読みにくい

    cssWithClass : String -> List Style -> Attribute msg
    cssWithClass classname styles =
        batchAttributes [ Attributes.class classname, css [ with ("." ++ classname) styles ] ]

  - クラス名を付加してみてください
  - 上記のようなヘルパーを定義するとよいでしょう

-}

import Origami.Css.Selector exposing (MediaQuery(..))
import Origami.Css.Style as Style
import Origami.Css.StyleTag as StyleTag


{-| `css`関数に渡す型です
-}
type alias Style =
    Style.Style


{-| Create a property style.

    css [ property "-webkit-font-smoothing" "none" ]

...outputs

```css
-webkit-font-smoothing: none;
```

-}
property : String -> String -> Style
property key value =
    StyleTag.Property key value
        |> Style.PropertyStyle


{-| Create an empty style.

    if predicate then
        property "key" "value"

    else
        noStyle

-}
noStyle : Style
noStyle =
    batch []


{-| Create a batched style.

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
    Style.BatchedStyle



----------------
-- NestedStyle
----------------


{-| Nest CSS with a selector and a media query.

    css
        [ withCustom "(max-width: 430px)" ".classname" <|
            [ property "key" "value" ]
        ]

...outputs

```css
@media (max-width: 430px) {
    _xxx.classname {
        key: value;
    }
}
```

-}
withCustom : String -> String -> List Style -> Style
withCustom mq s =
    Style.NestedStyle <|
        Origami.Css.Selector.Selector s (Just <| MediaQuery mq)


{-| Nest CSS with a selector.
生成されたhash値に続けて付加されるのでspace sensitiveです。空白が挟まった場合子孫セレクタと解釈されえます。

    css
        [ with ".classname" [ property "key" "value" ] ]

...outputs

```css
_xxx.classname {
    key: value;
}
```

-}
with : String -> List Style -> Style
with s =
    Style.NestedStyle (Origami.Css.Selector.Selector s Nothing)


{-| Nest CSS with a media query.

    css [ withMedia "screen" [ property "key" "value" ] ]

...outputs

```css
@media screen {
    _xxx {
        key: value;
    }
}
```

**note**: Media Queryを複数回入れ子にすることはできません

    css
        [ withMedia "screen"
            [ property "key" "value"
            , withMedia "not nestable" [ property "key" "value" ]
            , with ".nestable" [ property "key" "value" ]
            ]
        ]

..outputs

```css
@media screen {
    _xxx {
        key: value;
    }
}

@media screen {
    _xxx.nestable {
        key: value;
    }
}
```

  - 無効になったstyleは書き出されません
  - Media Queryの中でネストすると`@media`が複数書き出されます

-}
withMedia : String -> List Style -> Style
withMedia mq =
    Style.NestedStyle <| Origami.Css.Selector.Selector "" (Just <| MediaQuery mq)



----------------
-- Animation Style
----------------


{-| Define a animation.

    css
        [ animation
            [ ( "from", [ property "key" "value" ] )
            , ( "20%, 80%", [ property "key" "value" ] )
            , ( "to", [ property "key" "value" ] )
            ]
        ]

...outputs

```css
.hashed-class-name {
    animation-name: hashed-animation-name;
}

@keyframes hashed-animation-name {
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
```

  - `animation-name` propertyが暗黙に生成されます
  - keyframesブロックが生成されます

**note**: 引数の`List Style`で`with`などの入れ子と`animation`自身を使った場合無視されます。

-}
animation : List ( String, List Style ) -> Style
animation =
    Style.AnimationStyle



----------------
-- Helper
----------------


{-| For use with [`font-family`](https://developer.mozilla.org/docs/Web/CSS/font-family) and so on.

    property "font-family" (qt "Gill Sans Extrabold")

-}
qt : String -> String
qt str =
    String.concat [ "\"", str, "\"" ]
