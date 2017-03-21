module Main exposing (main)

import Html exposing (Html)

import MapboxApi
import MapboxGl
import Types exposing (CarmenFeature, Model, Msg(..))
import Updates exposing (update)
import Views exposing (mainView)


initialState : ( Model , Cmd Msg )
initialState = ( Model "Zanzibar" [] 0 False , Cmd.none)


main : Program Never Model Msg
main =
    Html.program
        { init = initialState
        , update = update
        , subscriptions = always Sub.none
        , view = mainView
        }
