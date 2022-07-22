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
      GenreTile("Blues", false, format, "assets/genres/Blues.png"),
      GenreTile(
          "Brass and Military", true, format, "assets/genres/Military.png"),
      GenreTile("Children's", false, format, "assets/genres/Children.png"),
      GenreTile("Classical", true, format, "assets/genres/Classical.png"),
      GenreTile("Electronic", false, format, "assets/genres/Electronic.png"),
      GenreTile(
          "Folk, Work, and Country", true, format, "assets/genres/Country.png"),
      GenreTile("Funk / Soul", false, format, "assets/genres/Funk.png"),
      GenreTile("Hip Hop", true, format, "assets/genres/Hip-Hop.png"),
      GenreTile("Jazz", false, format, "assets/genres/Jazz.png"),
      GenreTile("Latin", true, format, "assets/genres/Latin.png"),
      GenreTile("Non-Music", false, format, "assets/genres/Non-music.png"),
      GenreTile("Pop", true, format, "assets/genres/Pop.png"),
      GenreTile("Reggae", false, format, "assets/genres/Reggae.png"),
      GenreTile("Rock", true, format, "assets/genres/Rock.png"),
      GenreTile(
          "Stage and Screen", false, format, "assets/genres/StageScreen.png"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: genreList,
    );
  }
}
