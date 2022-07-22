import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../returnedData/getWishAlbum.dart';

enum _Order { artist, albums }

class WishPage extends StatefulWidget {
  const WishPage({Key? key}) : super(key: key);

  @override
  State<WishPage> createState() => _WishPageState();
}

class _WishPageState extends State<WishPage> {
  _Order _selectedOrder = _Order.artist;
  String order = "Artist";

  Future createAlertDialog(BuildContext context) {
    TextEditingController _customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("What do you wish for?"),
            content: TextField(
              controller: _customController,
            ),
            actions: [
              MaterialButton(
                elevation: 5.0,
                child: Text("Submit"),
                onPressed: () {
                  Navigator.of(context).pop(_customController.text.toString());
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedOrder == _Order.albums)
      order = "Albums";
    else if (_selectedOrder == _Order.artist) order = "Artists";

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFEF9),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height * 0.14, //75
          backgroundColor: Color(0xFFFFFEF9),
          title: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text("Wishlist",
                    style: TextStyle(color: Colors.black)),
              ),
              Container(
                color: Color(0xFFFFFEF9),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.0099), // 8
                child: CupertinoSegmentedControl(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.02, //8
                      0.0,
                      MediaQuery.of(context).size.width * 0.02, //8
                      MediaQuery.of(context).size.height * 0.015), //6
                  selectedColor: Color(0xFFFF5A5A),
                  borderColor: Color(0xFFFF5A5A),
                  pressedColor: Color(0x64FF5A5A),
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     //lets me see with no issue what the sizes are
        //     // print(MediaQuery.of(context).size.width);
        //     // print(MediaQuery.of(context).size.height);
        //     createAlertDialog(context).then((value) {
        //       //when value is returned (a string) store it in the wishlist db
        //       // print(value);
        //     });
        //   },
        //   backgroundColor: Color(0xFFFF5A5A),
        //   child: const Icon(Icons.add, color: Colors.white),
        // ),
      ),
    );
  }
}
