import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'homePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
        title: 'Flutter Demo',
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // ),
        home: PlatformTabScaffold(
          bottomNavBar: BottomNavigationBar(
            currentIndex: 0,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                title: Text('Create'),
              ),
            ],
          ),
        ));
  }
}
