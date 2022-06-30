import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../show_data/albumIcon.dart';
import '../textinput.dart';

enum _Order { artist, albums, genre }

enum _Type { vinyl, cd, all }

class StaxPage extends StatefulWidget {
  const StaxPage({Key? key}) : super(key: key);

  @override
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 244, 244, 244),
              child: const TextInput("Search Inventory"),
            ),
            Container(
              color: const Color.fromARGB(255, 244, 244, 244),
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
              color: const Color.fromARGB(255, 244, 244, 244),
              child: CupertinoSegmentedControl(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                selectedColor: const Color.fromARGB(255, 120, 120, 120),
                borderColor: const Color.fromARGB(255, 120, 120, 120),
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
                    height: 30,
                    width: 140,
                    child: const Center(
                      child: Text("CD"),
                    ),
                  ),
                  _Type.all: Container(
                    height: 30,
                    width: 140,
                    child: const Center(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 30,
                  runSpacing: 20,
                  children: [
                    AlbumIcon("art1", "alb1", ""),
                    AlbumIcon("art2", "alb2", ""),
                    AlbumIcon("art3", "alb3", ""),
                    AlbumIcon("art4", "alb4", ""),
                    AlbumIcon("art5", "alb5", ""),
                    AlbumIcon("art6", "alb6", ""),
                    AlbumIcon("art7", "alb7", ""),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}