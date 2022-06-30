import 'package:flutter/material.dart';
import '../database.dart';

class AlbumsOfGenre extends StatelessWidget {
  final String genre;
  // AlbumsOfGenre({Key? key}) : super(key: key);
  AlbumsOfGenre(this.genre);

  @override
  Widget build(BuildContext context) {
    Future<Text> _results = Database.albumsOrderGenre(genre);
    return SizedBox(
      width: double.infinity,
      child: FutureBuilder<Text>(
          future: _results,
          builder: (BuildContext context, AsyncSnapshot<Text> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                Center(child: snapshot.data),
              ];
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
