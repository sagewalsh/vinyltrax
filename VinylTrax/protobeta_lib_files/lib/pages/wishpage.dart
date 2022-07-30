import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'wishAlbums.dart';
import 'settingspage.dart' as settings;

enum _Order { artist, albums }

class WishPage extends StatefulWidget {
  const WishPage({Key? key}) : super(key: key);

  @override
  State<WishPage> createState() => _WishPageState();
}

class _WishPageState extends State<WishPage> {
  _Order _selectedOrder = _Order.artist;
  String order = "Artist";

  @override
  Widget build(BuildContext context) {
    if (_selectedOrder == _Order.albums)
      order = "Albums";
    else if (_selectedOrder == _Order.artist) order = "Artists";

    return SafeArea(
      child: Scaffold(
        backgroundColor: settings.darkTheme ? Color(0xFF1C1C1C) : Color(0xFFFFFDF6),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height * 0.14, //75
          backgroundColor: settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
          title: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text("Wishlist",
                    style: TextStyle(color: settings.darkTheme ? Colors.white : Colors.black)),
              ),
              Container(
                color: settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.0099), // 8
                child: CupertinoSegmentedControl(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.02, //8
                      0.0,
                      MediaQuery.of(context).size.width * 0.02, //8
                      MediaQuery.of(context).size.height * 0.015), //6
                  selectedColor: settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
                  borderColor: settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
                  pressedColor: settings.darkTheme ? Color(0x64BB86FC) : Color(0x64FF5A5A),
                  children: {
                    _Order.artist: Container(
                      height: MediaQuery.of(context).size.height * 0.037, //30
                      width: MediaQuery.of(context).size.width * 0.357, //140
                      child: const Center(
                        child: Text("Artist", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    _Order.albums: Container(
                      height: MediaQuery.of(context).size.height * 0.037, //30
                      width: MediaQuery.of(context).size.width * 0.357, //140
                      child: const Center(
                        child: Text("Albums", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      _selectedOrder = value as _Order;
                    });
                  },
                  groupValue: _selectedOrder,
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              //Listview for inventory
              GetWishAlbum(order),
            ],
          ),
        ),
      ),
    );
  }
}
