import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyltrax/show_data/genreList.dart';
import 'package:vinyltrax/inventory/getAlbums.dart';
import 'package:vinyltrax/show_data/categories.dart';
import '../inventory/getInvArtist.dart';
import '../inventory/invResults.dart';
import 'settingspage.dart' as settings;

enum _Order { artist, albums, genre, category }

enum Type { vinyl, cd, all }

class StaxPage extends StatefulWidget {
  const StaxPage({Key? key}) : super(key: key);

  @override
  State<StaxPage> createState() => _StaxPageState();
}

class _StaxPageState extends State<StaxPage> {
  final TextEditingController textController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  FocusNode focus = FocusNode();
  _Order _selectedOrder = _Order.artist;
  Type _selectedType = Type.all;
  bool isGenreButton = false;

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState ((){
        if(prefs.getString('order') == "category")
          _selectedOrder = _Order.category;
        else if(prefs.getString('order') == "albums")
          _selectedOrder = _Order.albums;
        else if(prefs.getString('order') == "genre")
          _selectedOrder = _Order.genre;
        else
          _selectedOrder = _Order.artist;

        if(prefs.getString('type') == "vinyl")
          _selectedType = Type.vinyl;
        else if (prefs.getString('type') == "cd")
          _selectedType = Type.cd;
        else
          _selectedType = Type.all;
      });
    });
  }

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
          toolbarHeight: MediaQuery.of(context).size.height * 0.24, //180
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: settings.darkTheme
                          ? Color(0xFFBB86FC)
                          : Color(0xFFFF5A5A),
                    ),
                    child: DropdownButton(
                        underline: SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(20),
                        dropdownColor: Colors.white,
                        value: _selectedOrder,
                        items: [
                          DropdownMenuItem(
                              child: Text("Artists",
                                  style: TextStyle(
                                      color: (_selectedOrder == _Order.artist)
                                          ? Colors.white
                                          : settings.darkTheme
                                              ? Color(0xFFBB86FC)
                                              : Color(0xFFFF5A5A))),
                              value: _Order.artist),
                          DropdownMenuItem(
                              child: Text("Albums",
                                  style: TextStyle(
                                      color: (_selectedOrder == _Order.albums)
                                          ? Colors.white
                                          : settings.darkTheme
                                              ? Color(0xFFBB86FC)
                                              : Color(0xFFFF5A5A))),
                              value: _Order.albums),
                          DropdownMenuItem(
                              child: Text("Genres",
                                  style: TextStyle(
                                      color: (_selectedOrder == _Order.genre)
                                          ? Colors.white
                                          : settings.darkTheme
                                              ? Color(0xFFBB86FC)
                                              : Color(0xFFFF5A5A))),
                              value: _Order.genre),
                          DropdownMenuItem(
                              child: Text("Categories",
                                  style: TextStyle(
                                      color: (_selectedOrder == _Order.category)
                                          ? Colors.white
                                          : settings.darkTheme
                                              ? Color(0xFFBB86FC)
                                              : Color(0xFFFF5A5A))),
                              value: _Order.category),
                        ],
                        onChanged: (type) async {
                          final SharedPreferences prefs = await _prefs;
                          prefs.setString('order', (type as _Order).name).then((bool success){
                            setState(() {
                              _selectedOrder = type;
                            });
                          });
                        }),
                  ),
                  SizedBox(width: 40),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: settings.darkTheme
                          ? Color(0xFFBB86FC)
                          : Color(0xFFFF5A5A),
                    ),
                    child: DropdownButton(
                        underline: SizedBox.shrink(),
                        borderRadius: BorderRadius.circular(20),
                        value: _selectedType,
                        items: [
                          DropdownMenuItem(
                              child: Text("All",
                                  style: TextStyle(
                                      color: (_selectedType == Type.all)
                                          ? Colors.white
                                          : settings.darkTheme
                                              ? Color(0xFFBB86FC)
                                              : Color(0xFFFF5A5A))),
                              value: Type.all),
                          DropdownMenuItem(
                              child: Text("Vinyl",
                                  style: TextStyle(
                                      color: (_selectedType == Type.vinyl)
                                          ? Colors.white
                                          : settings.darkTheme
                                              ? Color(0xFFBB86FC)
                                              : Color(0xFFFF5A5A))),
                              value: Type.vinyl),
                          DropdownMenuItem(
                              child: Text("CD",
                                  style: TextStyle(
                                      color: (_selectedType == Type.cd)
                                          ? Colors.white
                                          : settings.darkTheme
                                              ? Color(0xFFBB86FC)
                                              : Color(0xFFFF5A5A))),
                              value: Type.cd),
                        ],
                        onChanged: (type) async {
                          final SharedPreferences prefs = await _prefs;
                          prefs.setString('type', (type as Type).name).then((bool success){
                            setState(() {
                              _selectedType = type;
                            });
                          });
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
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
              else if (_selectedOrder == _Order.albums)
                GetInvAlbum(_selectedType)
              else
                Categories(_selectedType)
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
