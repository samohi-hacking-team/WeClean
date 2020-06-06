import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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
        currentIndex: 0,
        bodyBuilder: (c, i) {
          switch (i) {
            case 0:
              return Container();
            case 1:
              return Container();
            case 2:
              return Container();
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
            icon: Icon(Icons.add),
            title: Text('Create'),
          ),
        ],
      ),
    );
  }
}
