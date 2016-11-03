module Stats.State exposing (..)

import Stats.Rest exposing (..)
import Stats.Types exposing (..)
import Json.Decode exposing (..)
import Ports


-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model [] Woot False emptyPlay, Cmd.none )


emptyPlay : Play
emptyPlay =
    Play emptyScore emptyUser emptyMedia


emptyScore : Score
emptyScore =
    Score 0 0 0 0


emptyUser : User
emptyUser =
    User 0 ""


emptyMedia : Media
emptyMedia =
    Media "" "" 0 0 "" "" ""



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Sort by ->
            ( { model | metric = by }, Cmd.none )

        AddPlay playStr ->
            case (decodeString playDecoder playStr) of
                Ok value ->
                    let
                        ps =
                            value :: model.plays
                    in
                        ( { model | plays = ps }, Cmd.none )

                Err msg ->
                    ( { model | plays = [] }, Cmd.none )

        Preview play ->
            ( { model
                | currentPlay = play
                , previewPlay = True
              }
            , Ports.setvolume 0
            )

        ClosePreview ->
            ( { model
                | currentPlay = emptyPlay
                , previewPlay = False
              }
            , Ports.setvolume 100
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.plugplay AddPlay
