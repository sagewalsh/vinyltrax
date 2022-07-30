import 'package:flutter/material.dart';
import 'package:vinyltrax/inventory/invCon.dart';
import '../inventory/invDetails.dart';
import '../inventory/InvAlbumsBy.dart';
import '../discogs/disAlbumsBy.dart';
import '../discogs/disDetails.dart';
import '../spotify/spotAlByPage.dart';
import '../spotify/spotDetails.dart';

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
Clicked a Contributor in Invetory
##########################################################################
*/
class NextPageCon extends StatefulWidget {
  final String id, name, format;

  NextPageCon({required this.id, required this.name, this.format = "All"});
  @override
  State<NextPageCon> createState() => _NextPageConState();
}

class _NextPageConState extends State<NextPageCon> {
  @override
  Widget build(BuildContext context) {
    return InvCon(["${widget.id}", "${widget.name}"]);
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
    return DisDetails(["${widget.id}", "${widget.name}"], false);
  }
}

/*
##########################################################################
Clicked an Artist in Spotify
##########################################################################
*/
class NextPageSpotArt extends StatefulWidget {
  final String id, name;

  NextPageSpotArt(this.id, this.name);
  @override
  State<NextPageSpotArt> createState() => _NextSpotArtState();
}

class _NextSpotArtState extends State<NextPageSpotArt> {
  @override
  Widget build(BuildContext context) {
    return SpotAlByPage(["${widget.id}", "${widget.name}"]);
  }
}

/*
##########################################################################
Clicked an Album in Spotify
##########################################################################
*/
class NextPageSpotAlb extends StatefulWidget {
  final String id, name;

  NextPageSpotAlb(this.id, this.name);
  @override
  State<NextPageSpotAlb> createState() => _NextSpotAlbState();
}

class _NextSpotAlbState extends State<NextPageSpotAlb> {
  @override
  Widget build(BuildContext context) {
    return SpotDetails(["${widget.id}", "${widget.name}"], "text");
  }
}
