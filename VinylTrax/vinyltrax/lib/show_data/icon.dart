import 'package:flutter/material.dart';
import '../pages/nextPage.dart';
import 'package:marquee/marquee.dart';
import '../pages/settingspage.dart' as settings;

// For location:
// 'inv' - Inventory
// 'wish' - Wishlist
// 'discogs' - Discogs
// 'spotify' - Spotify
class ShowIcon extends StatelessWidget {
  final String coverArt;
  final String artistName;
  final String albumName;
  final bool isArtist;
  final String location;
  final String id;

  //const AlbumIcon({Key? key}) : super(key: key);
  ShowIcon({
    this.artistName = "",
    this.albumName = "",
    required this.coverArt,
    required this.isArtist,
    required this.location,
    required this.id,
  });

  Widget buildAnimatedText(
          String text, double fontSize, BuildContext context) =>
      Container(
        height: MediaQuery.of(context).size.height * .0262, //18
        width: MediaQuery.of(context).size.width * .38, //150
        child: Marquee(
          style: TextStyle(
              fontSize: fontSize,
              color: settings.darkTheme ? Colors.white : Colors.black),
          pauseAfterRound: Duration(seconds: 1),
          text: text,
          blankSpace: MediaQuery.of(context).size.width * .0765,
          velocity: 25,
        ),
      );

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.036;
    Widget outputAlb = SizedBox();
    Widget outputArt = SizedBox();

    if (albumName.length > 19)
      outputAlb = buildAnimatedText(albumName, fontSize, context);
    else
      outputAlb = SizedBox(
          width: MediaQuery.of(context).size.width * .38,
          height: MediaQuery.of(context).size.height * .0262,
          child: Text(
            albumName,
            style: TextStyle(
                fontSize: fontSize,
                color: settings.darkTheme ? Colors.white : Colors.black),
            textAlign: TextAlign.center,
          ));

    if (artistName.length > 19)
      outputArt = buildAnimatedText(
          artistName.replaceAll(RegExp(r'\([0-9]+\)'), ""), fontSize, context);
    else
      outputArt = SizedBox(
          width: MediaQuery.of(context).size.width * .38,
          height: MediaQuery.of(context).size.height * .0262,
          child: Text(
            artistName.replaceAll(RegExp(r'\([0-9]+\)'), ""),
            style: TextStyle(
                fontSize: fontSize,
                color: settings.darkTheme ? Colors.white : Colors.black),
            textAlign: TextAlign.center,
          ));

    Widget avatar = SizedBox();
    if (this.isArtist) {
      avatar = CircleAvatar(
          radius: MediaQuery.of(context).size.height * 0.093,
          foregroundImage: NetworkImage(coverArt));
    } else {
      avatar = Container(
        height: MediaQuery.of(context).size.height * 0.18,
        width: MediaQuery.of(context).size.height * 0.18,
        child: Image(
          image: NetworkImage(coverArt),
        ),
      );
    }

    List<Widget> children = [];
    if (artistName == "")
      children = [avatar, outputAlb];
    else
      children = [avatar, outputArt, outputAlb];

    return GestureDetector(
      onTap: () {
        // print(MediaQuery.of(context).size.width);
        // print(MediaQuery.of(context).size.height);
        // print(albumName);
        var route = new MaterialPageRoute(builder: (BuildContext context) {
          if (location == 'inv') {
            if (isArtist)
              return new NextPageArtist(id: id, name: artistName);
            else
              return new NextPageAlbum(id, albumName);
          } else if (location == 'discogs') {
            if (isArtist)
              return new NextPageDisArt(id, artistName);
            else
              return new NextPageDisAlb(id, albumName);
          } else {
            if (isArtist)
              return new NextPageSpotArt(id, artistName);
            else
              return new NextPageSpotAlb(id, albumName);
          }
        });
        Navigator.of(context).push(route);
      },
      child: Column(
        children: children,
      ),
    );
  }
}
