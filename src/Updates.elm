module Updates exposing (update)

import MapboxGl
import MapboxApi
import Types exposing (CarmenFeature, RouteFeature, routeFeatureObject,
                       carmenFeatureObject, Model, Msg(..))
import Secrets exposing (token)
-- import Cons exposing (cons, imum, Cons)


-- Updates

maximum : List comparable -> Maybe comparable
maximum l =
  case l of
    [] -> Nothing
    first::rest -> Just <| List.foldl max first rest

minimum : List comparable -> Maybe comparable
minimum l =
  case l of
    [] -> Nothing
    first::rest -> Just <| List.foldl min first rest


calcBounds : (List CarmenFeature) -> (Maybe Float, Maybe Float, Maybe Float, Maybe Float)
calcBounds features =
    let
        lngs = List.map (\f -> f.lng) features
        lats = List.map (\f -> f.lat) features
    in
       ((minimum lngs), (minimum lats), (maximum lngs), (maximum lats))


encodeCoords : (List CarmenFeature) -> String
encodeCoords features =
    let
        pairStrings =
            List.map (\f -> (toString f.lng) ++ "," ++ (toString f.lat)) features
    in
       String.join ";" pairStrings


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetSearch newname ->
        ( { model | name = newname, results = [] }
        , MapboxGl.resultsToMap []
        )

    AddDestination feature ->
        let
            newDestinations = feature :: model.destinations
            bbox = calcBounds newDestinations
        in
            ( { model | destinations = newDestinations }
            , MapboxGl.destinationsToMap <| List.map carmenFeatureObject newDestinations
            )

    Geocode ->
        ( { model | results = [], waiting = True }
        , MapboxApi.getGeocodingResults model.name token
        )

    GeocodingResult (Ok results) ->
        let
            bbox = calcBounds results
        in
            ( { model | results = results, waiting = False, bbox = bbox }
            , Cmd.batch
                [ MapboxGl.resultsToMap <| List.map carmenFeatureObject results
                , MapboxGl.setBbox bbox
                ]
            )

    GeocodingResult (Err error) ->
        ( { model | results = [], waiting = False }
        , Cmd.none
        )

    Directions ->
        ( { model | waiting = True }
        , MapboxApi.getDirectionsResults (encodeCoords model.destinations) token
        )

    DirectionsResult (Ok routes) ->
        let
            bbox = calcBounds model.destinations
        in
            ( { model | route = routes, waiting = False, bbox = bbox }
            , Cmd.batch
                [ MapboxGl.routesToMap <| List.map routeFeatureObject routes
                , MapboxGl.setBbox bbox
                ]
            )

    DirectionsResult (Err error) ->
        ( { model | results = [], waiting = False }
        , Cmd.none
        )

