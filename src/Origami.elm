module Origami exposing
    ( Style, property, batch, noStyle
    , withClass, withAttribute, withPseudoClass, withPseudoElement
    , withDescendants, withChildren, withGeneralSiblings, withAdjacentSiblings
    , Tag, tag, everyTag
    , withMedia
    , with, withEach, withCustom
    , Selector, selector, pseudoElement
    , RepeatableSelector, class, pseudoClass, attribute, descendant, child, generalSibling, adjacentSibling
    , animation, Property, propertyA
    , KeyframesSelector, from, to, pct
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
            , withPseudoElement "before"
                [ property "content" <| qt "❯"
                , property "font-size" "22px"
                , property "color" "#e6e6e6"
                , property "padding" "10px 27px 10px 27px"
                ]
            , with (pseudoElement [ pseudoClass "checked" ] "before")
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

  - See [`examples/TodoMVC`](https://github.com/miyamoen/elm-origami/blob/master/examples/TodoMVC)
      - styled by Origami
      - forked from [`evancz/elm-todomvc`](https://github.com/evancz/elm-todomvc)


# How to Use

  - ここからOrigamiの使い方を説明していきます
  - elm-cssとほぼ同じようなAPIを定義しています
      - 型付けされたproperty関数は定義していないことが大きな違いです


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

  - CSS preprocessorのようにセレクターを入れ子にしてstyleを定義できます
  - 入れ子にする関数は簡易的なAPIとカスタム可能なAPIに分けられています
      - 簡易的なAPIはelm-cssを参考にしています

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
        , withPseudoClass "hover" [ property "color" "#af5b5e" ]
        , withPseudoElement "after" [ property "content" "'×'" ]
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
  - 更にネストすることもできます

@docs withClass, withAttribute, withPseudoClass, withPseudoElement


### CSS Combinators

結合子も使用することができます

    footer
        [ css
            [ property "margin" "65px auto 0"
            , property "color" "#bfbfbf"
            , property "font-size" "10px"
            , property "text-shadow" "0 1px 0 rgba(255, 255, 255, 0.5)"
            , property "text-align" "center"
            , withDescendants [ tag "p" ] [ property "line-height" "1" ]
            , withDescendants [ tag "a" ]
                [ property "color" "inherit"
                , property "text-decoration" "none"
                , property "font-weight" "400"
                , withPseudoClass "hover" [ property "text-decoration" "underline" ]
                ]
            ]
        ] [...]

...outputs

```css
._89167f0f {
    margin: 65px auto 0;
    color: #bfbfbf;
    font-size: 10px;
    text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5);
    text-align: center;
}

._89167f0f p {
    line-height: 1;
}

._89167f0f a {
    color: inherit;
    text-decoration: none;
    font-weight: 400;
}
```

  - Origami supports descendant, child, general sibling and adjacent sibling combinators
  - `tag`関数を使って対象のタグを複数指定することができます

@docs withDescendants, withChildren, withGeneralSiblings, withAdjacentSiblings
@docs Tag, tag, everyTag


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


## Custom Nested Style

  - ここまでの`withXxx`関数で大体のことには事足りるかと思います
  - もしもっと柔軟にstyleを入れ子にしたくなったのならOrigamiにおける`Selector`を学びましょう

```css
             ┌ child              ┌ descendant                       ┌ adjacent sibling
     class   │   pseudo class     │          attribute               │  pseudo element
     ┌────┐ ┌─┐┌──────────────┐┌──────┐┌───────────────────┐        ┌─┐┌─────┐
._xxx.class > *:nth-child(2n+1) section[aria-hidden="false"], ._xxx + *::after {...}
└──────────────────────────────────────────────────────────┘  └──────────────┘
                          selector                                selector
```

  - See an above diagram.
      - class selector, pseudo class, attribute selectorが並んでいます
          - また各種結合子とtype selectorかuniversal selectorがまとめられています
          - これらを`RepeatableSelector`としてまとめています
      - `Selector`型を生成する[`selector`関数](#selector)は`RepeatableSelector`の`List`を受け取るようになっています
          - またpseudo elementを付加する場合は[`pseudoElement`](#pseudoElement)を使ってください
      - 生成した`Selector`は`with`, `withEach`, `withCustom`で`css`関数に繋げられます
          - 図のように`Selector`を列挙したければ`withEach`か`withCustom`を使ってください
          - `withCustom`にはMedia Queryも付加することができます

@docs with, withEach, withCustom
@docs Selector, selector, pseudoElement
@docs RepeatableSelector, class, pseudoClass, attribute, descendant, child, generalSibling, adjacentSibling


## Animation Style

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

  - [`animation`](#animation)関数を使ってDOMに直接アニメーションを定義することができます
  - [`propertyA`](#propertyA)関数を使ってpropertyを記述します
      - 型の都合で`property`, `batch`, `noStyle`は使えません
  - `animation`プロパティのみ暗黙に生成されるのでその他のアニメーションプロパティは別に定義します

@docs animation, Property, propertyA
@docs KeyframesSelector, from, to, pct


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

  - 重複除去は`css`に適用したstyleの単位で行われます


## `css`関数を複数使ったらどうなる？

    div
        [ css [ property "display" "none" ]
        , css [ property "display" "block" ]
        ]
        [ text "表示されますか？" ]

  - このdivは表示されるでしょうか？
      - 答えは「わかりません」
      - styleは`css`関数でまとめられた単位で扱われ、`Dict`を経由して書き出されます
      - そのため`ccs`を使う順番に依存した実装は行わないほうがいいでしょう
  - もし既に適用されている`css`の値を上書きしたいのならば`withClass`などを使ってセレクターの詳細度を上げるとよいでしょう


## クラス名がハッシュ値で読みにくい

    cssWithClass : String -> List Style -> Attribute msg
    cssWithClass classname styles =
        batchAttributes [ Attributes.class classname, css [ withClass classname styles ] ]

  - クラス名を付加してみてください
  - 上記のようなヘルパーを定義するとよいでしょう

-}

import Origami.Css.Selector exposing (MediaQuery(..))
import Origami.Css.Style as Style
import Origami.Css.StyleTag as StyleTag


{-| -}
type alias Style =
    Style.Style


{-| -}
type alias Selector =
    Origami.Css.Selector.Single


{-|

    type RepeatableSelector
        = ClassSelector String
        | PseudoClassSelector String
        | AttributeSelector String
        | DescendantCombinator Tag
        | ChildCombinator Tag
        | GeneralSiblingCombinator Tag
        | AdjacentSiblingCombinator Tag

-}
type alias RepeatableSelector =
    Origami.Css.Selector.Repeatable


{-| -}
type alias Tag =
    Origami.Css.Selector.Tag


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


{-| Nest with `Selector` list and a media query.

    css
        [ withCustom "(max-width: 430px)"
            [ selector [ class "classname" ]
            , selector [ attribute "title" ]
            ]
            [ property "key" "value" ]
        ]

...outputs

```css
@media (max-width: 430px) {
    _xxx.classname, _xxx[title] {
        key: value;
    }
}
```

-}
withCustom : String -> List Selector -> List Style -> Style
withCustom mq selectors =
    Style.NestedStyle <|
        -- 利便性のためにListで受ける
        case selectors of
            [] ->
                Origami.Css.Selector.emptyWith mq

            s :: ss ->
                Origami.Css.Selector.Selector s ss (Just <| MediaQuery mq)


{-| Nest with a `Selector`.

    css
        [ with (selector [ class "classname" ]) [ property "key" "value" ] ]

...outputs

```css
_xxx.classname {
    key: value;
}
```

-}
with : Selector -> List Style -> Style
with s =
    Style.NestedStyle (Origami.Css.Selector.Selector s [] Nothing)


{-| Nest with `Selector` list.

    css
        [ withEach
            [ selector [ class "classname" ]
            , selector [ attribute "title" ]
            ]
            [ property "key" "value" ]
        ]

...outputs

```css
_xxx.classname, _xxx[title] {
    key: value;
}
```

**note**: もし空リストを与えたらそのstyleは霧視されます

    css
        [ withEach [] [ property "key" "empty-value" ]
        , property "key" "value"
        ]

...outputs

```css
_xxx {
    key: value;
}
```

-}
withEach : List Selector -> List Style -> Style
withEach selectors =
    Style.NestedStyle <|
        -- 利便性のためにListで受ける
        case selectors of
            [] ->
                Origami.Css.Selector.initial

            s :: ss ->
                Origami.Css.Selector.Selector s ss Nothing


{-| Nest with a media query.

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
            , withClass "nestable" [ property "key" "value" ]
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
    Style.NestedStyle <| Origami.Css.Selector.emptyWith mq


{-| -}
selector : List RepeatableSelector -> Selector
selector rs =
    Origami.Css.Selector.Single rs Nothing


{-| -}
pseudoElement : List RepeatableSelector -> String -> Selector
pseudoElement rs pe =
    Origami.Css.Selector.Single rs <| Just <| Origami.Css.Selector.PseudoElement pe


{-| Represent a class selector.

    class "classname"

...outputs

```css
.classname
```

-}
class : String -> RepeatableSelector
class =
    Origami.Css.Selector.ClassSelector


{-| Represent a pseudo class.

    pseudoClass "hover"

...outputs

```css
:hover
```

-}
pseudoClass : String -> RepeatableSelector
pseudoClass =
    Origami.Css.Selector.PseudoClassSelector


{-| Represent an attribute selector.

    attribute "aria-hidden=\"false\""

...outputs

```css
[aria-hidden="false"]
```

-}
attribute : String -> RepeatableSelector
attribute =
    Origami.Css.Selector.AttributeSelector


{-| Represent a descendant combinator with a type selector or universal selector.

    descendant (tag "p")

...outputs

```css
 p
```

  - descendant combinatorは空白で表せられるので見た目的に分かりにくい

-}
descendant : Tag -> RepeatableSelector
descendant =
    Origami.Css.Selector.DescendantCombinator


{-| Represent a child combinator with a type selector or universal selector.

    child (tag "li")

...outputs

```css
 > li
```

-}
child : Tag -> RepeatableSelector
child =
    Origami.Css.Selector.ChildCombinator


{-| Represent a general sibling combinator with a type selector or universal selector.

    generalSibling everyTag

...outputs

```css
 ~ *
```

-}
generalSibling : Tag -> RepeatableSelector
generalSibling =
    Origami.Css.Selector.GeneralSiblingCombinator


{-| Represent a adjacent sibling combinator with a type selector or universal selector.

    adjacentSibling (tag "section")

...outputs

```css
 + section
```

-}
adjacentSibling : Tag -> RepeatableSelector
adjacentSibling =
    Origami.Css.Selector.AdjacentSiblingCombinator


{-| Represent an element selector.

    tag "p"

...outputs

```css
p
```

-}
tag : String -> Tag
tag =
    Origami.Css.Selector.TypeSelector


{-| Represent a universal selector.

    everyTag

...outputs

```css
*
```

**note**: もし`.parent > .child`のようなselectorを使用したいと思っているなら`.parent > *.child`のように暗黙に全称セレクターが指定されていると思って`everyTag`を使ってください

-}
everyTag : Tag
everyTag =
    Origami.Css.Selector.UniversalSelector



----------------
-- NestedStyle
-- shorthand
----------------


{-| Nest with a class selector.

    css [ withClass "classname" [ property "key" "value" ] ]

...outputs

```css
_xxx.classname {
    key: value;
}
```

-}
withClass : String -> List Style -> Style
withClass val =
    with (selector [ class val ])


{-| Nest with a attribute selector.

    css [ withAttribute """href="https://example.org"""" [ property "key" "value" ] ]

...outputs

```css
_xxx[href="https://example.org"] {
    key: value;
}
```

-}
withAttribute : String -> List Style -> Style
withAttribute val =
    with (selector [ attribute val ])


{-| Nest with a pseudo class.

    css [ withPseudoClass "hover" [ property "key" "value" ] ]

...outputs

```css
_xxx:hover {
    key: value;
}
```

-}
withPseudoClass : String -> List Style -> Style
withPseudoClass val =
    with (selector [ pseudoClass val ])


{-| Nest with a pseudo element.

    css [ withPseudoElement "after" [ property "content" <| qt "×" ] ]

...outputs

```css
_xxx::after {
    content: "×";
}
```

**note**: `withPseudoElement`を使ったらそれ以上ネストできません

    css
        [ withPseudoElement "after"
            [ property "content" <| qt "×"
            , withClass "notAllowed"
                [ property "color" "white" ]
            ]
        ]

...outputs

```css
_xxx::after {
    content: "×";
}
```

  - 型で制限できていませんがこのように無効な部分は書き出されません

-}
withPseudoElement : String -> List Style -> Style
withPseudoElement val =
    with (pseudoElement [] val)


{-| Nest with descendant combinators.

    css [ withDescendants [ tag "p", tag "li" ] [ property "key" "value" ] ]

...outputs

```css
_xxx p, _xxx li {
    key: value;
}
```

-}
withDescendants : List Tag -> List Style -> Style
withDescendants vals =
    withEach <| List.map (\t -> selector [ descendant t ]) vals


{-| Nest with child combinators.

    css [ withChildren [ tag "p", tag "li" ] [ property "key" "value" ] ]

...outputs

```css
_xxx > p, _xxx > li {
    key: value;
}
```

-}
withChildren : List Tag -> List Style -> Style
withChildren vals =
    withEach <| List.map (\t -> selector [ child t ]) vals


{-| Nest with general sibling combinators.

    css [ withGeneralSiblings [ tag "p", tag "li" ] [ property "key" "value" ] ]

...outputs

```css
_xxx ~ p, _xxx ~ li {
    key: value;
}
```

-}
withGeneralSiblings : List Tag -> List Style -> Style
withGeneralSiblings vals =
    withEach <| List.map (\t -> selector [ generalSibling t ]) vals


{-| Nest with adjacent sibling combinators.

    css [ withAdjacentSiblings [ tag "p", tag "li" ] [ property "key" "value" ] ]

...outputs

```css
_xxx + p, _xxx + li {
    key: value;
}
```

-}
withAdjacentSiblings : List Tag -> List Style -> Style
withAdjacentSiblings vals =
    withEach <| List.map (\t -> selector [ adjacentSibling t ]) vals



----------------
-- Animation Style
----------------


{-| Selectors for `animation`.

`from`, `to` and `pct`(%).

-}
type alias KeyframesSelector =
    StyleTag.KeyframesSelector


{-| -}
type alias Property =
    StyleTag.Property


{-| Define a animation.

    css
        [ animation
            [ ( ( from, [] ), [ propertyA "key" "value" ] )
            , ( ( pct 20, [ pct 80 ] ), [ propertyA "key" "value" ] )
            , ( ( to, [] ), [ propertyA "key" "value" ] )
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

-}
animation : List ( ( KeyframesSelector, List KeyframesSelector ), List Property ) -> Style
animation =
    Style.AnimationStyle


{-| `from` token.
-}
from : KeyframesSelector
from =
    StyleTag.KeyframesSelectorFrom


{-| `to` token.
-}
to : KeyframesSelector
to =
    StyleTag.KeyframesSelectorTo


{-| `30%`, `70%` and so on.
-}
pct : Float -> KeyframesSelector
pct =
    StyleTag.KeyframesSelectorPercent


{-|

  - animation用の`property`
  - `property`とは型が違う

-}
propertyA : String -> String -> Property
propertyA =
    StyleTag.Property



----------------
-- Helper
----------------


{-| For use with [`font-family`](https://developer.mozilla.org/docs/Web/CSS/font-family) and so on.

    property "font-family" (qt "Gill Sans Extrabold")

-}
qt : String -> String
qt str =
    String.concat [ "\"", str, "\"" ]
