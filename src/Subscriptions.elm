module Subscriptions exposing (subscriptions)

import Types exposing (Model, Msg(..))
import MapboxGl exposing (toElm)


subscriptions : Model -> Sub Msg
subscriptions model =
    toElm NewBbox
