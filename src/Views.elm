module Views exposing (mainView)

import Html exposing (Html, button, div, h1, text, li, ol, input, header, form, footer, a)
import Html.Attributes exposing (class, placeholder, type_, href)
import Html.Events exposing (onInput, onClick, onSubmit)
import Types exposing (Model, CarmenFeature, Msg(..))


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
