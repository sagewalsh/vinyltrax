import 'package:flutter/material.dart';
import '../database.dart';
import '../show_data/icon.dart';
import '../show_data/iconList.dart';

class AlbumOrderAlbum extends StatelessWidget {
  AlbumOrderAlbum({Key? key}) : super(key: key);

  final Future<List<Text>> _results = Database.displayByName();
  List<Widget> children = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FutureBuilder<List<Text>>(
          future: _results,
          builder: (BuildContext context, AsyncSnapshot<List<Text>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                // Center(child: snapshot.data?[0]),
                // Center(child: snapshot.data?[1]),
              ];
              for (int i = 0; i < snapshot.data!.length; i += 4) {
                children.add(ShowIcon(
                    snapshot.data?[i + 1].data as String,
                    snapshot.data?[i].data as String,
                    snapshot.data?[i + 2].data as String,
                    false,
                    snapshot.data?[i + 3].data as String));
              }
            } else if (snapshot.hasError) {
              children = <Widget>[
                Icon(Icons.error),
              ];
            } else {
              children = <Widget>[
                Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                )
              ];
            }
            return IconList(children);
          }),
    );
  }
}
