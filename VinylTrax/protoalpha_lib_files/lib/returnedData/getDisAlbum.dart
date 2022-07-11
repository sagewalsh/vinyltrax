import 'package:flutter/material.dart';
import 'package:vinyltrax/returnedData/scrollResults.dart';
import '../show_data/icon.dart';
import '../discogs.dart';

class GetDisAlbum extends StatelessWidget {
  final String input;
  GetDisAlbum(this.input);

  @override
  Widget build(BuildContext context) {
    Future<List<String>> _results = Collection.getAlbums(input);
    // late String name = "Artist not found";

    return SizedBox(
        width: double.infinity,
        child: FutureBuilder<List<String>>(
          future: _results,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[];
              if (snapshot.data!.length == 0) {
                children.add(Text("No Albums Found with the Name: " + input));
              }
              for (int i = 0; i < snapshot.data!.length; i += 4) {
                var data = [
                  snapshot.data![i],
                  snapshot.data![i + 1],
                  snapshot.data![i + 2],
                  snapshot.data![i + 3],
                ];
                var artist_album = data[0].split(" - ");
                children.add(ShowIcon(
                  artist_album[0],
                  artist_album[1],
                  data[3],
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
            return ScrollResults(children, "Albums");
          },
        ));
  }
}
