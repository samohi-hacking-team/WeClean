import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'homepagerouter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  HomePageRouter homeTabRouter = HomePageRouter();

  @override
  Widget build(BuildContext context) {
    return PlatformApp(
        title: 'Flutter Demo',
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // ),
        home: PlatformScaffold(
          appBar: PlatformAppBar(
            title: PlatformText('WeClean'),
          ),
          body: this.homeTabRouter,
          bottomNavBar: PlatformNavBar(
            currentIndex: 0,
            itemChanged: (v){
              this.homeTabRouter.currentTab = v;
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
        ));
  }
}
