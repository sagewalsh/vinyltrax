import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text("Stax of Trax"),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 244, 244, 244),
            padding: const EdgeInsets.fromLTRB(0, 18.0, 0, 8.0),
            child: CupertinoSegmentedControl(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 6.0),
              selectedColor: const Color.fromARGB(255, 120, 120, 120),
              borderColor: const Color.fromARGB(255, 120, 120, 120),
              pressedColor: Colors.grey,
              children: {
                _Order.artist: Container(
                  height: 30,
                  width: 140,
                  child: const Center(
                    child: Text("Artist"),
                  ),
                ),
                _Order.albums: Container(
                  height: 20,
                  width: 140,
                  child: const Center(
                    child: Text("Albums"),
                  ),
                ),
                _Order.genre: Container(
                  height: 20,
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
              color: Colors.grey[400],
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
