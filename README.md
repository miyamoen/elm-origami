# elm-origami

`elm-origami` lets you define CSS in Elm. This package is forked from [`rtfeldman/elm-css`](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/).

Here's an example of how to define some `elm-origami` styles:

```elm
import Origami exposing (..)
import Origami.Html exposing (..)
import Origami.Html.Attributes exposing (css)
import Origami.Html.Events exposing (onClick)

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
```

- See full [examples](https://github.com/miyamoen/elm-origami/blob/master/examples).

See [the `Origami` module documentation](http://package.elm-lang.org/packages/miyamoen/elm-origami/latest/Origami) for an explanation of how this code works.

## なぜ`rtfeldman/elm-css`をフォークしたのか

- `miyamoen/elm-origami`は`rtfeldman/elm-css`をフォークして改変した package です
  - 主に違うところは`elm-css`の typed-css の要素を取り除いて内部の型を整理したところです
- 2020/08 現在、`elm-css`はあまりメンテナンスされていないようです
  - とはいえ動くので使う分には大した問題はありません
  - 内部構造があまりきれいではなくて **ついついきれいにしたくなりました**
- `elm-css`の typed CSS な部分が気に入らない
  - `elm-css`は CSS に型付けをしようという package で、昔は CSS ファイルを生成していましたが今は node に直接付与するスタイルになっています
  - CSS の各プロパティを型がある状態で記述できますが、型は少しわかりにくいですし覚えるが少し煩雑です
  - elm-origami では無理して型付けする必要がないと考えています
    - そのため[`property`](http://package.elm-lang.org/packages/miyamoen/elm-origami/latest/Origami#property)関数のみ提供しています
      - CSS には同じ property でもいろいろな記述方法があったり新しい property が増えたりしますが、そのすべてを常に使うとは限りません
      - 型付けをするなら用途が必要十分でよく設計された package を作るのがよいと思います
    - 型付けされた property 関数を提供しないことで実装が小さくなります
- `elm-origami`には新規性がほぼありません
  - 型付けされた property 関数がない
  - CSS をより柔軟にネストできる

## Origami の名前の意味

- 特に意味はないです
- 他と区別が付く名前なら何でもよかった
- 一応 CSS を node に折り込んでいるような雰囲気の意味で折り紙にしました

## Inspired by

- [elm-css](https://package.elm-lang.org/packages/rtfeldman/elm-css/latest/)
- [Sass](http://sass-lang.com/)
- [styled-components](https://styled-components.com/)
- [emotion](https://emotion.sh/docs/introduction)
