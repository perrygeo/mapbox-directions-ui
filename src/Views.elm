module Views exposing (mainView)

import Html exposing (Html, button, div, h1, h3, text, li, ul, ol, input, header, form, footer, a, p, img)
import Html.Attributes exposing (class, src, placeholder, type_, href, value)
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
    li [] [ p [ class "destination" ] [ text feature.placeName ] ]


-- directionsButton : Model -> Html Msg
-- directionsButton { destinations } =
--     if List.length destinations > 1
--        then button [ onClick Directions ] [ text "Get Directions" ]
--        else div [] []


destinationListView : Model -> Html Msg
destinationListView model =
    if List.length model.destinations > 0
       then div [ class "destinations-list" ]
            [ ol [] <| List.map destinationView model.destinations ]
       else div [ ] [ ]
       

waitingView : Model -> Html Msg
waitingView { waiting } =
    if waiting
       then div [ class "waiting" ] [ img [ src "loading.gif" ] [] ]
       else div [] []


-- -- see https://github.com/elm-lang/html/issues/23#issuecomment-229192643
-- onChange : (String -> msg) -> Html.Attribute msg
-- onChange handler =
--   Html.Events.on "change" <| Decode.map handler <| Decode.at ["target", "value"] Decode.string

searchBox : Model -> Html Msg
searchBox model =
    form [ class "search", onSubmit Geocode ]
    [ input [ type_ "search", class "input", placeholder "Search for a place", value model.name, onInput SetSearch ] []
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
        [ h3 [] [ text "Destinations" ]
        , destinationListView model
        , searchBox model
        , resultsListView model
        , waitingView model
        ]
    ]
