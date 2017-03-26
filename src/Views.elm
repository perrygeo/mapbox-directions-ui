module Views exposing (mainView)

import Html exposing (Html, button, div, h1, h2, text, li, ul, ol, input, header, form, footer, a, p, img, span)
import Html.Attributes exposing (class, src, placeholder, type_, href, value, property)
import Html.Events exposing (onInput, onClick, onSubmit)
import Types exposing (Model, CarmenFeature, Msg(..))
import Json.Encode exposing (string)


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
    li [ class "destination shadow-darken10-on-hover round"]
    [ div [ class "grid" ]
        [ div [ class "col col--10 destination-name" ] [ text feature.placeName ]
        , div [ class "col col--2" ]
            [ div [ class "fr" ] 
                [ button [ class "btn--white color-gray btn btn--xs btn--pill btn--pill-hl", onClick (MoveDestination feature -1) ]
                         [ span [ property "innerHTML" (string "&uarr;") ] []]
                , button [ class "btn--white color-gray btn btn--xs btn--pill btn--pill-hc", onClick (MoveDestination feature 1) ]
                         [ span [ property "innerHTML" (string "&darr;") ] []]
                , button [ class "btn--white color-gray btn btn--xs btn--pill btn--pill-hr", onClick (DeleteDestination feature) ]
                         [ text "x" ]
                ]
            ]
        ]
    ]


destinationListView : Model -> Html Msg
destinationListView model =
    if List.length model.destinations > 0
       then div [ class "destinations-list" ]
            [ ol [] <| List.map destinationView model.destinations ]
       else div [ ] [ ]


waitingView : Model -> Html Msg
waitingView { waiting } =
    if waiting
       then div [ class "waiting loading" ] []
       else div [] []


searchBox : Model -> Html Msg
searchBox model =
    form [ class "search", onSubmit Geocode ]
    [ input [ type_ "search", class "input", placeholder "Search for a place", value model.name, onInput SetSearch ] []
    ]


logo : Html Msg
logo =
    div [ class "mb-logo mb-logo--white" ] []


mainView : Model -> Html Msg
mainView model =
    div []
    [ div [ class "right-bar" ]
        [ logo
        , h2 [ class "txt-h3" ] [ text "Trip Routing Demo" ]
        , destinationListView model
        , searchBox model
        , resultsListView model
        , waitingView model
        ]
    ]
