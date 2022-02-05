module Origami.Css.Selector exposing
    ( MediaQuery(..)
    , Selector(..)
    , initial
    , listToString
    , maybeToString
    , nest
    , toString
    )

{-| -}


{-| Selector

  - セレクターを足し算的な演算ができるように定義できたのがすごいよかった
      - CSS in XXの手法的にDOMに書かれるstyleにはSASSのようなネストした記法が必要になる
          - そのため型的には再帰的な感じになる
          - 出力先のCSSはネストできないのでいい感じにフラットに畳む必要がある
      - Media Queryも再帰的で扱いが難しかったが`Selector`として取り込むことで統一的に扱えて簡単になった
      - `Style` -> `FlatStyle`で`nest`を使って`Selector`をつなげることで再帰を解決してフラットにすることできた

-}
type Selector
    = Selector String (Maybe MediaQuery)


type MediaQuery
    = MediaQuery String


initial : Selector
initial =
    Selector "" Nothing


{-|

  - 単に足し合わせる
  - space sensitive
  - media queryはネストできない

-}
nest : Selector -> Selector -> Maybe Selector
nest (Selector ps pmq) child =
    case ( pmq, child ) of
        -- media queryはネストできない
        ( Just _, Selector _ (Just _) ) ->
            Nothing

        ( _, Selector cs cmq ) ->
            Just <| Selector (ps ++ cs) (or pmq cmq)


{-| ref. <https://github.com/elm-community/maybe-extra/blob/5.2.0/src/Maybe/Extra.elm#L260>
-}
or : Maybe a -> Maybe a -> Maybe a
or ma mb =
    case ma of
        Nothing ->
            mb

        Just _ ->
            ma



----------------
-- toString
-- クラス名に使うhash値計算に使う
----------------


toString : Selector -> String
toString (Selector s mq) =
    String.concat
        [ "(Selector\""
        , s
        , "\""
        , Maybe.map mediaQueryToString mq |> maybeToString
        , ")"
        ]


listToString : List String -> String
listToString list =
    String.concat
        [ "["
        , String.join "," list
        , "]"
        ]


maybeToString : Maybe String -> String
maybeToString maybe =
    case maybe of
        Just val ->
            String.concat [ "(Just ", val, ")" ]

        Nothing ->
            "(Nothing)"


mediaQueryToString : MediaQuery -> String
mediaQueryToString (MediaQuery val) =
    String.concat [ "(MediaQuery\"", val, "\")" ]
