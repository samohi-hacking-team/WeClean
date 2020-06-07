import { GoogleMapsOverlay } from "@deck.gl/google-maps";
import { HexagonLayer } from "@deck.gl/aggregation-layers";
import { ScatterplotLayer } from "@deck.gl/layers";
import { HeatmapLayer } from "@deck.gl/aggregation-layers";

let getData = async () => {
  const response = await fetch(
    "https://us-central1-weclean-4af67.cloudfunctions.net/getAllCleanups"
  );
  console.log();
  return response;
};
const scatterplot = (data) =>
  new ScatterplotLayer({
    id: "scatter",
    data: data,
    opacity: 0.8,
    filled: true,
    radiusMinPixels: 2,
    radiusMaxPixels: 5,
    getPosition: (d) => [d.long, d.lat],
    getFillColor: (d) => [255, 255, 0, 0],
  });

const heatmap = (data) =>
  new HeatmapLayer({
    id: "heat",
    data: data,
    getPosition: (d) => [d.long, d.lat],
    getWeight: (d) => 1,
    radiusPixels: 60,
  });

const hexagon = (data) =>
  new HexagonLayer({
    id: "hex",
    data: data,
    getPosition: (d) => {
      console.log(d);
      return [d.long, d.lat];
    },
    getElevationWeight: (d) => 1,
    elevationScale: 100,
    extruded: true,
    radius: 1609,
    opacity: 0.6,
    coverage: 0.88,
    lowerPercentile: 50,
  });

window.initMap = async () => {
  const map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: 34.017980, lng: -118.476210},
    zoom: 14,
  });

  let data = await getData();
  console.log(
    data.json().then((data) => {
      const overlay = new GoogleMapsOverlay({
        layers: [
          //scatterplot(data),
          heatmap(data),
          hexagon(data)
        ],
      });

      overlay.setMap(map);
    })
  );
};
