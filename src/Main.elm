port module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes as Attrs
import Html.Events exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Models + Decoders


type alias User =
    { id : Int
    , username : String
    }


userDecoder : Decoder User
userDecoder =
    decode User
        |> required "id" int
        |> required "username" string


type alias Media =
    { author : String
    , cid : String
    , duration : Int
    , format : Int
    , id : String
    , image : String
    , title : String
    }


mediaDecoder : Decoder Media
mediaDecoder =
    decode Media
        |> required "author" string
        |> required "cid" string
        |> required "duration" int
        |> required "format" int
        |> required "id" string
        |> required "image" string
        |> required "title" string


type alias Score =
    { positive : Int
    , negative : Int
    , grabs : Int
    , listeners : Int
    }


scoreDecoder : Decoder Score
scoreDecoder =
    decode Score
        |> required "positive" int
        |> required "negative" int
        |> required "grabs" int
        |> required "listeners" int


type alias Play =
    { score : Score
    , user : User
    , media : Media
    }


playDecoder : Decoder Play
playDecoder =
    decode Play
        |> required "score" scoreDecoder
        |> required "user" userDecoder
        |> required "media" mediaDecoder


type alias Model =
    { plays : List Play
    , total : Int
    }



-- Update


type Msg
    = AddPlay String


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        AddPlay playStr ->
            case (decodeString playDecoder playStr) of
                Ok value ->
                    let
                        ps =
                            value :: model.plays
                    in
                        ( Model ps (List.length ps), Cmd.none )

                Err msg ->
                    ( Model [] -1, Cmd.none )



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model [] 0, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ ul [] (List.map showPlay model.plays)
        ]


showPlay : Play -> Html Msg
showPlay play =
    li []
        [ div [ Attrs.class "title" ] [ text play.media.title ]
        , div [ Attrs.class "author" ] [ text play.media.author ]
        , (playStat play)
        ]


playStat : Play -> Html Msg
playStat play =
    div []
        [ div [ Attrs.class "icon icon-woot" ] []
        , text (playMetric play.score.positive play.score.listeners)
        , div [ Attrs.class "icon icon-meh" ] []
        , text (playMetric play.score.negative play.score.listeners)
        , div [ Attrs.class "icon icon-grab" ] []
        , text (playMetric play.score.grabs play.score.listeners)
        ]


playMetric : Int -> Int -> String
playMetric num total =
    toString num



-- SUBSCRIPTION


port playSub : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    playSub AddPlay
