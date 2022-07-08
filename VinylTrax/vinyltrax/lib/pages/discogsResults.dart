import 'package:flutter/material.dart';
import '../returnedData/disArtists.dart';
import '../returnedData/disAlbums.dart';

class DiscogsResults extends StatelessWidget {
  final String input;
  DiscogsResults(this.input);

  @override
  Widget build(BuildContext context) {
    // late String name = "Artist not found";
    String name = input;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            DiscogsArtists(input),
            DiscogsAlbums(input),
          ],
        ),
      ),
    );
  }
}
