import 'package:flutter/material.dart';
import 'package:vinyltrax/returnedData/scrollResults.dart';
import '../show_data/icon.dart';
import '../discogs.dart';
import '../pages/settingspage.dart' as settings;
import '../show_data/listEntry.dart';
import '../show_data/listEntryList.dart';

class GetDisArtist extends StatelessWidget {
  final String input;
  GetDisArtist(this.input);
  int max = 1;

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
                if (settings.listBool) {
                  children.add(ListEntry(
                    name: data[0],
                    image: data[2],
                    isAlbum: false,
                    isInv: false,
                  ));
                }
                else {
                  if (max <= 10) {
                    children.add(ShowIcon(
                      artistName: data[0],
                      coverArt: data[2],
                      isArtist: true,
                      isInv: false,
                      id: data[1],
                    ));
                    max++;
                  }
                }
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
            max = 1;
            if (children.length > 1) // sizedbox is added after data
              if (!settings.listBool)
                return ScrollResults(children, "Artists", snapshot);
              else
                return ListEntryList(children);
            else
              return Text("None");
          },
        ));
  }
}
