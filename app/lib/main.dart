import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'homePage.dart';
import 'mapPage.dart';
import 'createPage.dart';
import 'signInPage.dart';
import 'tensorFlow.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      title: 'Flutter Demo',
      android:(c)=> MaterialAppData(
        darkTheme: ThemeData.dark(),
        theme: ThemeData(),
      ),
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      home: BigBoi(),
    );
  }
}

class BigBoi extends StatefulWidget {
  @override
  _BigBoiState createState() => _BigBoiState();
}

class _BigBoiState extends State<BigBoi> {
  PlatformTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new PlatformTabController();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformTabScaffold(
        appBarBuilder: (c, i) {
          switch (i) {
            case 0:
              return PlatformAppBar(
                title: PlatformText('Cleanups'),
              );
            case 2:
              return PlatformAppBar(
                title: PlatformText('Create Cleanup'),
              );
            default: 
              return PlatformAppBar(
                title: PlatformText("Map"),
              );
          }
        },
        tabController: _controller,
        currentIndex: 0,
        bodyBuilder: (c, i) {
          switch (i) {
            case 0:
              return HomePage();
            case 1:
              return MapPage();
            case 2:
              return CreatePage();
            default:
              return Center(
                child: PlatformText('An Error Occured'),
              );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Create'),
          ),
        ],
      );
  }
}