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
    }


type alias ClassTime =
    { startTime : String
    , finishTime : String
    }


type alias Model =
    { tableList : List (List Lecture)
    , timeSchedule : List ClassTime
    , selectedBox : ( Int, Int )
    , selectedSchedule : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [ [] ]
        [ { startTime = "8:30", finishTime = "10:00" }, { startTime = "8:30", finishTime = "10:00" }, { startTime = "8:30", finishTime = "10:00" }, { startTime = "8:30", finishTime = "10:00" }, { startTime = "8:30", finishTime = "10:00" }, { startTime = "8:30", finishTime = "10:00" } ]
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
        column [ centerX ]
            [ el [ Font.size 30, alignLeft ] <| text "sad"
            , row []
                [ column [ width (px 40) ] (viewTimeSchedule model.timeSchedule)
                ]
            ]


viewTimeSchedule : List ClassTime -> List (Element Msg)
viewTimeSchedule classTimeList =
    let
        times =
            List.indexedMap Tuple.pair

        showColumn ( n, a ) =
            Input.button [ BD.color (rgb255 0 0 0), BD.width 1, BD.solid ] { onPress = Just (ClickedTime n), label = column [] [ el [ alignRight ] <| text a.startTime, el [ alignRight ] <| text "   ~   ", el [ alignRight ] <| text a.finishTime ] }
    in
    List.map showColumn (times classTimeList)



-- SUNSCRIPTUONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
