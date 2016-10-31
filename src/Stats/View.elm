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
        , preview model
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
        [ div [ class "title", onClick (Preview play) ] [ text play.media.title ]
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


preview : Model -> Html Msg
preview model =
    let
        play =
            model.currentPlay
    in
        div [ id "preview", style [ ( "display", (previewDisplay model.previewPlay) ) ] ]
            [ embedCode model.currentPlay.media.cid
            , div [ class "close-preview", onClick ClosePreview ]
                [ div [] [ text "BACK" ]
                ]
            ]


previewDisplay : Bool -> String
previewDisplay show =
    if show then
        "block"
    else
        "none"


embedCode : String -> Html Msg
embedCode cid =
    case String.toInt cid of
        Ok val ->
            iframeElement (soundcloudPlayer cid)

        Err msg ->
            iframeElement (youtubePlayer cid)


soundcloudPlayer : String -> String
soundcloudPlayer cid =
    "https://w.soundcloud.com/player/"
        ++ "?url=https%3A//api.soundcloud.com/tracks/"
        ++ cid
        ++ "&amp;auto_play=true"
        ++ "&amp;hide_related=true"
        ++ "&amp;show_comments=false"
        ++ "&amp;show_user=false"
        ++ "&amp;show_reposts=false"
        ++ "&amp;visual=true"


youtubePlayer : String -> String
youtubePlayer cid =
    "https://www.youtube.com/embed/"
        ++ cid
        ++ "?autoplay=1"
        ++ "&rel=0"


iframeElement : String -> Html Msg
iframeElement source =
    div [ class "embed-container" ]
        [ iframe
            [ src source
            , attribute "frameborder" "0"
            ]
            []
        ]
