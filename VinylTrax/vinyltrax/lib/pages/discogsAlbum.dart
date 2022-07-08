import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import '../show_data/icon.dart';
import '../discogs.dart';

class DiscogsAlbum extends StatelessWidget {
  final List<String> input;
  DiscogsAlbum(this.input);

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> _results = Collection.album(input[0]);
    // late String name = "Artist not found";
    String name = input[1];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
            width: double.infinity,
            child: FutureBuilder<List<dynamic>>(
              future: _results,
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[];
                  var data = snapshot.data!;

                  children.add(SizedBox(
                    width: double.infinity,
                    height: 20,
                    child: const Text(""),
                  ));

                  // COVER ART
                  children.add(Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Image(
                        image: NetworkImage(data[6].toString()),
                      ),
                    ),
                  ));

                  // ALBUM NAME
                  children.add(Center(
                    child: Text(
                      data[1].toString(),
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ));

                  // ARTIST NAME
                  String artists = data[0][0][0].toString();
                  for (int i = 1; i < (data[0] as List<dynamic>).length; i++) {
                    artists += " and " + data[0][i][0].toString();
                  }
                  children.add(Center(
                    child: Text(artists),
                  ));

                  // GENRE AND YEAR
                  children.add(Center(
                      child: Text(
                    data[2][0].toString() + "  •  " + data[3].toString(),
                  )));

                  children.add(Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                      height: 0,
                    ),
                  ));

                  // TRACKLIST
                  children.add(const Text("Tracklist"));
                  List<ListTile> tracklist = <ListTile>[];
                  for (int i = 0; i < (data[4] as List<dynamic>).length; i++) {
                    tracklist.add(ListTile(
                      visualDensity: VisualDensity(vertical: -4),
                      leading: Text(
                        data[4][i][0].toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        data[4][i][1],
                        style: TextStyle(fontSize: 12),
                      ),
                      tileColor: i.isOdd ? Colors.black12 : Colors.white,
                    ));
                  }
                  children.add(ListView(
                    shrinkWrap: true,
                    children: tracklist,
                  ));

                  children.add(Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                      height: 0,
                    ),
                  ));

                  // CONTRIBUTORS
                  children.add(const Text("Contributors"));
                  List<ListTile> contributors = <ListTile>[];
                  for (int j = 0; j < (data[5] as List<dynamic>).length; j++) {
                    contributors.add(ListTile(
                      visualDensity: VisualDensity(vertical: -4),
                      title: Text(
                        data[5][j][0].toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        data[5][j][1].toString(),
                        style: TextStyle(fontSize: 12),
                      ),
                      tileColor: j.isOdd ? Colors.black12 : Colors.white,
                    ));
                  }
                  children.add(ListView(
                    shrinkWrap: true,
                    children: contributors,
                  ));

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
                return Column(
                  children: [
                    SizedBox(height: 20),
                    IconList(children),
                  ],
                );
              },
            )),
      ),
    );
  }
}
