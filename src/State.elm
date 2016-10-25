module State exposing (..)

import Types exposing (..)
import Stats.State as Stats
import Stats.Types as Stats
import Ports
import Debug


init : ( Model, Cmd Msg )
init =
    let
        ( statsModel, statCmd ) =
            Stats.init
    in
        ( { metric = Stats.Woot
          , statsModel = statsModel
          }
        , Cmd.map StatsMsg statCmd
        )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Sort metric ->
            ( { model | metric = metric }, Cmd.none )

        StatsMsg a ->
            let
                ( newStatsModel, newStatsCmd ) =
                    Stats.update a model.statsModel
            in
                ( { model | statsModel = newStatsModel }
                , Cmd.none
                )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Stats.subscriptions model.statsModel
            |> Sub.map StatsMsg
        ]
