const functions = require("firebase-functions");
const admin = require("firebase-admin");
const fetch = require("node-fetch");

admin.initializeApp();
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.latLongToAddress = functions.firestore
  .document("cleanups/{cleanup}")
  .onCreate(async (snapshot, context) => {
    let data = snapshot.data();
    
    let latitude = data.lat;
    let longitude = data.long;

    let reverseGeoencodingData = await fetch(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=" +
        latitude +
        "," +
        longitude +
        "&key=AIzaSyDD-7OiQsQ_Ti0OIRbcjl8tI56OmR3xrMc"
    );
    let reverseGeocodingResults = reverseGeoencodingData.results;
    let address = reverseGeocodingResults.formatted_address;
    let types = reverseGeocodingResults.types;

    let place_id = reverseGeocodingResults.place_id;
    let placeData = await fetch(
      "https://maps.googleapis.com/maps/api/place/details/json?placeid=" +
        place_id +
        "&key=AIzaSyDD-7OiQsQ_Ti0OIRbcjl8tI56OmR3xrMc"
    );

    let placeDataResults = placeData.result;
    let name = placeDataResults.name;
    let openNow = placeDataResults.opening_hours.open_now;

    return snapshot.ref.update({
      address: address,
      types: types,
      name: name,
      openNow: openNow,
    });

    //AIzaSyDD-7OiQsQ_Ti0OIRbcjl8tI56OmR3xrMc
  });

exports.getAllCleanups = functions.https.onRequest(async (req, res) => {
  let documents = await admin
    .firestore()
    .collection("cleanups")
    .listDocuments();


  const promises = documents.map(async (value) => {
   return (await value.get()).data();
  });

  const docs = await Promise.all(promises);
  

  return res.status(200).send(docs);
});
