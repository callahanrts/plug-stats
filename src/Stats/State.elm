module Stats.State exposing (..)

import Stats.Rest exposing (..)
import Stats.Types exposing (..)
import Json.Decode exposing (..)
import Ports


-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model [] 0, Cmd.none )



-- UPDATE


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



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.plugplay AddPlay
