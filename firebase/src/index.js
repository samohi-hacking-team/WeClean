import { GoogleMapsOverlay } from "@deck.gl/google-maps";
import { HeatmapLayer } from "@deck.gl/aggregation-layers";

let getData = async () => {
  const response = await fetch(
    "https://us-central1-weclean-4af67.cloudfunctions.net/getAllCleanups"
  );
  console.log();
  return response;
};


const heatmap = (data) =>
  new HeatmapLayer({
    id: "heat",
    data: data,
    colorRange: [
      // BLUE
      // [239, 243, 255],
      // [198, 219, 239],
      // [158, 202, 225],
      // [107, 174, 214],
      // [49, 130, 189],
      // [8, 81, 156],
      //GREEN
    //   [237,248,251,140],
    //   [204,236,230,180],
    //   [153,216,201],
    //   [102,194,164],
    //   [44,162,95],
    //   [0,109,44, ],
      // PURPLE
        [237, 248, 251,170],
        [191, 211, 230],
        [158, 188, 218],
        [140, 150, 198],
        [136, 86, 167],
        [129, 15, 124],
      //BLUE 2 PURPLE
    //   [
        // [149, 216, 235,1],
        // [77, 180, 215,1],
        // [0, 118, 190,1],
        // [72, 191, 145,1],
        // [139, 217, 199,1],
        // [139, 217, 199,1],

    //   ],
    ],
    getPosition: (d) => [d.long, d.lat],
    getWeight: (d) => 1,
    radiusPixels: 100,
  });


window.initMap = async () => {
  const map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: 34.01798, lng: -118.47621 },
    zoom: 14,
    styles: [
        {elementType: 'geometry', stylers: [{color: '#242f3e'}]},
        {elementType: 'labels.text.stroke', stylers: [{color: '#242f3e'}]},
        {elementType: 'labels.text.fill', stylers: [{color: '#746855'}]},
        {
          featureType: 'administrative.locality',
          elementType: 'labels.text.fill',
          stylers: [{color: '#d59563'}]
        },
        {
          featureType: 'poi',
          elementType: 'labels.text.fill',
          stylers: [{color: '#d59563'}]
        },
        {
          featureType: 'poi.park',
          elementType: 'geometry',
          stylers: [{color: '#263c3f'}]
        },
        {
          featureType: 'poi.park',
          elementType: 'labels.text.fill',
          stylers: [{color: '#6b9a76'}]
        },
        {
          featureType: 'road',
          elementType: 'geometry',
          stylers: [{color: '#38414e'}]
        },
        {
          featureType: 'road',
          elementType: 'geometry.stroke',
          stylers: [{color: '#212a37'}]
        },
        {
          featureType: 'road',
          elementType: 'labels.text.fill',
          stylers: [{color: '#9ca5b3'}]
        },
        {
          featureType: 'road.highway',
          elementType: 'geometry',
          stylers: [{color: '#746855'}]
        },
        {
          featureType: 'road.highway',
          elementType: 'geometry.stroke',
          stylers: [{color: '#1f2835'}]
        },
        {
          featureType: 'road.highway',
          elementType: 'labels.text.fill',
          stylers: [{color: '#f3d19c'}]
        },
        {
          featureType: 'transit',
          elementType: 'geometry',
          stylers: [{color: '#2f3948'}]
        },
        {
          featureType: 'transit.station',
          elementType: 'labels.text.fill',
          stylers: [{color: '#d59563'}]
        },
        {
          featureType: 'water',
          elementType: 'geometry',
          stylers: [{color: '#17263c'}]
        },
        {
          featureType: 'water',
          elementType: 'labels.text.fill',
          stylers: [{color: '#515c6d'}]
        },
        {
          featureType: 'water',
          elementType: 'labels.text.stroke',
          stylers: [{color: '#17263c'}]
        }
      ]
  });

  let data = await getData();
  console.log(
    data.json().then((data) => {
      const overlay = new GoogleMapsOverlay({
        layers: [
          //scatterplot(data),
          heatmap(data),
          //hexagon(data)
        ],
      });

      overlay.setMap(map);
    })
  );
};
