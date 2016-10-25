module Types exposing (..)

import Stats.Types as Stats


type Msg
    = Sort Stats.Metric
    | StatsMsg Stats.Msg


type alias Model =
    { metric : Stats.Metric
    , statsModel : Stats.Model
    }
