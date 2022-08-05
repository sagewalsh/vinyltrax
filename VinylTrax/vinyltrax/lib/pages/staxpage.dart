import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/genreList.dart';
import 'package:vinyltrax/inventory/getAlbums.dart';
import '../inventory/getInvArtist.dart';
import '../inventory/invResults.dart';
import 'settingspage.dart' as settings;
import '../spotify/spotifyResults.dart';

enum _Order { artist, albums, genre, category }

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
              Row(
                children: [
                  DropdownButton(
                    value: _selectedOrder,
                    items: const [
                      DropdownMenuItem(child: Text("Artists"), value: _Order.artist),
                      DropdownMenuItem(child: Text("Albums"), value: _Order.albums),
                      DropdownMenuItem(child: Text("Genres"), value: _Order.genre),
                      DropdownMenuItem(child: Text("Categories"), value: _Order.category),
                    ],
                    onChanged: (type) {
                      setState(() {
                        _selectedOrder = type as _Order;
                      });
                    }
                  ),
                  DropdownButton(
                      value: _selectedType,
                      items: const [
                        DropdownMenuItem(child: Text("All"), value: Type.all),
                        DropdownMenuItem(child: Text("Vinyl"), value: Type.vinyl),
                        DropdownMenuItem(child: Text("CD"), value: Type.cd),
                      ],
                      onChanged: (type) {
                        setState(() {
                          _selectedType = type as Type;
                        });
                      }
                  ),
                ],
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
