import 'package:flutter/material.dart';
import 'package:vinyltrax/returnedData/scrollResults.dart';
import '../show_data/icon.dart';
import '../discogs.dart';

class GetDisArtist extends StatelessWidget {
  final String input;
  GetDisArtist(this.input);

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
                height: MediaQuery.of(context).size.height * 0.0372, //30
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
                  width: MediaQuery.of(context).size.width * 0.1275, //50
                  height: MediaQuery.of(context).size.height * 0.062, //50
                  child: CircularProgressIndicator(),
                )
              ];
            }
            if (children.length > 1) // sizedbox is added after data
              return ScrollResults(children, "Artists");
            else
              return SizedBox();
          },
        ));
  }
}
