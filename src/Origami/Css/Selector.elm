module Origami.Css.Selector exposing
    ( Combinator(..)
    , MediaQuery(..)
    , PseudoElement(..)
    , Repeatable(..)
    , Selector(..)
    , Single(..)
    , Tag(..)
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
    = Selector (List Single) (Maybe MediaQuery)


type Single
    = Single (List Repeatable) (Maybe PseudoElement)


type Repeatable
    = ClassSelector String
    | PseudoClassSelector String
    | AttributeSelector String
    | Sequence Combinator Tag


type Tag
    = TypeSelector String
    | UniversalSelector


type Combinator
    = DescendantCombinator
    | ChildCombinator
    | GeneralSiblingCombinator
    | AdjacentSiblingCombinator


type PseudoElement
    = PseudoElement String


type MediaQuery
    = MediaQuery String


initial : Selector
initial =
    Selector [ Single [] Nothing ] Nothing


{-|

  - 疑似要素が含まれていればそれ以上ネストできない
  - media query はネストできない


## 条件分岐網羅

  - header
      - ps: parent singles
      - pm: parent media query
      - cs: child singles
      - cm: child media query
      - Rs: Result
  - body
      - em: empty
      - fl: filled
      - no: nothing
      - ju: just

| ps | pm | cs | cm | Rs |
| -- | -- | -- | -- | -- |
| em | no | em | no | 02 |
| em | no | em | ju | 02 |
| em | no | fl | no | 02 |
| em | no | fl | ju | 02 |
| em | ju | em | no | 03 |
| em | ju | em | ju | 01 |
| em | ju | fl | no | 04 |
| em | ju | fl | ju | 01 |
| fl | no | em | no | 03 |
| fl | no | em | ju | 05 |
| fl | no | fl | no | 06 |
| fl | no | fl | ju | 06 |
| fl | ju | em | no | 03 |
| fl | ju | em | ju | 01 |
| fl | ju | fl | no | 06 |
| fl | ju | fl | ju | 01 |

-}
nest : Selector -> Selector -> Maybe Selector
nest (Selector ps pm) (Selector cs cm) =
    case ( ( ps, pm ), ( cs, cm ) ) of
        -- media queryはネストできない
        ( ( _, Just _ ), ( _, Just _ ) ) ->
            Nothing

        -- empty (invalid) parent selector
        ( ( [], Nothing ), ( _, _ ) ) ->
            Nothing

        -- empty (invalid) child selector
        ( ( _, _ ), ( [], Nothing ) ) ->
            Nothing

        -- parentがmedia queryのみ
        ( ( [], Just _ ), ( nonEmpty, Nothing ) ) ->
            Just <| Selector nonEmpty pm

        -- childがmedia queryのみ
        ( ( nonEmpty, Nothing ), ( [], Just _ ) ) ->
            Just <| Selector nonEmpty cm

        _ ->
            case lift2 nestSingle ps cs |> List.filterMap identity of
                [] ->
                    Nothing

                nonEmpty ->
                    Just <| Selector nonEmpty (or pm cm)


nestSingle : Single -> Single -> Maybe Single
nestSingle parent child =
    case ( parent, child ) of
        ( Single _ (Just _), _ ) ->
            Nothing

        ( _, Single [] Nothing ) ->
            Nothing

        ( Single [] Nothing, _ ) ->
            Just child

        ( Single prs Nothing, Single crs cpe ) ->
            Just <| Single (prs ++ crs) cpe


{-| ref. <https://github.com/elm-community/maybe-extra/blob/5.2.0/src/Maybe/Extra.elm#L260>
-}
or : Maybe a -> Maybe a -> Maybe a
or ma mb =
    case ma of
        Nothing ->
            mb

        Just _ ->
            ma


{-| ref. <https://github.com/elm-community/list-extra/blob/8.2.4/src/List/Extra.elm#L1763>
-}
lift2 : (a -> b -> c) -> List a -> List b -> List c
lift2 f la lb =
    la |> List.concatMap (\a -> lb |> List.concatMap (\b -> [ f a b ]))



----------------
-- toString
-- クラス名に使うhash値計算に使う
----------------


toString : Selector -> String
toString (Selector ss mq) =
    String.concat
        [ "(Selector"
        , List.map singleToString ss |> listToString
        , Maybe.map mediaQueryToString mq |> maybeToString
        , ")"
        ]


singleToString : Single -> String
singleToString (Single rs pe) =
    String.concat
        [ "(Single"
        , List.map repeatableToString rs |> listToString
        , Maybe.map pseudoElementToString pe |> maybeToString
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


repeatableToString : Repeatable -> String
repeatableToString r =
    case r of
        ClassSelector val ->
            String.concat [ "(ClassSelector\"", val, "\")" ]

        PseudoClassSelector val ->
            String.concat [ "(PseudoClassSelector\"", val, "\")" ]

        AttributeSelector val ->
            String.concat [ "(AttributeSelector\"", val, "\")" ]

        Sequence c tag ->
            String.concat
                [ "(Sequence"
                , combinatorToString c
                , tagToString tag
                , ")"
                ]


combinatorToString : Combinator -> String
combinatorToString c =
    case c of
        DescendantCombinator ->
            "(DescendantCombinator)"

        ChildCombinator ->
            "(ChildCombinator)"

        GeneralSiblingCombinator ->
            "(GeneralSiblingCombinator)"

        AdjacentSiblingCombinator ->
            "(AdjacentSiblingCombinator)"


tagToString : Tag -> String
tagToString t =
    case t of
        TypeSelector val ->
            String.concat [ "(TypeSelector\"", val, "\")" ]

        UniversalSelector ->
            "(UniversalSelector)"


pseudoElementToString : PseudoElement -> String
pseudoElementToString (PseudoElement val) =
    String.concat [ "(PseudoElement\"", val, "\")" ]


mediaQueryToString : MediaQuery -> String
mediaQueryToString (MediaQuery val) =
    String.concat [ "(MediaQuery\"", val, "\")" ]
