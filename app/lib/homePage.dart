import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firestore.instance.collection('cleanups').getDocuments(),
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          );
        } else {
          QuerySnapshot snapshot = s.data;
          List documents = snapshot.documents;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (c, i) => FlatButton(
              onPressed: () {},
              child: PlatformText(documents[i]['lat'].toString()),
            ),
          );
        }
      },
    );
  }
}
