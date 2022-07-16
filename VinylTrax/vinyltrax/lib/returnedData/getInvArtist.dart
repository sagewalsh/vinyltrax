import 'package:flutter/material.dart';
import '../database.dart';
import '../show_data/listEntry.dart';
import '../show_data/listEntryList.dart';
import '../pages/staxpage.dart';

class GetInvArtist extends StatelessWidget {
  final Type genre;
  GetInvArtist(this.genre);

  @override
  Widget build(BuildContext context) {
    // Set input genre
    String input = "All";
    if (genre == Type.vinyl)
      input = "Vinyl";
    else if (genre == Type.cd) input = "CD";

    // Get artists from the database
    final Future<List<dynamic>> _results = Database.artists(input);

    //Widgets to be displayed
    List<Widget> children = <Widget>[];

    return SizedBox(
      width: double.infinity,
      child: FutureBuilder<List<dynamic>>(
          future: _results,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            List<Widget> children = <Widget>[];
            if (snapshot.hasData) {
              for (int i = 0; i < snapshot.data!.length; i += 3) {
                ListEntry temp = ListEntry(
                  snapshot.data![i].toString(),
                  snapshot.data![i + 2].toString(),
                  false,
                );
                temp.artistID = snapshot.data![i + 1].toString();
                if (children.length % 2 != 0) temp.color = Color(0x20FF5A5A);
                children.add(temp);
              }
            } else if (snapshot.hasError) {
              children = <Widget>[
                Icon(Icons.error),
              ];
            } else {
              children = <Widget>[
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1275, //50
                    height: MediaQuery.of(context).size.height * 0.062, //50
                    child: CircularProgressIndicator(),
                  ),
                )
              ];
            }
            return ListEntryList(children);
          }),
    );
  }
}
