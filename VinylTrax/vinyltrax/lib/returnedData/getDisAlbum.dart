import 'package:flutter/material.dart';
import 'package:vinyltrax/returnedData/scrollResults.dart';
import '../show_data/icon.dart';
import '../discogs.dart';
import '../pages/settingspage.dart' as settings;
import '../show_data/listEntry.dart';
import '../show_data/listEntryList.dart';

class GetDisAlbum extends StatelessWidget {
  final String input;
  GetDisAlbum(this.input);
  int max = 1;

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
              for (int i = 0; i < snapshot.data!.length; i += 4) {
                var data = [
                  snapshot.data![i],
                  snapshot.data![i + 1],
                  snapshot.data![i + 2],
                  snapshot.data![i + 3],
                ];
                var artist_album = data[0].split(" - ");
                if (settings.listBool) {
                  children.add(ListEntry(
                    name: artist_album[1],
                    image: data[3],
                    isAlbum: true,
                    location: 'discogs',
                    id: data[1],
                  ));
                }
                else {
                  if (max <= 10) {
                    children.add(ShowIcon(
                      artistName: artist_album[0],
                      albumName: artist_album[1],
                      coverArt: data[3],
                      isArtist: false,
                      location: 'discogs',
                      id: data[1],
                    ));
                    max++;
                  }
                }
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
                  width: MediaQuery.of(context).size.width * 0.1275, //50
                  height: MediaQuery.of(context).size.height * 0.062, //50
                  child: CircularProgressIndicator(),
                )
              ];
            }
            max = 1;
            if (children.length > 1) // sizedbox is added after data
              if (!settings.listBool)
                return ScrollResults(children, "Albums", snapshot);
              else
                return ListEntryList(children);
            else
              return Text("None");
          },
        ));
  }
}
