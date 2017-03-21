module Types exposing (CarmenFeature, Model, Msg(..))

import Http


type alias CarmenFeature =
    { placeName : String
    , relevance : Float
    , position : List Float
    }


type alias Model =
    { name : String
    , results : List CarmenFeature
    , activeResult : Int
    , waiting : Bool
    }


type Msg
    = Geocode
    | SetSearch String
    | GeocodingResult (Result Http.Error (List CarmenFeature))
