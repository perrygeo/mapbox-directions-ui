### Mapbox Directions UI

A MapboxGLJS and Elm interface to Mapbox geocoding, directions and trip optimization APIs

<img src="./docs/img/screenshot1.jpg?raw=true" width="50%">

```
# edit elm-package.json
elm package install
make
```

#### TODO

- mapbox css, typography, layout and cartography
- drag and drop destinations
- delete destination
- make destinations round-trippable
- optimize trip (shuffles order)
- content
    - About panel
    - Options panel
    - Help panel (initial view)
- handle no geocoding results, no directions, errors
- mouseover markers
    - onMouseOver results, set model.hoverIndex, send a HoverResult port message to map
    - in js, onMouseOver feature, send a HoverPoint port message back to Elm
- URL Routing, destinations in url
- structured CSS with elm-css
- autocomplete geocoding box with UI typeahead
- limit search to bbox, proximity, other geocoding settings
