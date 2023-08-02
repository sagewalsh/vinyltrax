import 'package:flutter/material.dart';
import 'package:applevinyltrax/spotify/spotDetails.dart';

class CameraResults extends StatelessWidget {
  final String results;

  CameraResults(this.results);

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: Color(0xFFFFFEF9),
    //   appBar: AppBar(
    //     title: Text(results),
    //     leading: BackButton(color: Colors.black),
    //   ),
    //   body: SpotifyResults(results, "None"),
    // );
    return SpotDetails([results], "scan");
  }
}
