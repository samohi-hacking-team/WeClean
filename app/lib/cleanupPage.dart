import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CleanupPage extends StatelessWidget {
  final DocumentSnapshot document;
  CleanupPage({@required this.document});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar:
          PlatformAppBar(title: PlatformText(document['name'] ?? 'Cleanup')),
      body: Column(
        children: [
          imageMaker(document['imagePath'], context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlatformButton(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  PlatformText(
                    document['name'] ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      color: isMaterial(context)
                          ? Theme.of(context).textTheme.bodyText1.color
                          : CupertinoTheme.of(context).textTheme.textStyle.color,
                    ),
                  ),
                  PlatformText(
                    document['description'] ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: isMaterial(context)
                          ? Theme.of(context).textTheme.bodyText1.color
                          : CupertinoTheme.of(context).textTheme.textStyle.color,
                    ),
                  ),
                  Divider(
                    height: 12,
                  ),
                  PlatformText(
                    document['address'] ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: isMaterial(context)
                          ? Theme.of(context).textTheme.bodyText1.color
                          : CupertinoTheme.of(context).textTheme.textStyle.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                width: MediaQuery.of(context).size.width,
              ),
            );
          } else if (s.hasError) {
            return Container(
              color: Color(0xFFf8c630).withOpacity(.25),
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
              fit: BoxFit.fill,
              height: 200,
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
    } catch (e) {
      return Container();
    }
  }
}
