module Updates exposing (update, updateDestinations)

import MapboxGl
import MapboxApi
import Types exposing (CarmenFeature, RouteFeature, routeFeatureObject,
                       carmenFeatureObject, Model, Msg(..))
import Secrets exposing (token)
import List.Extra


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


updateDestinations : Model -> (List CarmenFeature) -> (Model, Cmd Msg)
updateDestinations model newDestinations =
    let
        runSearch = List.length newDestinations > 1
        bbox = calcBounds newDestinations
        cmds = [ MapboxGl.destinationsToMap <| List.map carmenFeatureObject newDestinations
               , MapboxGl.setBbox bbox
               , if runSearch
                    then MapboxApi.getDirectionsResults (encodeCoords newDestinations) token
                    else MapboxGl.routesToMap <| List.map routeFeatureObject []  -- clear route
               ]
    in
        ( { model | name = "", results = [], destinations = newDestinations, waiting = runSearch }
        , Cmd.batch cmds
        )


moveItem : a -> Int -> List a -> List a
moveItem item relPos data =
   let
       pos = List.Extra.elemIndex item data
       pre = case pos of
           Just x ->
               List.take x data
           Nothing ->
               []
       post = case pos of
           Just x ->
               List.drop (x + 1) data
           Nothing ->
               []
       partA =
           List.append
           (List.take ((List.length pre) + relPos) pre)
           (List.take relPos post)

       partC =
           List.append
           (List.drop ((List.length pre) + relPos) pre)
           (List.drop relPos post)

   in
      List.append
      (List.append partA (List.singleton item))
      partC


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
        in
            updateDestinations model newDestinations

    DeleteDestination feature -> 
        let
            newDestinations = List.filterMap (\f -> if f == feature then Nothing else Just f ) model.destinations 
        in
            updateDestinations model newDestinations

    MoveDestination feature spaces ->
        let
            newDestinations = moveItem feature spaces model.destinations
        in
            updateDestinations model newDestinations
            
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
