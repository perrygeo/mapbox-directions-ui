
// ---------------------------------------------------------------------------//
// Write callbacks for incoming Elm Ports
// ---------------------------------------------------------------------------//
app.ports.setBbox.subscribe(function(bbox) {
    var sw = new mapboxgl.LngLat(bbox[0], bbox[1]);
    var ne = new mapboxgl.LngLat(bbox[2], bbox[3]);
    var bounds = new mapboxgl.LngLatBounds(sw, ne);
    map.fitBounds(bounds, { padding: 80 });
});

app.ports.destinationsToMap.subscribe(function(features) {
    var newData = {
        "type": "FeatureCollection",
        "features": features
    };
    map.getSource('destinations').setData(newData);
});

app.ports.routesToMap.subscribe(function(features) {
    var newData = {
        "type": "FeatureCollection",
        "features": features
    };
    map.getSource('routes').setData(newData);
});


// ---------------------------------------------------------------------------//
// TODO send data (bbox?) back to Elm
// app.ports.toElm.send("heyo");
// ---------------------------------------------------------------------------//


// ---------------------------------------------------------------------------//
// Set up MapboxGLJS map element
// ---------------------------------------------------------------------------//
mapboxgl.accessToken = 'pk.eyJ1IjoicGVycnlnZW8iLCJhIjoiNjJlNTZmNTNjZTFkZTE2NDUxMjg2ZDg2ZDdjMzI5NTEifQ.-f-A9HuHrPZ7fHhlZxYLHQ';

var map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v9',
    center: [0, 0],
    maxZoom: 14,
    zoom: 1
});

map.on('load', function () {

    // Routes
    map.addLayer({
        "id": "routes",
        "type": "line",
        "layout": {
            "line-join": "round",
            "line-cap": "round"
        },
        "paint": {
            "line-color": "#273d56",
            "line-width": 2
        },
        "source": {
            "type": "geojson",
            "data": {
                "type": "FeatureCollection",
                "features": []
            }
        }
    });

    // Destinations
    map.addLayer({
       "id": "destinations",
       "type": "symbol",
       "layout": {
            "icon-image": "marker-15",
            "icon-allow-overlap": true
            // "text-field": "{shortName}",
            // "text-font": ["Open Sans Bold", "Arial Unicode MS Bold"],
            // "text-size": 10,
            // "text-letter-spacing": 0.05,
            // "text-offset": [0, 1.5]
       },
        "paint": {
            "icon-color": "#273d56",
            "text-color": "#273d56",
            "text-halo-color": "#fff",
            "text-halo-width": 2
       },
       "source": {
            "type": "geojson",
            "data": {
                "type": "FeatureCollection",
                "features": []
            }
       }
    });
});
