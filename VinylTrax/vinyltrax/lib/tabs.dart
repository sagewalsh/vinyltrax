import 'package:flutter/material.dart';
import 'pages/searchpage.dart';
import 'pages/staxpage.dart';
import 'pages/settingspage.dart';
import 'pages/wishpage.dart';
import 'package:firebase_database/firebase_database.dart';

class Tabs extends StatelessWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: Scaffold(
        // backgroundColor: Colors.blue,
        bottomNavigationBar: TabBar(
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.circle),
            ),
            Tab(
              icon: Icon(Icons.star),
            ),
            Tab(
              icon: Icon(Icons.search),
            ),
            Tab(
              icon: Icon(Icons.settings),
            )
          ],
        ),
        body: TabBarView(
          children: [
            StaxPage(),
            WishPage(),
            SearchPage(),
            SettingsPage(),
          ],
        ),
      ),
    );
  }
}
