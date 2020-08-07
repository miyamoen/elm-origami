module Origami.Css.Selector exposing
    ( Combinator(..)
    , Head(..)
    , MediaQuery(..)
    , PseudoElement(..)
    , Repeatable(..)
    , Selector(..)
    , Sequence(..)
    , Single(..)
    , initial
    , listToString
    , maybeToString
    , nest
    , toString
    )


type Selector
    = Selector (List Single) (Maybe MediaQuery)


type Single
    = Single (List Repeatable) (List Sequence) (Maybe PseudoElement)


type Sequence
    = Sequence Combinator Head (List Repeatable)


type Head
    = TypeSelector String
    | UniversalSelector


type Repeatable
    = ClassSelector String
    | PseudoClassSelector String
    | AttributeSelector String


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
    Selector [ Single [] [] Nothing ] Nothing


{-|

  - 疑似要素が含まれていればそれ以上ネストできない
  - media query はネストできない

-}
nest : Selector -> Selector -> Maybe Selector
nest (Selector parent pm) (Selector child cm) =
    case ( pm, cm, child ) of
        -- media queryはネストできない
        ( Just _, Just _, _ ) ->
            Nothing

        -- empty (invalid) child selector
        ( _, Nothing, [] ) ->
            Nothing

        -- childがmedia queryのみ
        ( Nothing, Just _, [] ) ->
            Just <| Selector parent cm

        _ ->
            case lift2 nestSingle parent child |> List.filterMap identity of
                [] ->
                    Nothing

                nonEmpty ->
                    Just <| Selector nonEmpty (or pm cm)


nestSingle : Single -> Single -> Maybe Single
nestSingle (Single r1 s1 p1) (Single r2 s2 p2) =
    case p1 of
        Just _ ->
            Nothing

        Nothing ->
            Just <|
                case List.reverse s1 of
                    [] ->
                        Single (r1 ++ r2) s2 p2

                    (Sequence c h lastRepeatables) :: heads ->
                        Single r1 (List.reverse (Sequence c h (lastRepeatables ++ r2) :: heads) ++ s2) p2


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
singleToString (Single rs ss pe) =
    String.concat
        [ "(Single"
        , List.map repeatableToString rs |> listToString
        , List.map sequenceToString ss |> listToString
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


sequenceToString : Sequence -> String
sequenceToString (Sequence c h rs) =
    String.concat
        [ "(Sequence"
        , combinatorToString c
        , headToString h
        , List.map repeatableToString rs |> listToString
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


headToString : Head -> String
headToString h =
    case h of
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
