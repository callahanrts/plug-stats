module Stats.State exposing (..)

import Stats.Rest exposing (..)
import Stats.Types exposing (..)
import Json.Decode exposing (..)
import Ports


-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model [] Woot, Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd msg )
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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.plugplay AddPlay
