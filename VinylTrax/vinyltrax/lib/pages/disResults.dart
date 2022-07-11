import 'package:flutter/material.dart';
import '../returnedData/getDisArtist.dart';
import '../returnedData/getDisAlbum.dart';

class DisResults extends StatelessWidget {
  final String input;
  DisResults(this.input);

  @override
  Widget build(BuildContext context) {
    // late String name = "Artist not found";
    String name = input;

    return Scaffold(
      backgroundColor: Color(0xFFFFFEF9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFEF9),
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          name,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            GetDisArtist(input),
            GetDisAlbum(input),
          ],
        ),
      ),
    );
  }
}
