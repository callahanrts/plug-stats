module Stats.View exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Stats.Types exposing (..)
import String


root : Model -> Html Msg
root model =
    div [ class "stats-list" ]
        [ ol [] (List.map showPlay (orderBy model.metric model.plays))
        ]


orderBy : Metric -> List Play -> List Play
orderBy metric plays =
    case metric of
        Woot ->
            List.reverse (List.sortBy (\n -> n.score.positive) plays)

        Meh ->
            List.reverse (List.sortBy (\n -> n.score.negative) plays)

        Grab ->
            List.reverse (List.sortBy (\n -> n.score.grabs) plays)


showPlay : Play -> Html Msg
showPlay play =
    li []
        [ [ div [ class "title" ] [ text play.media.title ]
          ]
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



-- trackLink : Media -> String
-- trackLink media =
--     case String.toInt media.cid of
--         Ok val ->
--             "http://google.com"
--         Err msg ->
--             "http://youtube.com/watch?v=" ++ media.cid
