import 'package:flutter/material.dart';
import 'package:vinyltrax/returnedData/scrollResults.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import '../show_data/icon.dart';
import '../discogs.dart';

class DiscogsArtists extends StatelessWidget {
  final String input;
  DiscogsArtists(this.input);

  @override
  Widget build(BuildContext context) {
    Future<List<String>> _results = Collection.getArtists(input);
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
              for (int i = 0; i < snapshot.data!.length; i += 3) {
                var data = [
                  snapshot.data![i],
                  snapshot.data![i + 1],
                  snapshot.data![i + 2],
                ];

                children.add(ShowIcon(
                  data[0],
                  "",
                  data[2],
                  true,
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
            return ScrollResults(children, "Artists");
          },
        ));
  }
}
