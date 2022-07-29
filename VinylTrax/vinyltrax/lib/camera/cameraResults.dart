import 'package:flutter/material.dart';

import '../spotify/spotifyResults.dart';

class CameraResults extends StatelessWidget {
  String results;

  CameraResults(this.results);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFEF9),
      appBar: AppBar(
        title: Text(results),
        leading: BackButton(color: Colors.black),
      ),
      body: SpotifyResults(results, "None"),
    );
  }
}
