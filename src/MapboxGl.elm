port module MapboxGl exposing (..)

import Json.Encode exposing (Value)

-- to javascript
-- app.ports.featureToMap.subscribe(callback)
port resultsToMap : (List Value) -> Cmd msg
port destinationsToMap : (List Value) -> Cmd msg
port routesToMap : (List Value) -> Cmd msg
port setBbox : (Maybe Float, Maybe Float, Maybe Float, Maybe Float) -> Cmd msg


-- back to Elm
-- in the callback,
-- app.ports.toElm.send("String")
port toElm : (String -> msg) -> Sub msg
