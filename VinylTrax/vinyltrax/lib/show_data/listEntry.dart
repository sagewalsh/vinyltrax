import 'package:flutter/material.dart';
import 'package:vinyltrax/pages/invAlbumsBy.dart';
import '../pages/nextPage.dart';

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
      avatar = CircleAvatar(foregroundImage: NetworkImage(image));
    } else {
      avatar = Container(
        height: MediaQuery.of(context).size.height * 0.049689,
        width: MediaQuery.of(context).size.width * .102,
        child: Image(
          image: NetworkImage(image),
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
                new NextPageArtist(artistID, name));
        Navigator.of(context).push(route);
      },
    );
  }
}
