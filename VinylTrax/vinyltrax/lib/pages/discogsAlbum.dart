import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import '../buttons/addAlbumPopUp.dart';
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

    Widget addBlackLine() {
      return Padding(
        padding: const EdgeInsets.only(top: 8, left: 5, right: 5),
        child: Divider(
          color: Colors.black,
          thickness: 1,
          height: 0,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFFFEF9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFEF9),
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          name,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddAlbumPopUp(_results, input[0]);
                  },
                );
                // addToButton(context);
              },
              child: Text(
                "Add",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ))
        ],
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

                  children.add(SizedBox(height: 30));

                  // TRACKLIST
                  children.add(Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text("Tracklist", style: TextStyle(fontSize: 17)),
                  ));
                  children.add(addBlackLine());
                  List<ListTile> tracklist = <ListTile>[];
                  for (int i = 0; i < (data[4] as List<dynamic>).length; i++) {
                    tracklist.add(ListTile(
                      visualDensity: VisualDensity(vertical: -4),
                      leading: Text(
                        data[4][i][0].toString(),
                        style: TextStyle(fontSize: 13),
                      ),
                      trailing: Text(
                        data[4][i][1],
                        style: TextStyle(fontSize: 13),
                      ),
                      tileColor: i.isOdd ? Color(0x20FF5A5A) : Colors.white,
                    ));
                  }
                  children.add(ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: tracklist,
                  ));

                  children.add(SizedBox(height: 30));

                  // CONTRIBUTORS
                  children.add(Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text("Contributors", style: TextStyle(fontSize: 17)),
                  ));
                  children.add(addBlackLine());
                  List<ListTile> contributors = <ListTile>[];
                  for (int j = 0; j < (data[5] as List<dynamic>).length; j++) {
                    contributors.add(ListTile(
                      visualDensity: VisualDensity(vertical: -4),
                      title: Text(
                        data[5][j][0].toString(),
                        style: TextStyle(fontSize: 13),
                      ),
                      subtitle: Text(
                        data[5][j][1].toString(),
                        style: TextStyle(fontSize: 13),
                      ),
                      tileColor: j.isOdd ? Color(0x20FF5A5A) : Colors.white,
                    ));
                  }
                  children.add(ListView(
                    physics: NeverScrollableScrollPhysics(),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                );
              },
            )),
      ),
    );
  }
}
