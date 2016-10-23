module Types exposing (..)

import Stats.Types as Stats


type Metric
    = Woot
    | Meh
    | Grab


type Msg
    = Sort Metric
    | StatsMsg Stats.Msg


type alias Model =
    { metric : Metric
    , statsModel : Stats.Model
    }
