import 'package:flutter/material.dart';

class AlbumDetails extends StatefulWidget {
  final String coverArt;
  final String artistName;
  final String albumName;

  AlbumDetails(this.albumName, this.artistName, this.coverArt);
  @override
  State<AlbumDetails> createState() => _AlbumDetailsState();
}

class _AlbumDetailsState extends State<AlbumDetails> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
