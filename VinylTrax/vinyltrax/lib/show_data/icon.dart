import 'package:flutter/material.dart';

class ShowIcon extends StatelessWidget {
  final String coverArt;
  final String artistName;
  final String albumName;
  final bool isAlbum;
  //const AlbumIcon({Key? key}) : super(key: key);
  ShowIcon(this.artistName, this.albumName, this.coverArt, this.isAlbum);

  @override
  Widget build(BuildContext context) {
    BoxShape shapeChoice = BoxShape.rectangle;

    if (!isAlbum)
      shapeChoice = BoxShape.circle;

    return Column(
      children: [
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            shape: shapeChoice,
            image: DecorationImage(
              image: NetworkImage("https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg")
            ),
          ),
        ),
        Text(artistName),
        Text(albumName),
      ],
    );
  }
}

