import 'package:flutter/material.dart';
import '../pages/nextPage.dart';

// For location:
// 'inv' - Inventory
// 'wish' - Wishlist
// 'discogs' - Discogs
// 'spotify' - Spotify
class ListEntry extends StatelessWidget {
  final String name;
  final String image;
  final bool isAlbum;
  final String id;
  final String location;
  final String format;
  //const ShowListEntry({Key? key}) : super(key: key);

  ListEntry({
    required this.name,
    required this.image,
    required this.isAlbum,
    this.id = "",
    required this.location,
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
      tileColor: Color(0xFFFFFEF9),

      // Artist Image
      leading: Container(
        padding: EdgeInsets.only(right: 10),
        child: avatar,
      ),

      // Artist Name
      title: Container(
        padding: EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              name.replaceAll(RegExp(r'\([0-9]+\)'), ""),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color.fromARGB(86, 255, 90, 90),
                    // color: Color.fromARGB(0, 255, 90, 90),
                  ),
                ),
              ),
            )
          ],
        ),
      ),

      // Underline
      subtitle: Container(
        // padding: EdgeInsets.fromLTRB(100, 0, 0, 0),
        child: Text(
          " ",
          style: TextStyle(fontSize: 0),
        ),
      ),

      // Ending Space
      trailing: Container(
        child: SizedBox(
          width: 30,
        ),
      ),

      onTap: () {
        var route = new MaterialPageRoute(builder: (BuildContext context) {
          if (location == 'inv') {
            if (!isAlbum)
              return new NextPageArtist(id: id, name: name);
            else
              return new NextPageAlbum(id, name);
          } else { //location == 'discogs
            if (!isAlbum)
              return new NextPageDisArt(id, name);
            else
              return new NextPageDisAlb(id, name);
          }
        });
        Navigator.of(context).push(route);
      },
    );
  }
}
