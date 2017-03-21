port module MapboxGl exposing (..)

-- to javascript
-- app.ports.featureToMap.subscribe(callback)
-- port featuresToMap : (List CarmenFeature) -> Cmd msg
port featuresToMap : String -> Cmd msg
port clearFeatures : String -> Cmd msg


-- back to Elm
-- in the callback,
-- app.ports.toElm.send("String")
port toElm : (String -> msg) -> Sub msg
