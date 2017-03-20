module Main exposing (main)

import Html exposing (Html, button, div, h1, text, li, ol, input, header, form, footer, a)
import Html.Attributes exposing (class, placeholder, type_, href)
import Html.Events exposing (onInput, onClick, onSubmit)
import Http
import Json.Decode as Decode


main : Program Never Model Msg
main =
    Html.program
        { init = initialState
        , update = update
        , subscriptions = always Sub.none  -- Sub.subscriptions
        , view = mainView
        }


-- Model

type alias CarmenFeature =
    { placeName : String
    , relevance : Float
    , position : List Float
    }

type alias Model =
    { name : String
    , results : List CarmenFeature
    , waiting : Bool
    }

token : String
token = "pk.eyJ1IjoicGVycnlnZW8iLCJhIjoiNjJlNTZmNTNjZTFkZTE2NDUxMjg2ZDg2ZDdjMzI5NTEifQ.-f-A9HuHrPZ7fHhlZxYLHQ"

initialState : ( Model , Cmd Msg )
initialState = ( Model "Zanzibar" [] False , Cmd.none)

-- Updates

type Msg
    = Geocode
    | SetSearch String
    | GeocodingResult (Result Http.Error (List CarmenFeature))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SetSearch newname ->
        ( { model | name = newname, results = [] }
        , Cmd.none
        )

    Geocode ->
        ( { model | results = [], waiting = True }
        , getGeocodingResults model.name token
        )

    GeocodingResult (Ok results) ->
        ( { model | results = results, waiting = False }
        , Cmd.none
        )

    GeocodingResult (Err error) ->
        ( { model | results = [], waiting = False }
        , Cmd.none
        )


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
    Decode.map3 CarmenFeature
        (Decode.field "place_name" Decode.string)
        (Decode.field "relevance" Decode.float)
        (Decode.field "center" (Decode.list Decode.float))

-- Views

resultView : CarmenFeature -> Html Msg
resultView { placeName, position }=
    li [] [ div [] [ text (placeName ++ " " ++ (toString position)) ] ]

resultsListView : Model -> Html Msg
resultsListView model =
    ol [] <| List.map resultView model.results


waitingView : Bool -> Html Msg
waitingView show =
    if show
       then div [ class "waiting" ] [ text "Waiting..." ]
       else div [] []


-- -- see https://github.com/elm-lang/html/issues/23#issuecomment-229192643
-- onChange : (String -> msg) -> Html.Attribute msg
-- onChange handler =
--   Html.Events.on "change" <| Decode.map handler <| Decode.at ["target", "value"] Decode.string

searchBox : Model -> Html Msg
searchBox model =
    form [ onSubmit Geocode ]
    [ input [ type_ "search", placeholder "Search for place", onInput SetSearch ] []
    , input [ type_ "submit" ] [ text "Search" ]
    ]

headerView : Html Msg
headerView =
    header [ ]
    [ h1 [ ] [ text ("Elm talking to the Mapbox Geocoding API") ]
    ]

footerView : Html Msg
footerView =
    footer [ ]
    [ div [] [ text ("Copyright 2017 Matthew Perry, @perrygeo") ] ]

mainView : Model -> Html Msg
mainView model =
    div []
    [ headerView
    , searchBox model
    , resultsListView model
    , waitingView model.waiting
    , footerView
    ]
