module Types exposing (CarmenFeature, carmenFeatureObject, Model, Msg(..))

import Http
import Json.Encode exposing (encode, Value, list, float, string, object)


type alias CarmenFeature =
    { placeName : String
    , relevance : Float
    , lng : Float
    , lat : Float
    }


-- type alias RouteFeature =
--     { geometry : 
--     }


type alias Model =
    { name : String
    , results : List CarmenFeature
    , activeResult : Int
    , bbox : (Maybe Float, Maybe Float, Maybe Float, Maybe Float)
    , waiting : Bool
    , destinations : List CarmenFeature
    }


type Msg
    = Geocode
    | GeocodingResult (Result Http.Error (List CarmenFeature))

    -- | Directions
    -- | DirectionsResult (Result Http.Error (List RouteFeature))

    | AddDestination CarmenFeature
    | SetSearch String


carmenFeatureObject : CarmenFeature -> Value
carmenFeatureObject feature =
    object
    [ ("type", string "Feature")
    , ("properties", object
        [ ("place_name", string feature.placeName) ])
    , ("geometry", object
        [ ("type", string "Point")
        , ("coordinates", list [(float feature.lng), (float feature.lat)])
        ])
    ]

