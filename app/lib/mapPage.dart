import 'dart:math';

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
          Set<Marker> markers = new Set<Marker>();

          try {
            QuerySnapshot snapshot = s.data;
            List documents = snapshot.documents;

            for (int _i = 0; _i < documents.length; _i++)
              try {
                markers.add(
                  new Marker(
                    markerId: MarkerId(documents[_i]['address']?? Random().nextDouble().toString()),
                    position: LatLng(
                      documents[_i]['lat'].toDouble(),
                      documents[_i]['long'].toDouble(),
                    ),
                  ),
                );
              } catch (e) {}
          } catch (e) {}

          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: PlatformMap(
              initialCameraPosition: CameraPosition(
                target: const LatLng(34.0195, -118.4912),
                zoom: 12.0,
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
                          bearing: 40.0,
                          target: LatLng(34.0195, -118.4912),
                          tilt: 30.0,
                          zoom: 13.0,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
