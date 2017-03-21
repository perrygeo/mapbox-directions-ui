module MapboxApi exposing (getGeocodingResults)

import Types exposing (CarmenFeature, Msg(..))
import Http
import Json.Decode as Decode


getGeocodingResults : String -> String -> Cmd Msg
getGeocodingResults query token =
  let
    url =
      "https://api.mapbox.com/geocoding/v5/mapbox.places/" ++ query ++ ".json?access_token=" ++ token

    request =
      Http.get url decodeGeocodingUrl
  in
    Http.send GeocodingResult request


decodeGeocodingUrl : Decode.Decoder (List CarmenFeature)
decodeGeocodingUrl =
    Decode.at ["features"] (Decode.list placeDecoder)


placeDecoder : Decode.Decoder CarmenFeature
placeDecoder =
    Decode.map4 CarmenFeature
        (Decode.field "place_name" Decode.string)
        (Decode.field "relevance" Decode.float)
        (Decode.field "center" (Decode.index 0 Decode.float))
        (Decode.field "center" (Decode.index 1 Decode.float))
