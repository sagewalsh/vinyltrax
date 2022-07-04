import 'package:flutter/material.dart';
import 'package:vinyltrax/pages/searchresultspage.dart';

class ListEntry extends StatelessWidget {
  String name = "";
  String image = "";
  bool isAlbum = false;
  Color? color = null;
  String artistID = "";
  //const ShowListEntry({Key? key}) : super(key: key);

  ListEntry(String name, String image, bool isAlbum) {
    this.name = name;
    this.image = image;
    this.isAlbum = isAlbum;
  }

  ListEntryArtist(String name, String image, String artistID) {
    this.name = name;
    this.image = image;
    this.artistID = artistID;
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = SizedBox();
    if (!isAlbum) {
      avatar = CircleAvatar(
          foregroundImage: NetworkImage(
              "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg"));
    } else {
      avatar = Container(
        height: 40,
        width: 40,
        child: Image(
          image: NetworkImage(
              "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg"),
        ),
      );
    }

    return ListTile(
      tileColor: color,
      leading: avatar,
      title: Text(name),
      onTap: () {
        var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
                new NextPageArtist(name, artistID));
        Navigator.of(context).push(route);
      },
    );
  }
}

class NextPageArtist extends StatefulWidget {
  //const NextPageArtist({Key? key}) : super(key: key);
  String artistName;
  String artistID;

  NextPageArtist(this.artistName, this.artistID);

  @override
  State<NextPageArtist> createState() => _NextPageArtistState();
}

class _NextPageArtistState extends State<NextPageArtist> {
  @override
  Widget build(BuildContext context) {
    return SearchResultsPage(["${widget.artistID}", "${widget.artistName}"]);
  }
}
