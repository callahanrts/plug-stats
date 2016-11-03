module State exposing (..)

import Types exposing (..)
import Stats.State as Stats
import Stats.Types as Stats
import Debug
import Ports


init : ( Model, Cmd Msg )
init =
    let
        ( statsModel, statCmd ) =
            Stats.init
    in
        ( { statsModel = statsModel
          }
        , Cmd.map StatsMsg statCmd
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StatsMsg a ->
            let
                ( newStatsModel, newStatsCmd ) =
                    Stats.update a model.statsModel
            in
                ( { model | statsModel = newStatsModel }
                , Cmd.map StatsMsg newStatsCmd
                )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Stats.subscriptions model.statsModel
            |> Sub.map StatsMsg
        ]
