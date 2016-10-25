module Types exposing (..)

import Stats.Types as Stats


type Msg
    = StatsMsg Stats.Msg


type alias Model =
    { statsModel : Stats.Model
    }
