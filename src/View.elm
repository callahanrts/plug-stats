module View exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)
import Stats.Types as Stats
import Stats.View as Stats


root : Model -> Html Msg
root model =
    div [ class "plug-stats" ]
        [ div [ class "metrics" ]
            [ metricTab Woot
            , metricTab Meh
            , metricTab Grab
            ]
        , div [] [ text (toString model.metric) ]
        , statsView model
        ]


metricTab : Metric -> Html Msg
metricTab metric =
    case metric of
        Woot ->
            div [ onClick (Sort Woot), class "woot" ] [ text "Woot" ]

        Meh ->
            div [ onClick (Sort Meh), class "meh" ] [ text "Meh" ]

        Grab ->
            div [ onClick (Sort Grab), class "grab" ] [ text "Grab" ]


statsView : Model -> Html Msg
statsView model =
    div []
        [ Html.map StatsMsg <|
            Stats.root model.statsModel
        ]
