import 'package:flutter/material.dart';

class HomePageRouter extends StatefulWidget {
  _HomePageRouterState state = _HomePageRouterState();

  set currentTab(int index){
    this.state.setCurrentTab = index;
  }
  @override
  _HomePageRouterState createState() => state;
}

class _HomePageRouterState extends State<HomePageRouter> {
  int currentTab; 

  set setCurrentTab(int index){
    setState(() {
      this.currentTab = index;
    });
  }
  @override
  void initState() {
    super.initState();

    this.currentTab = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (c){
        switch (this.currentTab) {
          case 0:
            return Container();
          case 1:
            return Container();

        }
      },
    );
  }
}