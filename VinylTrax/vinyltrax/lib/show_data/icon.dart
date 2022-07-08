import 'package:flutter/material.dart';
import '../pages/albumDetailsPage.dart';
import '../pages/searchresultspage.dart';
import '../pages/discogsArtist.dart';
import '../pages/discogsAlbum.dart';
import 'package:marquee/marquee.dart';

class ShowIcon extends StatelessWidget {
  final String coverArt;
  final String artistName;
  final String albumName;
  final bool isArtist;
  final bool isInv;
  final String id;
  //const AlbumIcon({Key? key}) : super(key: key);
  ShowIcon(this.artistName, this.albumName, this.coverArt, this.isArtist,
      this.isInv, this.id);

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

    if (albumName.length > 18)
      outputAlb = buildAnimatedText(albumName);
    else
      outputAlb = SizedBox(
          width: 150,
          height: 18,
          child: Text(
            albumName,
            textAlign: TextAlign.center,
          ));

    if (artistName.length > 18)
      outputArt = buildAnimatedText(artistName);
    else
      outputArt = SizedBox(
          width: 150,
          height: 18,
          child: Text(
            artistName,
            textAlign: TextAlign.center,
          ));

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
        // print(albumName);
        var route = new MaterialPageRoute(builder: (BuildContext context) {
          if (isInv) {
            if (isArtist)
              return new NextPageArtist(id, artistName);
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
        children: [avatar, outputArt, outputAlb],
      ),
    );
  }
}

/*
##########################################################################
Clicked an Album in Inventory
##########################################################################
*/
class NextPageAlbum extends StatefulWidget {
  final String id, name;

  NextPageAlbum(this.id, this.name);
  @override
  State<NextPageAlbum> createState() => _NextPageAlbumState();
}

class _NextPageAlbumState extends State<NextPageAlbum> {
  @override
  Widget build(BuildContext context) {
    return AlbumDetailsPage(["${widget.id}", "${widget.name}"]);
  }
}

/*
##########################################################################
Clicked an Artist in Invetory
##########################################################################
*/
class NextPageArtist extends StatefulWidget {
  final String id, name;

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

/*
##########################################################################
Clicked an Artist in Discogs
##########################################################################
*/
class NextPageDisArt extends StatefulWidget {
  final String id, name;

  NextPageDisArt(this.id, this.name);
  @override
  State<NextPageDisArt> createState() => _NextDisArtState();
}

class _NextDisArtState extends State<NextPageDisArt> {
  @override
  Widget build(BuildContext context) {
    return DiscogsArtist(["${widget.id}", "${widget.name}"]);
  }
}

/*
##########################################################################
Clicked an Album in Discogs
##########################################################################
*/
class NextPageDisAlb extends StatefulWidget {
  final String id, name;

  NextPageDisAlb(this.id, this.name);
  @override
  State<NextPageDisAlb> createState() => _NextDisAlbState();
}

class _NextDisAlbState extends State<NextPageDisAlb> {
  @override
  Widget build(BuildContext context) {
    return DiscogsAlbum(["${widget.id}", "${widget.name}"]);
  }
}
