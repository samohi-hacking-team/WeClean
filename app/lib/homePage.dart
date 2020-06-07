import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Platform.isIOS ? 80.0 : 0),
      child: FutureBuilder(
        future: Firestore.instance.collection('cleanups').getDocuments(),
        builder: (c, s) {
          if (s.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            QuerySnapshot snapshot = s.data;
            List documents = snapshot.documents;

            return ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              itemCount: documents.length,
              separatorBuilder: (c, i) {
                return Container(height: 18);
              },
              itemBuilder: (c, i) => cleanupButton(documents[i], c),
            );
          }
        },
      ),
    );
  }

  Widget cleanupButton(DocumentSnapshot document, BuildContext context) =>
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: PlatformButton(
          //color: Color(0xffddeeef),
          padding: EdgeInsets.zero,
          color: isMaterial(context)
              ? (Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[200]
                  : Colors.grey[700])
              : (CupertinoTheme.brightnessOf(context) == Brightness.light
                  ? CupertinoColors.lightBackgroundGray
                  : CupertinoColors.systemGrey6),
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: Row(
            children: [
              imageMaker(document['imagePath'], context),
              Container(
                width: ((MediaQuery.of(context).size.width - 32) / 3) * 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PlatformText(
                        document['name'] ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          color: isMaterial(context)
                              ? Theme.of(context).textTheme.bodyText1.color
                              : CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .color,
                        ),
                      ),
                      PlatformText(
                        document['description'] ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isMaterial(context)
                              ? Theme.of(context).textTheme.bodyText1.color
                              : CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .color,
                        ),
                      ),
                      PlatformText(
                        document['address'] ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: isMaterial(context)
                              ? Theme.of(context).textTheme.bodyText1.color
                              : CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget imageMaker(String imagePath, BuildContext context) {
    try {
      return FutureBuilder(
        future:
            FirebaseStorage.instance.ref().child(imagePath).getDownloadURL(),
        builder: (c, s) {
          if (s.connectionState != ConnectionState.done) {
            return IntrinsicHeight(
              child: Container(
                color: Color(0xFFf8c630).withOpacity(.25),
                child: Center(
                  child: PlatformCircularProgressIndicator(),
                ),
                width: ((MediaQuery.of(context).size.width - 32)) / 3,
              ),
            );
          } else if (s.hasError) {
            return Container(
              color: Color(0xFFf8c630).withOpacity(.25),
              width: ((MediaQuery.of(context).size.width - 32)) / 3,
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
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.width / 3,
              width: ((MediaQuery.of(context).size.width - 32)) / 3,
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
    } catch (e) {
      return Container();
    }
  }
}
