import { GoogleMapsOverlay } from '@deck.gl/google-maps';
import { HexagonLayer } from '@deck.gl/aggregation-layers';
import { ScatterplotLayer } from '@deck.gl/layers';
import { HeatmapLayer } from '@deck.gl/aggregation-layers';

const url = 'https://us-central1-weclean-4af67.cloudfunctions.net/getAllCleanups';

const scatterplot = () => new ScatterplotLayer({
    id: 'scatter',
    data: url,
    opacity: 0.8,
    filled: true,
    radiusMinPixels: 2,
    radiusMaxPixels: 5,
    getPosition: d => [d.long, d.lat],
    getFillColor: d => [255, 255, 0, 0],
  });

  const heatmap = () => new HeatmapLayer({
    id: 'heat',
    data: url,
    getPosition: d => [d.long, d.lat],
    getWeight: d => 1,
    radiusPixels: 60,
});

const hexagon = () => new HexagonLayer({
    id: 'hex',
    data: url,
    getPosition: d => [d.long, d.lat],
    getElevationWeight: d => 1,
    elevationScale: 100,
    extruded: true,
    radius: 1609,         
    opacity: 0.6,        
    coverage: 0.88,
    lowerPercentile: 50
});

window.initMap = () => {

    const map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: 40.0, lng: -100.0},
        zoom: 5,
    });
    
    const overlay = new GoogleMapsOverlay({
        layers: [
            scatterplot(),
            heatmap(),
            hexagon()
        ],
    });

    
    overlay.setMap(map);

}