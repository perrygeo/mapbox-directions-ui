module Main exposing (main)

import Html exposing (Html)

import Types exposing (CarmenFeature, RouteFeature, Model, Msg(..))
import Updates exposing (update)
import Views exposing (mainView)
-- import Subscriptions exposing (subscriptions)


initDestinations : List CarmenFeature
initDestinations = 
    [ { id = "place.10434322992221180", placeName = "Loveland, Colorado, United States", relevance = 0.99, lng = -105.075, lat = 40.3978 }
    , { id = "poi.2100592167562630", placeName = "Arapahoe Community College, 5900 S Santa Fe Dr, Littleton, Colorado 80120, United States", relevance = 0.99, lng = -105.02, lat = 39.6084 }
    , { id = "poi.13764848241819650", placeName = "Greeley Union Pacific Railroad Depot, Greeley, Colorado 80631, United States", relevance = 0.99, lng = -104.688056, lat = 40.424167 }
    ]

initialState : ( Model , Cmd Msg )
initialState = 
    ( { name = ""
      , results = []
      , activeResult = 0
      , bbox = (Nothing, Nothing, Nothing, Nothing)
      , waiting = False
      , destinations = initDestinations
      , route = []
      }
    , Cmd.none
    )

main : Program Never Model Msg
main =
    Html.program
        { init = initialState
        , update = update
        , subscriptions = always Sub.none
        , view = mainView
        }
