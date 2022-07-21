import 'package:flutter/material.dart';
import 'package:vinyltrax/returnedData/getDisTracks.dart';
import '../returnedData/getDisArtist.dart';
import '../returnedData/getDisAlbum.dart';

class DisResults extends StatelessWidget {
  final String input;
  DisResults(this.input);

  @override
  Widget build(BuildContext context) {
    // late String name = "Artist not found";

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          GetDisArtist(input),
          GetDisAlbum(input),
          GetDisTracks(input),
        ],
      ),
    );
  }
}
