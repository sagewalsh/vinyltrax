import 'package:flutter/material.dart';
import '../pages/nextPage.dart';
import 'package:marquee/marquee.dart';

class ShowIcon extends StatelessWidget {
  final String coverArt;
  final String artistName;
  final String albumName;
  final bool isArtist;
  final bool isInv;
  final String id;

  //const AlbumIcon({Key? key}) : super(key: key);
  ShowIcon({
    this.artistName = "",
    this.albumName = "",
    required this.coverArt,
    required this.isArtist,
    required this.isInv,
    required this.id,
  });

  Widget buildAnimatedText(String text, BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * .0262, //18
        width: MediaQuery.of(context).size.width * .38, //150
        child: Marquee(
          pauseAfterRound: Duration(seconds: 1),
          text: text,
          blankSpace: MediaQuery.of(context).size.width * .0765,
          velocity: 25,
        ),
      );

  @override
  Widget build(BuildContext context) {
    Widget outputAlb = SizedBox();
    Widget outputArt = SizedBox();

    if (albumName.length > 19)
      outputAlb = buildAnimatedText(albumName, context);
    else
      outputAlb = SizedBox(
          width: MediaQuery.of(context).size.width * .38,
          height: MediaQuery.of(context).size.height * .0262,
          child: Text(
            albumName,
            textAlign: TextAlign.center,
          ));

    if (artistName.length > 19)
      outputArt = buildAnimatedText(
          artistName.replaceAll(RegExp(r'\([0-9]+\)'), ""), context);
    else
      outputArt = SizedBox(
          width: MediaQuery.of(context).size.width * .38,
          height: MediaQuery.of(context).size.height * .0262,
          child: Text(
            artistName.replaceAll(RegExp(r'\([0-9]+\)'), ""),
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
          if (isInv) {
            if (isArtist)
              return new NextPageArtist(id: id, name: artistName);
            else
              return new NextPageAlbum(id, albumName);
          } else {
            if (isArtist)
              return new NextPageDisArt(id, artistName);
            else
              return new NextPageDisAlb(id, albumName);
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
