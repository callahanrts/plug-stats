module View exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Stats.Types as Stats
import Stats.View as Stats
import String


root : Model -> Html Msg
root model =
    div [ class "plug-stats" ]
        [ div [ class "metrics" ]
            [ metricTab Stats.Woot model.statsModel.metric
            , metricTab Stats.Meh model.statsModel.metric
            , metricTab Stats.Grab model.statsModel.metric
            ]
        , statsView model
        ]


metricTab : Stats.Metric -> Stats.Metric -> Html Msg
metricTab metric current =
    let
        active =
            metric == current
    in
        case metric of
            Stats.Woot ->
                tabMarkup Stats.Woot active

            Stats.Meh ->
                tabMarkup Stats.Meh active

            Stats.Grab ->
                tabMarkup Stats.Grab active


tabMarkup : Stats.Metric -> Bool -> Html Msg
tabMarkup metric active =
    Html.map StatsMsg <|
        let
            metricStr =
                toString metric

            metricClass =
                String.toLower metricStr
        in
            div [ onClick (Stats.Sort metric), class ((activeClass active) ++ " " ++ metricClass) ]
                [ div [ class ("icon icon-" ++ metricClass) ] []
                , span [] [ text metricStr ]
                ]


activeClass : Bool -> String
activeClass active =
    if active then
        "active"
    else
        ""


statsView : Model -> Html Msg
statsView model =
    Html.map StatsMsg <|
        Stats.root model.statsModel
