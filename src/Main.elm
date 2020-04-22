module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Element exposing (..)
import Element.Border as BD
import Element.Font as Font
import Element.Input as Input
import Html
import Time



--Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



--INIT


type alias Lecture =
    { className : String
    , room : String
    , teacher : String
    , description : String
    , jigen : Int
    }


type alias ClassTime =
    { startTime : String
    , finishTime : String
    }


type alias Model =
    { lectureList : List (List Lecture)
    , workDays : Int
    , timeSchedule : List ClassTime
    , selectedBox : ( Int, Int )
    , selectedSchedule : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        oneDay =
            [ { className = "講義名", room = "教室", teacher = "担当教員", description = "メモ", jigen = 0 }
            , { className = "講義名", room = "教室", teacher = "担当教員", description = "メモ", jigen = 1 }
            , { className = "講義名", room = "教室", teacher = "担当教員", description = "メモ", jigen = 2 }
            , { className = "講義名", room = "教室", teacher = "担当教員", description = "メモ", jigen = 3 }
            , { className = "講義名", room = "教室", teacher = "担当教員", description = "メモ", jigen = 4 }
            ]
    in
    ( Model
        (List.repeat 6 oneDay)
        6
        [ { startTime = "8:30", finishTime = "10:00" }, { startTime = "8:30", finishTime = "10:00" }, { startTime = "8:30", finishTime = "10:00" }, { startTime = "8:30", finishTime = "10:00" }, { startTime = "8:30", finishTime = "10:00" } ]
        ( 0, 0 )
        0
    , Cmd.none
    )



--UPDATE


type Msg
    = ClickedBox ( Int, Int )
    | ChangeName String
    | ClickedTime Int


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ClickedBox pair ->
            ( { model | selectedBox = pair }, Cmd.none )

        ChangeName str ->
            ( { model | selectedBox = model.selectedBox }, Cmd.none )

        ClickedTime n ->
            ( { model | selectedSchedule = n }, Cmd.none )



--VIEW


view : Model -> Html.Html Msg
view model =
    layout [] <|
        column [ centerX, width fill ]
            [ row [ explain Debug.todo, width fill ]
                [ column [] (viewTimeSchedule model.timeSchedule)

                --, column [ width (px 70) ] genBoxs
                , row [ width fill, height fill ] (columnMap (genBoxs model.lectureList))
                ]
            ]


columnMap : List (List (Element Msg)) -> List (Element Msg)
columnMap aListList =
    let
        columnFun s =
            column [ height fill, width fill ] s
    in
    List.map columnFun aListList


genBoxs : List (List Lecture) -> List (List (Element Msg))
genBoxs lecList =
    let
        genButton a =
            Input.button [ BD.color (rgb255 0 0 0), BD.width 1, BD.solid, width fill, height fill ]
                { onPress = Just (ClickedBox ( 0, 0 ))
                , label =
                    column [ alignTop ]
                        [ el [ Font.size 16 ] <| text a.className
                        , el [ Font.size 8 ] <| text a.teacher
                        , el [ Font.size 10 ] <| text a.description
                        ]
                }
    in
    List.map (List.map genButton) lecList
viewTimeSchedule : List ClassTime -> List (Element Msg)
viewTimeSchedule classTimeList =
    let
        times =
            List.indexedMap Tuple.pair

        showColumn ( n, a ) =
            Input.button [ BD.color (rgb255 0 0 0), BD.width 1, BD.solid ]
                { onPress = Just (ClickedTime n)
                , label =
                    column []
                        [ el [ alignRight ] <| text a.startTime
                        , el [ alignRight ] <| text "   ~   "
                        , el [ alignRight ] <| text a.finishTime
                        ]
                }
    in
    List.map showColumn (times classTimeList)



-- SUNSCRIPTUONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
