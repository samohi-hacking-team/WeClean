import { GoogleMapsOverlay } from '@deck.gl/google-maps';
import { HexagonLayer } from '@deck.gl/aggregation-layers';
import { ScatterplotLayer } from '@deck.gl/layers';
import { HeatmapLayer } from '@deck.gl/aggregation-layers';

const url = 'https://us-central1-weclean-4af67.cloudfunctions.net/getAllCleanups';
// const url = './getAllCleanups.json'

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

window.initMap = () => {

    const map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: 40.0, lng: -100.0},
        zoom: 5,
    });
    
    const overlay = new GoogleMapsOverlay({
        layers: [
            scatterplot(),
            heatmap(),
        ],
    });

    
    overlay.setMap(map);

}