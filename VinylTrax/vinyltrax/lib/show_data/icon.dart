import 'package:flutter/material.dart';
import '../pages/albumDetailsPage.dart';
import '../pages/searchresultspage.dart';

class ShowIcon extends StatelessWidget {
  final String coverArt;
  String artistName;
  String albumName;
  final bool isArtist;
  String id;
  //const AlbumIcon({Key? key}) : super(key: key);
  ShowIcon(
      this.artistName, this.albumName, this.coverArt, this.isArtist, this.id);

  @override
  Widget build(BuildContext context) {
    String outputAlb = albumName;
    String outputArt = artistName;

    if (albumName.length > 20) outputAlb = albumName.substring(0, 17) + "...";

    if (artistName.length > 20) outputArt = artistName.substring(0, 17) + "...";

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
          Text(outputArt),
          Text(outputAlb),
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
