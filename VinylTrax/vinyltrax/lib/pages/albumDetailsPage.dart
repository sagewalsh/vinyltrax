import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../database.dart';
import '../returnedData/albumData.dart';

class AlbumDetailsPage extends StatelessWidget {
  final List<String> input;
  AlbumDetailsPage(this.input);

  @override
  Widget build(BuildContext context) {
    Future<List<Text>> _results = Database.fullData(input[0]);
    String album = input[1];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(album),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
            width: double.infinity,
            child: FutureBuilder<List<Text>>(
              future: _results,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Text>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[];
                  // for (int i = 0; i < snapshot.data!.length; i += 5) {
                  int i = 0;
                  children.add(SizedBox(
                    width: double.infinity,
                    height: 20,
                    child: const Text(""),
                  ));
                  children.add(Container(
                    // COVER ART
                    height: 150,
                    width: 150,
                    child: Image(
                      image: NetworkImage(snapshot.data?[i + 2].data as String),
                    ),
                  ));
                  children.add(Center(
                    // ALBUM NAME
                    child: snapshot.data?[i],
                  ));
                  children.add(Center(
                    // ARTIST NAME
                    child: snapshot.data?[i + 1],
                  ));
                  children.add(Center(
                    // GENRE
                    child: snapshot.data?[i + 3],
                  ));
                  children.add(Center(
                    // YEAR
                    child: snapshot.data?[i + 4],
                  ));
                  children.add(Center(
                    // TRACKLIST
                    child: snapshot.data?[i + 5],
                  ));
                  // }
                  children.add(SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: const Text(""),
                  ));
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
                    children: children,
                  ),
                );
              },
            )),
      ),
    );
  }
}
