import 'package:flutter/material.dart';
import 'invDetails.dart';
import 'invAlbumsBy.dart';
import 'disAlbumsBy.dart';
import 'disDetails.dart';

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
    return InvDetails(["${widget.id}", "${widget.name}"]);
  }
}

/*
##########################################################################
Clicked an Artist in Invetory
##########################################################################
*/
class NextPageArtist extends StatefulWidget {
  final String id, name, format;

  NextPageArtist({required this.id, required this.name, this.format = "All"});
  @override
  State<NextPageArtist> createState() => _NextPageArtistState();
}

class _NextPageArtistState extends State<NextPageArtist> {
  @override
  Widget build(BuildContext context) {
    return InvAlbumsBy(["${widget.id}", "${widget.name}", "${widget.format}"]);
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
    return DisAlbumsBy(["${widget.id}", "${widget.name}"]);
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
    return DisDetails(["${widget.id}", "${widget.name}"]);
  }
}
