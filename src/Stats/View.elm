module Stats.View exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Stats.Types exposing (..)


root : Model -> Html Msg
root model =
    div [ class "stats-list" ]
        [ ol [] (List.map showPlay model.plays)
        , div [] [ text (toString model.total) ]
        ]


showPlay : Play -> Html Msg
showPlay play =
    li []
        [ div [ class "title" ] [ text play.media.title ]
        , div [ class "author" ] [ text play.media.author ]
        , (playStat play)
        ]


playStat : Play -> Html Msg
playStat play =
    div []
        [ plugIcon "woot"
        , div [] [ text (playMetric play.score.positive play.score.listeners) ]
        , plugIcon "meh"
        , div [] [ text (playMetric play.score.negative play.score.listeners) ]
        , plugIcon "grab"
        , div [] [ text (playMetric play.score.grabs play.score.listeners) ]
        ]


plugIcon : String -> Html Msg
plugIcon icon =
    div [ class ("icon icon-" ++ icon) ] []


playMetric : Int -> Int -> String
playMetric num total =
    toString num
