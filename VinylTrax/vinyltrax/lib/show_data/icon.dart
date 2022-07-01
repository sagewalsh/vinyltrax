import 'package:flutter/material.dart';

class ShowIcon extends StatelessWidget {
  final String coverArt;
  String artistName;
  String albumName;
  final bool isAlbum;
  //const AlbumIcon({Key? key}) : super(key: key);
  ShowIcon(this.artistName, this.albumName, this.coverArt, this.isAlbum);

  @override
  Widget build(BuildContext context) {
    String outputAlb = albumName;
    String outputArt = artistName;

    if (albumName.length > 20)
      outputAlb = albumName.substring(0, 18) + "...";

    if (artistName.length > 20)
      outputArt = artistName.substring(0, 18) + "...";

    Widget avatar = SizedBox();
    if (isAlbum) {
      avatar = CircleAvatar(
        radius: 75,
          foregroundImage: NetworkImage(
              "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg"
          )
      );
    }
    else {
      avatar = Container(
        height: 150,
        width: 150,
        child: Image(
          image: NetworkImage(
              "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg"
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        print(albumName);
      },
      child: Column(
        children: [
          avatar,
          Text(outputArt),
          Text(outputAlb),
        ],
      ),
    );
  }
}

