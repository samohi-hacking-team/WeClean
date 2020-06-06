import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomePage extends StatelessWidget {
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

          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 16),
            itemCount: documents.length,
            itemBuilder: (c, i) => FlatButton(
              onPressed: () {},
              child: cleanupButton(documents[i], c),
            ),
          );
        }
      },
    );
  }

  Widget cleanupButton(DocumentSnapshot document, BuildContext context) =>
      RaisedButton(
        padding: const EdgeInsets.only(bottom: 32),
        color: Color(0xffddeeef),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(32),
            bottomLeft: Radius.circular(32),
          ),
        ),
        onPressed: () {},
        child: Column(
          children: [
            imageMaker(document['imagePath'], context),
            SizedBox(
              height: 16,
            ),
            PlatformText(document['address']),
          ],
        ),
      );

  FutureBuilder imageMaker(String imagePath, BuildContext context) {
    return FutureBuilder(
      future: FirebaseStorage.instance.ref().child(imagePath).getDownloadURL(),
      builder: (c, s) {
        if (s.connectionState != ConnectionState.done) {
          return Container(
            color: Color(0xFFf8c630).withOpacity(.25),
            height: 125,
            width: MediaQuery.of(context).size.width,
          );
        } else if (s.hasError) {
          return Container(
            color: Color(0xFFf8c630).withOpacity(.25),
            height: 125,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PlatformText("Sorry, we can't fetch this image right now.",
                    textAlign: TextAlign.center)
              ],
            ),
          );
        } else {
          String downloadLink = s.data;
          return Image.network(
            downloadLink,
            fit: BoxFit.fitWidth,
            height: 125,
            cacheHeight: 125,
            width: MediaQuery.of(context).size.width,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Column(children: <Widget>[
                Container(
                  color: Color(0xFFf8c630).withOpacity(.25),
                  height: 125,
                ),
                LinearProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                )
              ]);
            },
          );
        }
      },
    );
  }
}
