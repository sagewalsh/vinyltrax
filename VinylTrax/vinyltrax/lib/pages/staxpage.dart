import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vinyltrax/show_data/genreList.dart';
import 'package:vinyltrax/returnedData/byAlbum.dart';
import '../returnedData/byArtist.dart';
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
  bool isGenreButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 180,
        title: Column(
          children: [
            Container(
              // Name of Page
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text("Stax of Trax"),
              color: Color.fromRGBO(30, 0, 105, 1),
            ),
            Container(
              // Search Bar
              color: const Color.fromARGB(255, 244, 244, 244),
              child: TextInput("Search Inventory", true),
              width: double.infinity,
              height: 75,
            ),
            Container(
              // Artist / Albums / Genre Buttons
              color: Color.fromRGBO(30, 0, 105, 1),
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
                  _Order.genre: Container(
                    height: 30,
                    width: 140,
                    child: const Center(
                      child: Text("Genre", style: TextStyle(fontSize: 14)),
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
              // Vinyl / CD / All Buttons
              color: Color.fromRGBO(30, 0, 105, 1),
              child: CupertinoSegmentedControl(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                selectedColor: Color.fromRGBO(225, 80, 129, 30),
                borderColor: Color.fromRGBO(225, 80, 129, 30),
                pressedColor: Color.fromRGBO(225, 80, 129, 30),
                children: {
                  _Type.vinyl: Container(
                    height: 30,
                    width: 140,
                    child: const Center(
                      child: Text("Vinyl", style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  _Type.cd: Container(
                    height: 30,
                    width: 140,
                    child: const Center(
                      child: Text("CD", style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  _Type.all: Container(
                    height: 30,
                    width: 140,
                    child: const Center(
                      child: Text("All", style: TextStyle(fontSize: 14)),
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
        ),
        backgroundColor: Color.fromRGBO(30, 0, 105, 1),
      ),
      body: SingleChildScrollView(
        // Inventory View Outputs
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (_selectedOrder == _Order.genre)
              GenreList()
            else if (_selectedOrder == _Order.artist)
              AlbumOrderArtist()
            else
              AlbumOrderAlbum()
          ],
        ),
      ),
    );
  }
}
