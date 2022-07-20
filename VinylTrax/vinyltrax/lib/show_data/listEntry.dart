import 'package:flutter/material.dart';
import '../pages/nextPage.dart';

class ListEntry extends StatelessWidget {
  final String name;
  final String image;
  final bool isAlbum;
  final String artistID;
  final bool isInv;
  final String format;
  Color? color = null;
  //const ShowListEntry({Key? key}) : super(key: key);

  ListEntry({
    required this.name,
    required this.image,
    required this.isAlbum,
    this.artistID = "",
    required this.isInv,
    this.format = "",
  });

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
      title: Text(name.replaceAll(RegExp(r'\([0-9]+\)'), "")),
      onTap: () {
        var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
                new NextPageArtist(id: artistID, name: name, format: format));
        Navigator.of(context).push(route);
      },
    );
  }
}
