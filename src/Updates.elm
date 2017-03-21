module Updates exposing (update)

import MapboxGl
import MapboxApi
import Types exposing (CarmenFeature, Model, Msg(..))
import Secrets exposing (token)

-- Updates

updateMap: Model -> Cmd Msg
updateMap model =
    let
        _ = MapboxGl.clearFeatures ""
    in
        MapboxGl.featuresToMap (toString model.results)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetSearch newname ->
        ( { model | name = newname, results = [] }
        , Cmd.none
        )

    Geocode ->
        ( { model | results = [], waiting = True }
        , MapboxApi.getGeocodingResults model.name token
        )

    GeocodingResult (Ok results) ->
        ( { model | results = results, waiting = False }
        , updateMap model
        )

    GeocodingResult (Err error) ->
        ( { model | results = [], waiting = False }
        , Cmd.none
        )

