const functions = require("firebase-functions");
const admin = require("firebase-admin");
const superagent = require("superagent");

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

    let reverseGeoencodingData = await superagent.get(
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=" +
        latitude +
        "," +
        longitude +
        "&key=AIzaSyDD-7OiQsQ_Ti0OIRbcjl8tI56OmR3xrMc"
    );

    let reverseGeocodingResults = JSON.parse(reverseGeoencodingData.text)
      .results[0];
    let address = reverseGeocodingResults.formatted_address;
    let types = reverseGeocodingResults.types;

    let place_id = reverseGeocodingResults.place_id;
    let placeData = await superagent.get(
      "https://maps.googleapis.com/maps/api/place/details/json?placeid=" +
        place_id +
        "&key=AIzaSyDD-7OiQsQ_Ti0OIRbcjl8tI56OmR3xrMc"
    );

    let placeDataResults = JSON.parse(placeData.text).result;
    let name = placeDataResults.name;
    //let business_status = placeDataResults.business_status;
    // let openNow = placeDataResults.opening_hours.open_now;

    return snapshot.ref.update({
      results: {},
      address: address,
      types: types,
      placeResults: {},
      name: name,
     // business_status: business_status,
      //openNow: openNow,
    });

    //AIzaSyDD-7OiQsQ_Ti0OIRbcjl8tI56OmR3xrMc
  });

exports.getAllCleanups = functions.https.onRequest(async (req, res) => {
  res.set('Access-Control-Allow-Origin', "*");
  res.set('Access-Control-Allow-Methods', 'GET, POST');
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
