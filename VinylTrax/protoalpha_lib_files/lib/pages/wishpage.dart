import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum _Order { artist, albums }

class WishPage extends StatefulWidget {
  const WishPage({Key? key}) : super(key: key);

  @override
  State<WishPage> createState() => _WishPageState();
}

class _WishPageState extends State<WishPage> {
  _Order _selectedOrder = _Order.artist;

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
    return Scaffold(
      backgroundColor: Color(0xFFFFFEF9),
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Color(0xFFFFFEF9),
        title: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child:
                  const Text("Wishlist", style: TextStyle(color: Colors.black)),
            ),
            Container(
              color: Color(0xFFFFFEF9),
              padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0.0),
              child: CupertinoSegmentedControl(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 6.0),
                selectedColor: Color(0xFFFF5A5A),
                borderColor: Color(0xFFFF5A5A),
                pressedColor: Color(0x64FF5A5A),
                children: {
                  _Order.artist: Container(
                    height: 30,
                    width: 140,
                    child: const Center(
                      child: Text("Artist", style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  _Order.albums: Container(
                    height: 30,
                    width: 140,
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
      body: Column(
        children: [
          //Listview for inventory
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createAlertDialog(context).then((value) {
            //when value is returned (a string) store it in the wishlist db
            print(value);
          });
        },
        backgroundColor: Color(0xFFFFFEF9),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
