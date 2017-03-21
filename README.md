### Mapbox Directions UI

A MapboxGLJS and Elm interface to Mapbox geocoding, directions and trip optimization APIs

<img src="./master/docs/img/screenshot1.jpg?raw=true" width="50%">

```
# edit elm-package.json
elm package install
make
```

#### TODO

- About panel
- Options panel
- Help panel (initial view)
- handle no geocoding results
- waiting icon
- map destinations
- styling and typography
- onMouseOver results, set model.hoverIndex, send a HoverResult port message to map
- in js, onMouseOver feature, send a HoverPoint port message back to Elm
- URL Routes
- onClick result, append it to model.destinations
- view for model.destinations
- onClick the "Get Directions"
- structured CSS with elm-css
- limit search to bbox
- drag and drop directions
- directions (based on order) 
