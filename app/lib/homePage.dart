import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'cleanupPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DocumentSnapshot> children = [];

  Future<List<DocumentSnapshot>> get getChildren async {
    return (await Firestore.instance.collection('cleanups').getDocuments())
        .documents;
  }

  @override
  void initState() {
    super.initState();
    this.getChildren;
    loadChildren();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: Platform.isIOS ? 88.0 : 0,
          ),
        ),
        if (Platform.isIOS)
          CupertinoSliverRefreshControl(
            refreshTriggerPullDistance: 80,
            builder: (c, s, d, b, a) {
              switch (s) {
                case RefreshIndicatorMode.inactive:
                  return Container();
                case RefreshIndicatorMode.drag:
                  return Container();
                case RefreshIndicatorMode.armed:
                  return Padding(
                    padding: EdgeInsets.only(top: d),
                    child: CupertinoActivityIndicator(),
                  );

                case RefreshIndicatorMode.refresh:
                  return Padding(
                    padding: EdgeInsets.only(top: d),
                    child: CupertinoActivityIndicator(),
                  );
                case RefreshIndicatorMode.done:
                  return Container();
                default:
                  return Padding(
                    padding: EdgeInsets.only(top: d),
                    child: CupertinoActivityIndicator(),
                  );
              }
            },
            onRefresh: () async {
              await loadChildren();
            },
          ),
        this.children.isEmpty
            ? SliverFillRemaining(child: Center(child: PlatformCircularProgressIndicator()))
            : SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(
                    this.children.length,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: cleanupButton(
                        children[i],
                        context,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
    return Padding(
      padding: EdgeInsets.only(top: Platform.isIOS ? 80.0 : 0),
      child: FutureBuilder(
        future: Firestore.instance.collection('cleanups').getDocuments(),
        builder: (c, s) {
          if (s.connectionState != ConnectionState.done) {
            return Container(
              child: Center(
                child: PlatformCircularProgressIndicator(),
              ),
            );
          } else {
            //return ChildrenBuilder();
          }
        },
      ),
    );
  }

  Widget cleanupButton(DocumentSnapshot document, BuildContext context) =>
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: PlatformButton(
          padding: EdgeInsets.zero,
          color: isMaterial(context)
              ? (Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[200]
                  : Colors.grey[700])
              : (CupertinoTheme.brightnessOf(context) == Brightness.light
                  ? CupertinoColors.lightBackgroundGray
                  : CupertinoColors.systemGrey6),
          onPressed: () => Navigator.push(
            context,
            platformPageRoute(
              builder: (c) => CleanupPage(
                document: document,
              ),
              context: context,
            ),
          ),
          child: Row(
            children: [
              imageMaker(document['imagePath'], context),
              Container(
                width: ((MediaQuery.of(context).size.width - 32) / 3) * 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PlatformText(
                        document['name'] ?? "",
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        //overflow: TextOverflow.,
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
                      SizedBox(
                        height: 8,
                      ),
                      PlatformText(
                        document['description'] ?? "",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          color: isMaterial(context)
                              ? Theme.of(context).textTheme.bodyText1.color
                              : CupertinoTheme.of(context)
                                  .textTheme
                                  .textStyle
                                  .color,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      PlatformText(
                        (document['address'] ?? "").split(', ')[1],
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
                height: MediaQuery.of(context).size.width / 3,
                color: Colors.blue.withOpacity(.25),
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

  Future<void> loadChildren() async {
    setState(() {
      this.children = [];
    });
    var temp = await this.getChildren;
    setState(() {
      this.children = temp;
    });
  }
}
