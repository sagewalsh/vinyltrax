import 'package:flutter/material.dart';
import '../button_icons/settings.dart';
import '../button_icons/wishlist.dart';
import '../button_icons/vinyl.dart';
import '../pages/searchpage.dart';
import '../pages/staxpage.dart';
import '../pages/settingspage.dart';
import '../pages/wishpage.dart';
import 'package:firebase_database/firebase_database.dart';

class Tabs extends StatelessWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Color(0xFFFFFDF6),
        bottomNavigationBar: TabBar(
          indicatorColor: Color(0xFFFF5A5A),
          labelColor: Color(0xFFFF5A5A),
          unselectedLabelColor: Colors.black,
          tabs: <Widget>[
            Tab(
              icon: Icon(VinylIcon.cd),
            ),
            Tab(
              icon: Icon(WishlistIcon.wishlist),
            ),
            Tab(
              icon: Icon(Icons.search),
            ),
            Tab(
              icon: Icon(
                SettingIcon.cog,
                size: 21,
              ),
            )
          ],
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
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
