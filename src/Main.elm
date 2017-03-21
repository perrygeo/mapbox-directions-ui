module Main exposing (main)

import Html exposing (Html)

import Types exposing (CarmenFeature, RouteFeature, Model, Msg(..))
import Updates exposing (update)
import Views exposing (mainView)
-- import Subscriptions exposing (subscriptions)




initialState : ( Model , Cmd Msg )
initialState = ( Model "Zanzibar" [] 0 (Nothing, Nothing, Nothing, Nothing) False [] [], Cmd.none)


main : Program Never Model Msg
main =
    Html.program
        { init = initialState
        , update = update
        , subscriptions = always Sub.none
        , view = mainView
        }
