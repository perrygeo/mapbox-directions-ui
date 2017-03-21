port module MapboxGl exposing (..)

import Json.Encode exposing (Value)

-- to javascript
-- app.ports.featureToMap.subscribe(callback)
port featuresToMap : (List Value) -> Cmd msg


-- back to Elm
-- in the callback,
-- app.ports.toElm.send("String")
port toElm : (String -> msg) -> Sub msg
