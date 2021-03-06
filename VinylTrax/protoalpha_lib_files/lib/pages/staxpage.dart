import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/genreList.dart';
import 'package:vinyltrax/returnedData/getInvAlbum.dart';
import '../returnedData/getInvArtist.dart';
import 'invResults.dart';

enum _Order { artist, albums, genre }

enum _Type { vinyl, cd, all }

class StaxPage extends StatefulWidget {
  const StaxPage({Key? key}) : super(key: key);

  @override
  State<StaxPage> createState() => _StaxPageState();
}

class _StaxPageState extends State<StaxPage> {
  final TextEditingController textController = TextEditingController();
  FocusNode focus = FocusNode();
  _Order _selectedOrder = _Order.artist;
  _Type _selectedType = _Type.vinyl;
  bool isGenreButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFEF9),
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 180,
        title: Column(
          children: [
            Container(
              // Name of Page
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text("Stax of Trax",
                  style: TextStyle(color: Colors.black)),
              color: Color(0xFFFFFDF6),
            ),
            Container(
              // Search Bar
              color: Color(0xFFFFFEF9),
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    // color: Color.fromARGB(255, 244, 244, 244),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFFFFEF9),
                    ),
                    child: TextField(
                      controller: textController,
                      focusNode: focus,
                      onTap: () => FocusScope.of(context).requestFocus(focus),
                      decoration: InputDecoration(
                        labelText: "Search Inventory",
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: "Artist, Album, Song",
                        hintStyle: TextStyle(
                          color: Color(0xFFFF5A5A),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color(0xFFFF5A5A),
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.search,
                          color: focus.hasFocus ? Color(0xFFFF5A5A) : Colors.black,
                        ),
                      ),
                      onSubmitted: (text) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return InvResults(text);
                            }));
                      },
                    ),
                  )),
              width: double.infinity,
              height: 75,
            ),
            Container(
              // Artist / Albums / Genre Buttons
              color: Color(0xFFFFFEF9),
              child: CupertinoSegmentedControl(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 6.0),
                selectedColor: Color(0xFFFF5A5A),
                borderColor: Color(0xFFFF5A5A),
                pressedColor: Color(0x60FF5A5A),
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
              color: Color(0xFFFFFEF9),
              child: CupertinoSegmentedControl(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                selectedColor: Color(0xFFFF5A5A),
                borderColor: Color(0xFFFF5A5A),
                pressedColor: Color(0x64FF5A5A),
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
        backgroundColor: Color(0xFFFFFEF9),
      ),
      body: SingleChildScrollView(
        // Inventory View Outputs
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (_selectedOrder == _Order.genre)
              GenreList()
            else if (_selectedOrder == _Order.artist)
              GetInvArtist()
            else
              GetInvAlbum()
          ],
        ),
      ),
    );
  }

  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
