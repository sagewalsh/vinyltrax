import 'package:flutter/material.dart';

class AlbumIcon extends StatelessWidget {
  String coverArt = "";
  String artistName = "";
  String albumName = "";
  //const AlbumIcon({Key? key}) : super(key: key);
  AlbumIcon(this.artistName, this.albumName, this.coverArt);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          height: 150,
          width: 150,
          image: NetworkImage("https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg"),
        ),
        Text(artistName),
        Text(albumName),
      ],
    );
  }
}

