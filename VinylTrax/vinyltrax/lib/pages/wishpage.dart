import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../textinput.dart';

enum _Order { artist, albums, genre }

class WishPage extends StatefulWidget {
  const WishPage({Key? key}) : super(key: key);

  @override
  State<WishPage> createState() => _WishPageState();
}

class _WishPageState extends State<WishPage> {
  _Order _selectedOrder = _Order.artist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(30, 0, 105, 1),
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text("Wishlist"),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Color.fromRGBO(30, 0, 105, 1),
            padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0.0),
            child: CupertinoSegmentedControl(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 6.0),
              selectedColor: Color.fromRGBO(225, 80, 129, 30),
              borderColor: Color.fromRGBO(225, 80, 129, 30),
              pressedColor: Color.fromRGBO(225, 80, 129, 30),
              children: {
                _Order.artist: Container(
                  height: 30,
                  width: 140,
                  child: const Center(
                    child: Text("Artist"),
                  ),
                ),
                _Order.albums: Container(
                  height: 30,
                  width: 140,
                  child: const Center(
                    child: Text("Albums"),
                  ),
                ),
                _Order.genre: Container(
                  height: 30,
                  width: 140,
                  child: const Center(
                    child: Text("Genre"),
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
          Container(
            // color: const Color.fromARGB(255, 244, 244, 244),
            child: Divider(
              color: Color.fromRGBO(225, 80, 129, 30),
              height: 5,
              thickness: .5,
              indent: 8,
              endIndent: 8,
            ),
          ),
        ],
      ),
    );
  }
}
