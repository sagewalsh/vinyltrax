import 'package:flutter/material.dart';
import '../pages/albumDetailsPage.dart';
import '../pages/searchresultspage.dart';
import 'package:marquee/marquee.dart';

class ShowIcon extends StatelessWidget {
  final String coverArt;
  String artistName;
  String albumName;
  final bool isArtist;
  String id;
  //const AlbumIcon({Key? key}) : super(key: key);
  ShowIcon(
      this.artistName, this.albumName, this.coverArt, this.isArtist, this.id);

  Widget buildAnimatedText(String text) => Container(
    height: 18,
    width: 150,
    child: Marquee(
      text: text,
      blankSpace: 30,
      velocity: 30,
    ),
  );

  @override
  Widget build(BuildContext context) {
    Widget outputAlb = SizedBox();
    Widget outputArt = SizedBox();

    if (albumName.length > 17)
      outputAlb = buildAnimatedText(albumName);
    else
      outputAlb = SizedBox(
          width: 150,
          height: 18,
          child: Text(
            albumName,
            textAlign: TextAlign.center,
          )
      );

    if (artistName.length > 17)
      outputArt = buildAnimatedText(artistName);
    else
      outputArt = SizedBox(
          width: 150,
          height: 18,
          child: Text(
            artistName,
            textAlign: TextAlign.center,
          )
      );

    Widget avatar = SizedBox();
    if (this.isArtist) {
      avatar =
          CircleAvatar(radius: 75, foregroundImage: NetworkImage(coverArt));
    } else {
      avatar = Container(
        height: 150,
        width: 150,
        child: Image(
          image: NetworkImage(coverArt),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        print(albumName);
        var route = new MaterialPageRoute(builder: (BuildContext context) {
          if (isArtist)
            return new NextPageArtist(id, artistName);
          else
            return new NextPageAlbum(id, albumName);
        });
        Navigator.of(context).push(route);
      },
      child: Column(
        children: [
          avatar,
          outputArt,
          outputAlb
        ],
      ),
    );
  }
}

class NextPageAlbum extends StatefulWidget {
  String id;
  String name;

  NextPageAlbum(this.id, this.name);
  @override
  State<NextPageAlbum> createState() => _NextPageAlbumState();
}

class _NextPageAlbumState extends State<NextPageAlbum> {
  @override
  Widget build(BuildContext context) {
    return AlbumDetailsPage(["${widget.id}", "${widget.name}"], false);
  }
}

class NextPageArtist extends StatefulWidget {
  String id, name;

  NextPageArtist(this.id, this.name);
  @override
  State<NextPageArtist> createState() => _NextPageArtistState();
}

class _NextPageArtistState extends State<NextPageArtist> {
  @override
  Widget build(BuildContext context) {
    return SearchResultsPage(["${widget.id}", "${widget.name}"]);
  }
}
