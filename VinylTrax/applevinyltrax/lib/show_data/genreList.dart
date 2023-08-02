import 'package:flutter/material.dart';
import 'package:applevinyltrax/show_data/genreTile.dart';
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
      GenreTile("Blues", format, "assets/genres/Blues.png"),
      GenreTile("Brass and Military", format, "assets/genres/Military.png"),
      GenreTile("Children's", format, "assets/genres/Children.png"),
      GenreTile("Classical", format, "assets/genres/Classical.png"),
      GenreTile("Electronic", format, "assets/genres/Electronic.png"),
      GenreTile("Folk and Country", format, "assets/genres/Country.png"),
      GenreTile("Funk / Soul", format, "assets/genres/Funk.png"),
      GenreTile("Hip Hop", format, "assets/genres/Hip-Hop.png"),
      GenreTile("Jazz", format, "assets/genres/Jazz.png"),
      GenreTile("Latin", format, "assets/genres/Latin.png"),
      GenreTile("Pop", format, "assets/genres/Pop.png"),
      GenreTile("Reggae", format, "assets/genres/Reggae.png"),
      GenreTile("Rock", format, "assets/genres/Rock.png"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: genreList,
    );
  }
}
