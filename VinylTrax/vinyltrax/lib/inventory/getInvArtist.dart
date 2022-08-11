import 'package:flutter/material.dart';
import 'database.dart';
import '../show_data/listEntry.dart';
import '../pages/staxpage.dart';
import 'package:vinyltrax/pages/settingspage.dart';

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
                  name: snapshot.data![i].toString(),
                  image: snapshot.data![i + 2].toString(),
                  isAlbum: false,
                  id: snapshot.data![i + 1].toString(),
                  location: 'inv',
                  format: input,
                );
                children.add(temp);
              }
              children.insert(
                  0,
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width,
                    color: darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
                    child: Center(
                      child: Text(
                        "Total Number of Artists in Collection: " +
                            children.length.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ));
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
