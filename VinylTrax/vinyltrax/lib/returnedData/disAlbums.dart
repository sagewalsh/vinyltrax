import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import '../show_data/icon.dart';
import '../discogs.dart';

class DiscogsAlbums extends StatelessWidget {
  final String input;
  DiscogsAlbums(this.input);

  @override
  Widget build(BuildContext context) {
    Future<List<String>> _results = Collection.getAlbums(input);
    // late String name = "Artist not found";
    String name = input;

    return SizedBox(
        width: double.infinity,
        child: FutureBuilder<List<String>>(
          future: _results,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[];
              for (int i = 0; i < snapshot.data!.length; i += 3) {
                var data = [
                  snapshot.data![i],
                  snapshot.data![i + 1],
                  snapshot.data![i + 2],
                ];
                var artist_album = data[0].split(" - ");
                children.add(ShowIcon(
                  artist_album[0],
                  artist_album[1],
                  "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
                  false,
                  false,
                  data[1],
                ));
              }
              children.add(SizedBox(
                width: double.infinity,
                height: 30,
                child: const Text(""),
              ));
            } else if (snapshot.hasError) {
              children = <Widget>[
                Icon(Icons.error),
                Text("Snapshot has error"),
              ];
            } else {
              children = <Widget>[
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                )
              ];
            }
            return Column(
              children: [
                SizedBox(height: 20),
                IconList(children),
              ],
            );
          },
        ));
  }
}
