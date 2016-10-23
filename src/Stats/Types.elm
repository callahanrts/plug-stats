module Stats.Types exposing (..)


type alias User =
    { id : Int
    , username : String
    }


type alias Media =
    { author : String
    , cid : String
    , duration : Int
    , format : Int
    , id : String
    , image : String
    , title : String
    }


type alias Score =
    { positive : Int
    , negative : Int
    , grabs : Int
    , listeners : Int
    }


type alias Play =
    { score : Score
    , user : User
    , media : Media
    }


type alias Model =
    { plays : List Play
    , total : Int
    }


type Msg
    = AddPlay String
