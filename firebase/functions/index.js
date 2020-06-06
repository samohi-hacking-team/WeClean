const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.latLongToAddress = functions.firestore
  .document("cleanups/")
  .onCreate(async (snapshot, context) => {
      let data = snapshot.data();
      let latitude = data.lat;
      let longitude = data.long;
      latitude = 34.0099;
      longitude = 118.4960;
      let reverseGeoencodingData = await fetch("https://maps.googleapis.com/maps/api/geocode/json?latlng="+latitude+","+longitude+"&key=AIzaSyDD-7OiQsQ_Ti0OIRbcjl8tI56OmR3xrMc");
      let results = data.results;
      let address = results.formatted_address;
      let types = results.types;

      let place_id = results.place_id;
      let placeData = await fetch("https://maps.googleapis.com/maps/api/place/details/json?placeid="+place_id+"&key=AIzaSyDD-7OiQsQ_Ti0OIRbcjl8tI56OmR3xrMc");

      return snapshot.ref.update({
          address: address,
          types: types,
      })
    

      //AIzaSyDD-7OiQsQ_Ti0OIRbcjl8tI56OmR3xrMc
  });
