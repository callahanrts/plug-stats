module Stats.Rest exposing (..)

import Stats.Types exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


userDecoder : Decoder User
userDecoder =
    decode User
        |> required "id" int
        |> required "username" string


mediaDecoder : Decoder Media
mediaDecoder =
    decode Media
        |> required "author" string
        |> required "cid" string
        |> required "duration" int
        |> required "format" int
        |> required "id" string
        |> required "image" string
        |> required "title" string


scoreDecoder : Decoder Score
scoreDecoder =
    decode Score
        |> required "positive" int
        |> required "negative" int
        |> required "grabs" int
        |> required "listeners" int


playDecoder : Decoder Play
playDecoder =
    decode Play
        |> required "score" scoreDecoder
        |> required "user" userDecoder
        |> required "media" mediaDecoder
