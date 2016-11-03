port module Ports exposing (..)


port plugplay : (String -> msg) -> Sub msg


port setvolume : Int -> Cmd msg
