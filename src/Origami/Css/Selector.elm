module Origami.Css.Selector exposing
    ( Combinator(..)
    , Head(..)
    , MediaQuery(..)
    , PseudoElement(..)
    , Repeatable(..)
    , Selector(..)
    , Sequence(..)
    , empty
    , listToString
    , maybeToString
    , nest
    , toString
    )


type Selector
    = Selector (List Repeatable) (List Sequence) (Maybe PseudoElement) (Maybe MediaQuery)


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


empty : Selector
empty =
    Selector [] [] Nothing Nothing


{-|

  - 疑似要素が含まれていればそれ以上ネストできない
  - media query はネストできない

-}
nest : Selector -> Selector -> Maybe Selector
nest (Selector r1 s1 p1 m1) (Selector r2 s2 p2 m2) =
    case ( p1, m1, m2 ) of
        ( Just _, _, _ ) ->
            Nothing

        ( Nothing, Just _, Just _ ) ->
            Nothing

        _ ->
            Just <|
                case List.reverse s1 of
                    [] ->
                        Selector (r1 ++ r2) s2 p2 (or m1 m2)

                    (Sequence c h lastRepeatables) :: heads ->
                        Selector r1 (List.reverse (Sequence c h (lastRepeatables ++ r2) :: heads) ++ s2) p2 (or m1 m2)


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
toString (Selector rs ss pe mq) =
    String.concat
        [ "(Selector"
        , List.map repeatableToString rs |> listToString
        , List.map sequenceToString ss |> listToString
        , Maybe.map pseudoElementToString pe |> maybeToString
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
