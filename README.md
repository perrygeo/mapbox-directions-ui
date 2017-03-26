### Mapbox Directions UI

A MapboxGLJS and Elm interface to Mapbox geocoding, directions and trip optimization APIs

<img src="./docs/img/screenshot1.jpg?raw=true" width="50%">

```
# edit elm-package.json
elm package install
make
```

#### TODO

- drag and drop destinations
- autocomplete geocoding box making full use of UI typeahead
- make destinations round-trippable (auto-add last)
- optimize trip (shuffles order)
- content
    - About panel
    - Options panel
        - limit search to bbox, proximity, other geocoding settings
    - Help panel (initial view)
- handle no geocoding results, no directions, errors
- mouseover markers
    - onMouseOver results, set model.hoverIndex, send a HoverResult port message to map
    - in js, onMouseOver feature, send a HoverPoint port message back to Elm
- URL Routing, destinations in url
- GeoJSON upload, download
- structured CSS with elm-css
