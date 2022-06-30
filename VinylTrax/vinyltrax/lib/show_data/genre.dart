import 'package:flutter/material.dart';

class GenreList extends StatelessWidget {
  GenreList({Key? key}) : super(key: key);

  List<ListTile> genreList = [
    ListTile(
      title: Text("Blues"),
      tileColor: Colors.white,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Brass and Military"),
      tileColor: Colors.black12,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Children's"),
      tileColor: Colors.white,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Classical"),
      tileColor: Colors.black12,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Electronic"),
      tileColor: Colors.white,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Folk, World, and Country"),
      tileColor: Colors.black12,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Funk/Soul"),
      tileColor: Colors.white,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Hip-Hop"),
      tileColor: Colors.black12,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Jazz"),
      tileColor: Colors.white,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Latin"),
      tileColor: Colors.black12,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Non-Music"),
      tileColor: Colors.white,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Pop"),
      tileColor: Colors.black12,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Reggae"),
      tileColor: Colors.white,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Rock"),
      tileColor: Colors.black12,
      visualDensity: VisualDensity(vertical: -3),
    ),
    ListTile(
      title: Text("Stage and Screen"),
      tileColor: Colors.white,
      visualDensity: VisualDensity(vertical: -3),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: genreList,
    );
  }
}
