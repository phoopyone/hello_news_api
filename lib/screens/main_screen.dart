import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'package:hello_news_api_tut/bloc/bottom_navbar_bloc.dart';
import 'package:hello_news_api_tut/screens/tabs/home_screen.dart';
import 'package:hello_news_api_tut/screens/tabs/search_screen.dart';
import 'package:hello_news_api_tut/screens/tabs/source_screen.dart';
import 'package:hello_news_api_tut/style/theme.dart' as Style;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BottomNavBarBloc _bottomNavBarBloc;

  @override
  void initState() {
    _bottomNavBarBloc = BottomNavBarBloc();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Style.Colors.mainColor,
          title: Text(
            "News App",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<NavBarItem>(
          stream: _bottomNavBarBloc.itemStream,
          initialData: _bottomNavBarBloc.defaultItem,
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
            switch (snapshot.data) {
              case NavBarItem.Home:
                return HomeScreen();

                break;
              case NavBarItem.Sources:
                return SourceScreen();
                break;
              case NavBarItem.Search:
                return SearchScreen();
                break;
            }
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[100],
                      spreadRadius: 0,
                      blurRadius: 10.0)
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                iconSize: 20.0,
                unselectedItemColor: Colors.grey,
                // selectedItemColor: Colors.red,
                selectedFontSize: 9.5,
                unselectedFontSize: 9.5,
                type: BottomNavigationBarType.fixed,
                currentIndex: snapshot.data.index,
                onTap: _bottomNavBarBloc.pickItem,
                fixedColor: Style.Colors.mainColor,
                items: [
                  BottomNavigationBarItem(
                    title: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text("Home"),
                    ),
                    icon: Icon(
                      EvaIcons.homeOutline,
                    ),
                    activeIcon: Icon(
                      EvaIcons.home,
                    ),
                  ),
                  BottomNavigationBarItem(
                    title: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text("Sources"),
                    ),
                    icon: Icon(
                      EvaIcons.gridOutline,
                    ),
                    activeIcon: Icon(EvaIcons.grid),
                  ),
                  BottomNavigationBarItem(
                    title: Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text("Search"),
                    ),
                    icon: Icon(EvaIcons.searchOutline),
                    activeIcon: Icon(EvaIcons.search),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget testScreen() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [Text("Test Screen")],
      ),
    );
  }
}
