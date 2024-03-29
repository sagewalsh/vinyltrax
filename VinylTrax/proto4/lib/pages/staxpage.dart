import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/genreList.dart';
import 'package:vinyltrax/inventory/getAlbums.dart';
import '../inventory/getInvArtist.dart';
import '../inventory/invResults.dart';
import 'settingspage.dart' as settings;
import '../spotify/spotifyResults.dart';

enum _Order { artist, albums, genre }

enum Type { vinyl, cd, all }

class StaxPage extends StatefulWidget {
  const StaxPage({Key? key}) : super(key: key);

  @override
  State<StaxPage> createState() => _StaxPageState();
}

class _StaxPageState extends State<StaxPage> {
  final TextEditingController textController = TextEditingController();
  FocusNode focus = FocusNode();
  _Order _selectedOrder = _Order.artist;
  Type _selectedType = Type.vinyl;
  bool isGenreButton = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            settings.darkTheme ? Color(0xFF1C1C1C) : Color(0xFFFFFDF6),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 10,
          // toolbarHeight: MediaQuery.of(context).size.height * 0.24, //180
          toolbarHeight: MediaQuery.of(context).size.height * 0.28, //180
          title: Column(
            children: [
              Container(
                // Name of Page
                padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text("Stax of Trax",
                    style: TextStyle(
                        color:
                            settings.darkTheme ? Colors.white : Colors.black)),
                color:
                    settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
              ),
              Container(
                // Search Bar
                color:
                    settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
                child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: settings.darkTheme
                            ? Color(0xFF181818)
                            : Color(0xFFFFFDF6),
                      ),
                      child: TextField(
                        style: TextStyle(
                            color: settings.darkTheme
                                ? Colors.white
                                : Colors.black),
                        textAlignVertical: TextAlignVertical.center,
                        controller: textController,
                        focusNode: focus,
                        onTap: () => FocusScope.of(context).requestFocus(focus),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: settings.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  width: 1),
                              borderRadius: BorderRadius.circular(15)),
                          contentPadding: EdgeInsets.only(left: 15),
                          isCollapsed: true,
                          labelText: "Search Inventory",
                          labelStyle: TextStyle(
                              color: settings.darkTheme
                                  ? Colors.white
                                  : Colors.black),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintText: "Artist, Album, Song",
                          hintStyle: TextStyle(
                            color: settings.darkTheme
                                ? Color(0xFFBB86FC)
                                : Color(0xFFFF5A5A),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: settings.darkTheme
                                  ? Color(0xFFBB86FC)
                                  : Color(0xFFFF5A5A),
                            ),
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: focus.hasFocus
                                ? settings.darkTheme
                                    ? Color(0xFFBB86FC)
                                    : Color(0xFFFF5A5A)
                                : settings.darkTheme
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                        onSubmitted: (text) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return InvResults(text);
                            // return SpotifyResults(text);
                          }));
                        },
                      ),
                    )),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.085,
              ),
              Container(
                // Artist / Albums / Genre Buttons
                color:
                    settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
                child: CupertinoSegmentedControl(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 6.0),
                  selectedColor: settings.darkTheme
                      ? Color(0xFFBB86FC)
                      : Color(0xFFFF5A5A),
                  borderColor: settings.darkTheme
                      ? Color(0xFFBB86FC)
                      : Color(0xFFFF5A5A),
                  pressedColor: settings.darkTheme
                      ? Color(0x64BB86FC)
                      : Color(0x64FF5A5A),
                  children: {
                    _Order.artist: Container(
                      height: MediaQuery.of(context).size.height * 0.037, //30
                      width: MediaQuery.of(context).size.width * 0.4897, //140
                      child: const Center(
                        child: Text("Artist", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    _Order.albums: Container(
                      height: MediaQuery.of(context).size.height * 0.037, //30
                      width: MediaQuery.of(context).size.width * 0.4897, //140
                      child: const Center(
                        child: Text("Albums", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    _Order.genre: Container(
                      height: MediaQuery.of(context).size.height * 0.037, //30
                      width: MediaQuery.of(context).size.width * 0.4897, //140
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
                color:
                    settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
                child: CupertinoSegmentedControl(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                  selectedColor: settings.darkTheme
                      ? Color(0xFFBB86FC)
                      : Color(0xFFFF5A5A),
                  borderColor: settings.darkTheme
                      ? Color(0xFFBB86FC)
                      : Color(0xFFFF5A5A),
                  pressedColor: settings.darkTheme
                      ? Color(0x64BB86FC)
                      : Color(0x64FF5A5A),
                  children: {
                    Type.vinyl: Container(
                      height: MediaQuery.of(context).size.height * 0.037, //30
                      width: MediaQuery.of(context).size.width * 0.4897, //140
                      child: const Center(
                        child: Text("Vinyl", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    Type.cd: Container(
                      height: MediaQuery.of(context).size.height * 0.037, //30
                      width: MediaQuery.of(context).size.width * 0.4897, //140
                      child: const Center(
                        child: Text("CD", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                    Type.all: Container(
                      height: MediaQuery.of(context).size.height * 0.037, //30
                      width: MediaQuery.of(context).size.width * 0.4897, //140
                      child: const Center(
                        child: Text("All", style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      _selectedType = value as Type;
                    });
                  },
                  groupValue: _selectedType,
                ),
              ),
            ],
          ),
          backgroundColor:
              settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
        ),
        body: SingleChildScrollView(
          // Inventory View Outputs
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              if (_selectedOrder == _Order.genre)
                GenreList(_selectedType)
              else if (_selectedOrder == _Order.artist)
                GetInvArtist(_selectedType)
              else
                GetInvAlbum(_selectedType)
            ],
          ),
        ),
      ),
    );
  }

  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
