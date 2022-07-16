import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/genreTile.dart';
import '../pages/staxpage.dart';

class GenreList extends StatelessWidget {
  final Type input;
  late String format;
  late List<GenreTile> genreList;
  // GenreList({Key? key}) : super(key: key);
  GenreList(this.input) {
    if (input == Type.vinyl) {
      format = "Vinyl";
    } else if (input == Type.cd) {
      format = "CD";
    } else {
      format = "All";
    }
    genreList = [
      GenreTile("Blues", false, format),
      GenreTile("Brass and Military", true, format),
      GenreTile("Children's", false, format),
      GenreTile("Classical", true, format),
      GenreTile("Electronic", false, format),
      GenreTile("Folk, Work, and Country", true, format),
      GenreTile("Funk / Soul", false, format),
      GenreTile("Hip-Hop", true, format),
      GenreTile("Jazz", false, format),
      GenreTile("Latin", true, format),
      GenreTile("Non-Music", false, format),
      GenreTile("Pop", true, format),
      GenreTile("Reggae", false, format),
      GenreTile("Rock", true, format),
      GenreTile("Stage and Screen", false, format),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: genreList,
    );
  }
}
