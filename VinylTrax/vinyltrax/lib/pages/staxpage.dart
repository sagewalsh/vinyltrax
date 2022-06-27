import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../textinput.dart';

enum _Order { artist, albums, genre }

enum _Type { vinyl, cd, all }

class StaxPage extends StatefulWidget {
  const StaxPage({Key? key}) : super(key: key);

  State<StaxPage> createState() => _StaxPageState();
}

class _StaxPageState extends State<StaxPage> {
  _Order _selectedOrder = _Order.artist;
  _Type _selectedType = _Type.vinyl;

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
              color: Color.fromARGB(255, 244, 244, 244),
              child: TextInput("Search Inventory"),
            ),
            Container(
              color: Color.fromARGB(255, 244, 244, 244),
              child: CupertinoSegmentedControl(
                padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 6.0),
                selectedColor: Color.fromRGBO(133, 133, 133, 1),
                borderColor: Color.fromRGBO(133, 133, 133, 1),
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
              color: Color.fromARGB(255, 244, 244, 244),
              child: CupertinoSegmentedControl(
                padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                selectedColor: Color.fromRGBO(133, 133, 133, 1),
                borderColor: Color.fromRGBO(133, 133, 133, 1),
                pressedColor: Colors.grey,
                children: {
                  _Type.vinyl: Container(
                    height: 30,
                    width: 140,
                    child: const Center(
                      child: Text("Vinyl"),
                    ),
                  ),
                  _Type.cd: Container(
                    height: 20,
                    width: 140,
                    child: const Center(
                      child: Text("CD"),
                    ),
                  ),
                  _Type.all: Container(
                    height: 20,
                    width: 140,
                    child: Center(
                      child: Text("All"),
                    ),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    _selectedType = value as _Type;
                  });
                },
                groupValue: _selectedType,
              ),
            ),
          ],
        ));
  }
}