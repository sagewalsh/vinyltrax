import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/genreTile.dart';

class GenreList extends StatelessWidget {
  GenreList({Key? key}) : super(key: key);

  List<GenreTile> genreList = [
    GenreTile("Blues", false),
    GenreTile("Brass and Military", true),
    GenreTile("Children's", false),
    GenreTile("Classical", true),
    GenreTile("Electronic", false),
    GenreTile("Folk, Work, and Country", true),
    GenreTile("Funk / Soul", false),
    GenreTile("Hip-Hop", true),
    GenreTile("Jazz", false),
    GenreTile("Latin", true),
    GenreTile("Non-Music", false),
    GenreTile("Pop", true),
    GenreTile("Reggae", false),
    GenreTile("Rock", true),
    GenreTile("Stage and Screen", false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: genreList,
    );
  }
}
