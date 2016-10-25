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
            [ metricTab Stats.Woot
            , metricTab Stats.Meh
            , metricTab Stats.Grab
            ]
        , div [] [ text (toString model.metric) ]
        , statsView model
        ]


metricTab : Stats.Metric -> Html Msg
metricTab metric =
    Html.map StatsMsg <|
        case metric of
            Stats.Woot ->
                div [ onClick (Stats.Sort Stats.Woot), class "woot" ] [ text "Woot" ]

            Stats.Meh ->
                div [ onClick (Stats.Sort Stats.Meh), class "meh" ] [ text "Meh" ]

            Stats.Grab ->
                div [ onClick (Stats.Sort Stats.Grab), class "grab" ] [ text "Grab" ]


statsView : Model -> Html Msg
statsView model =
    div []
        [ Html.map StatsMsg <|
            Stats.root model.statsModel
        ]
