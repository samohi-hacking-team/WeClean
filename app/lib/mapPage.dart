import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firestore.instance.collection('cleanups').getDocuments(),
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          QuerySnapshot snapshot = s.data;
          List documents = snapshot.documents;

          Set<Marker> markers = new Set<Marker>();
          for (int _i = 0; _i < documents.length; _i++)
            markers.add(
              new Marker(
                markerId: MarkerId(documents[_i]['address']),
                position: LatLng(
                  documents[_i]['lat'].toDouble(),
                  documents[_i]['long'].toDouble(),
                ),
              ),
            );

          return PlatformMap(
            initialCameraPosition: CameraPosition(
              target: const LatLng(34.0522, -118.2437),
              zoom: 16.0,
            ),
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (location) => print('onTap: $location'),
            onCameraMove: (cameraUpdate) =>
                print('onCameraMove: $cameraUpdate'),
            compassEnabled: true,
            onMapCreated: (controller) {
              Future.delayed(Duration(seconds: 2)).then(
                (_) {
                  controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                      const CameraPosition(
                        bearing: 270.0,
                        target: LatLng(51.5160895, -0.1294527),
                        tilt: 30.0,
                        zoom: 18,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
