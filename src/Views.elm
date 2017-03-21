module Views exposing (mainView)

import Html exposing (Html, button, div, h1, h2, text, li, ul, ol, input, header, form, footer, a, p)
import Html.Attributes exposing (class, placeholder, type_, href)
import Html.Events exposing (onInput, onClick, onSubmit)
import Types exposing (Model, CarmenFeature, Msg(..))


-- Views

resultView : CarmenFeature -> Html Msg
resultView feature =
    li [] [ a [ href "#", onClick (AddDestination feature) ] [ text feature.placeName ] ]

resultsListView : Model -> Html Msg
resultsListView model =
    if List.length model.results > 0
       then div [ class "results-list" ]
            [ ul [] <| List.map resultView model.results ]
       else div [] []

destinationView : CarmenFeature -> Html Msg
destinationView feature =
    -- todo remove desitnation
    li [] [ p [ ] [ text feature.placeName ] ]


directionsButton : Model -> Html Msg
directionsButton { destinations } =
    if List.length destinations > 1
       then button [ ] [ text "Get Directions" ]
       else div [] []


destinationListView : Model -> Html Msg
destinationListView model =
    if List.length model.destinations > 0
       then div [ class "destinations-list" ]
            [ h2 [] [ text "Destinations" ]
            , ol [] <| List.map destinationView model.destinations
            , directionsButton model
            ]
       else div [ ] [ ]
       

waitingView : Model -> Html Msg
waitingView { waiting } =
    if waiting
       then div [ class "waiting" ] [ text "Waiting..." ]
       else div [] []


-- -- see https://github.com/elm-lang/html/issues/23#issuecomment-229192643
-- onChange : (String -> msg) -> Html.Attribute msg
-- onChange handler =
--   Html.Events.on "change" <| Decode.map handler <| Decode.at ["target", "value"] Decode.string

searchBox : Model -> Html Msg
searchBox model =
    form [ class "search", onSubmit Geocode ]
    [ input [ type_ "search", class "input", placeholder "Search for a place", onInput SetSearch ] []
    -- , input [ type_ "submit" ] [ text "Search" ]
    ]

-- bboxView : Model -> Html Msg
-- bboxView { bbox } =
--     div [] [ text <| toString bbox ]

-- headerView : Html Msg
-- headerView =
--     header [ ]
--     [ h1 [ ] [ text ("Elm talking to the Mapbox Geocoding API") ]
--     ]

-- footerView : Html Msg
-- footerView =
--     footer [ ]
--     [ div [] [ text ("Copyright 2017 Matthew Perry, @perrygeo") ] ]

mainView : Model -> Html Msg
mainView model =
    div []
    [ div [ class "right-bar" ]
        [ searchBox model
        , resultsListView model
        , destinationListView model
        , waitingView model
        ]
    ]
