module MapboxApi exposing (getGeocodingResults, getDirectionsResults)

import Types exposing (CarmenFeature, RouteFeature, Msg(..))
import Http
import Json.Decode as Decode
import GeoJson


-- Geocoding


getGeocodingResults : String -> String -> Cmd Msg
getGeocodingResults query token =
    let
        url =
            "https://api.mapbox.com/geocoding/v5/mapbox.places/" ++ query ++ ".json?limit=5&access_token=" ++ token

        request =
            Http.get url decodeGeocoding
    in
        Http.send GeocodingResult request


decodeGeocoding : Decode.Decoder (List CarmenFeature)
decodeGeocoding =
    Decode.at [ "features" ] (Decode.list placeDecoder)


placeDecoder : Decode.Decoder CarmenFeature
placeDecoder =
    Decode.map5 CarmenFeature
        (Decode.field "id" Decode.string)
        (Decode.field "place_name" Decode.string)
        (Decode.field "relevance" Decode.float)
        (Decode.field "center" (Decode.index 0 Decode.float))
        (Decode.field "center" (Decode.index 1 Decode.float))



-- Directions


getDirectionsResults : String -> String -> Cmd Msg
getDirectionsResults coordinates token =
    let
        url =
            "https://api.mapbox.com/directions/v5/mapbox/driving/"
                ++ coordinates
                ++ "?access_token="
                ++ token
                ++ "&overview=full"
                ++ "&geometries=geojson"

        request =
            Http.get url decodeDirections
    in
        Http.send DirectionsResult request


routeDecoder : Decode.Decoder RouteFeature
routeDecoder =
    Decode.at [ "geometry" ] (GeoJson.decoder)


decodeDirections : Decode.Decoder (List RouteFeature)
decodeDirections =
    Decode.at [ "routes" ] (Decode.list routeDecoder)
