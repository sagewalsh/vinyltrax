import 'package:flutter/material.dart';
import '../database.dart';

class AlbumData extends StatelessWidget {
  final String albumid;
  // AlbumData({Key? key}) : super(key: key);
  AlbumData(this.albumid);

  @override
  Widget build(BuildContext context) {
    final Future<List<Text>> _results = Database.fullData(albumid);
    return SizedBox(
      width: double.infinity,
      child: FutureBuilder<List<Text>>(
          future: _results,
          builder: (BuildContext context, AsyncSnapshot<List<Text>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[];
              for (int i = 0; i < snapshot.data!.length; i += 6) {
                children.add(SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: const Text(""),
                ));
                // Cover Art of Album
                children.add(Container(
                  height: 150,
                  width: 150,
                  child: Image(
                      image:
                          NetworkImage(snapshot.data?[i + 2].data as String)),
                ));
                // Name of Album
                children.add(Center(
                  child: snapshot.data?[i],
                ));
                // Name of Artist
                children.add(Center(
                  child: snapshot.data?[i + 1],
                ));
                // Genre
                children.add(Center(
                  child: snapshot.data?[i + 3],
                ));
                // Year
                children.add(Center(
                  child: snapshot.data?[i + 4],
                ));
                // Tracklist
                children.add(Center(
                  child: snapshot.data?[i + 5],
                ));
              }
            } else if (snapshot.hasError) {
              children = <Widget>[
                Icon(Icons.error),
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
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children),
            );
          }),
    );
  }
}
