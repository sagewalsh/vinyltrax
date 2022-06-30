import 'package:flutter/material.dart';
import 'package:vinyltrax/fliterButtons.dart';
import 'package:firebase_database/firebase_database.dart';
import '../textinput.dart';
import '../iconOrList.dart';
import '../database.dart';
import './searchresultspage.dart';
import 'package:flutter/cupertino.dart';
import '../returnedData/byArtist.dart';
import '../returnedData/byAlbum.dart';
import '../returnedData/byGenre.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

enum _resultType { byArtist, byAlbum, byGenre }

class _SearchPageState extends State<SearchPage> {
  final textBox = TextInput("Search");
  _resultType _selected = _resultType.byArtist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text("Search Page"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: textBox,
              color: Color.fromARGB(255, 244, 244, 244),
              width: double.infinity,
              height: 75,
            ),
            Container(
              color: Color.fromARGB(255, 244, 244, 244),
              child: Row(
                children: [
                  iconOrList(),
                  SizedBox(width: 5),
                  filterButtons(),
                ],
              ),
            ),
            Container(color: Color.fromARGB(255, 244, 244, 244), height: 5),
            Divider(
              color: Colors.grey[400],
              height: 5,
              thickness: .5,
              indent: 8,
              endIndent: 8,
            ),
            Container(
              color: const Color.fromARGB(255, 244, 244, 244),
              child: CupertinoSegmentedControl(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                selectedColor: const Color.fromARGB(255, 120, 120, 120),
                borderColor: const Color.fromARGB(255, 120, 120, 120),
                pressedColor: Colors.grey,
                children: {
                  _resultType.byArtist: Container(
                    height: 30,
                    width: 140,
                    child: const Center(
                      child: Text("By Artist"),
                    ),
                  ),
                  _resultType.byAlbum: Container(
                    height: 30,
                    width: 140,
                    child: const Center(
                      child: Text("By Album"),
                    ),
                  ),
                  _resultType.byGenre: Container(
                    height: 30,
                    width: 140,
                    child: const Center(child: Text("By Genre")),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    _selected = value as _resultType;
                  });
                },
                groupValue: _selected,
              ),
            ),
            if (_selected == _resultType.byArtist)
              AlbumOrderArtist()
            else if (_selected == _resultType.byAlbum)
              AlbumOrderAlbum()
            else if (_selected == _resultType.byGenre)
              AlbumsOfGenre("Hip-Hop"),
            Container(
              color: Colors.white,
              width: double.infinity,
              height: 50,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SearchResultsPage()));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
