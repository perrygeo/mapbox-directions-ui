module Types exposing (CarmenFeature, carmenFeatureObject, Model, Msg(..))

import Http
import Json.Encode exposing (encode, Value, list, float, string, object)


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


carmenFeatureObject : CarmenFeature -> Value
carmenFeatureObject feature =
    object
    [ ("type", string "Feature")
    , ("properties", object
        [ ("place_name", string feature.placeName) ])
    , ("geometry", object
        [ ("type", string "Point")
        , ("coordinates", list (List.map float feature.position))
        ])
    ]

