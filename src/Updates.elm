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
  case Debug.log "Update Message:" msg of
    SetSearch newname ->
        let
            runSearch = String.length newname > 3
            cmd = if runSearch
                     then MapboxApi.getGeocodingResults model.name token
                     else Cmd.none
        in
            ( { model | name = newname, results = [], waiting = runSearch }
            , cmd
            )

    AddDestination feature ->
        let
            newDestinations = List.append model.destinations (List.singleton feature)
            runSearch = List.length newDestinations > 1
            bbox = calcBounds newDestinations
            cmds = [ MapboxGl.destinationsToMap <| List.map carmenFeatureObject newDestinations
                   , MapboxGl.setBbox bbox
                   , if runSearch
                        then MapboxApi.getDirectionsResults (encodeCoords newDestinations) token
                        else Cmd.none
                   ]
        in
            ( { model | name = "", results = [], destinations = newDestinations, waiting = runSearch }
            , Cmd.batch cmds
            )

    DeleteDestination feature -> 
        let
            newDestinations = List.filterMap (\f -> if f == feature then Nothing else Just f ) model.destinations 
            runSearch = List.length newDestinations > 1
            bbox = calcBounds newDestinations
            cmds =
                 [ MapboxGl.destinationsToMap <| List.map carmenFeatureObject newDestinations
                 , MapboxGl.setBbox bbox
                 , if runSearch
                      then MapboxApi.getDirectionsResults (encodeCoords newDestinations) token
                      else MapboxGl.routesToMap <| List.map routeFeatureObject []  -- clear route
                 ]
        in
            ( { model | destinations = newDestinations, waiting = True }
            , Cmd.batch cmds
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
            , Cmd.none
            )

    GeocodingResult (Err error) ->
        ( { model | results = [], waiting = False }
        , Cmd.none
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

    -- MoveDestination spaces ->
    --     let
    --         newDestinations = { model.
