import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../database.dart';
import '../returnedData/albumData.dart';

class AlbumDetailsPage extends StatefulWidget {
  final List<String> input;
  final bool inInventory;
  AlbumDetailsPage(this.input, this.inInventory);

  @override
  State<AlbumDetailsPage> createState() => _AlbumDetailsPageState();
}

class _AlbumDetailsPageState extends State<AlbumDetailsPage> {
  @override
  Widget build(BuildContext context) {
    Future<List<Text>> _results = Database.fullData(widget.input[0]);
    String album = widget.input[1];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(album)
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
                  children.add(Center(
                    child: Container(
                      // COVER ART
                      height: 150,
                      width: 150,
                      child: Image(
                        image: NetworkImage(snapshot.data?[i + 2].data as String),
                      ),
                    ),
                  ));
                  children.add(Center(
                    // ALBUM NAME
                    child: Text(
                      snapshot.data?[i + 1].data as String,
                      style: TextStyle(
                          color: Colors.grey[700]
                      ),
                    ),
                  ));
                  children.add(Center(
                    // ARTIST NAME
                    child: snapshot.data?[i],
                  ));
                  children.add(Center(
                    // GENRE and Year
                    child: Text(
                        (snapshot.data?[i + 3].data as String) + "  •  " + (snapshot.data?[i + 4].data as String)
                    ),
                  ));
                  //All below for tracklist
                  //Starting with the divider
                  children.add(Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Divider(
                      color: Colors.black,
                      thickness: 1,
                      height: 0,
                    ),
                  ));

                  List<ListTile> tracklist = <ListTile>[];
                  List<String> songs = (snapshot.data?[i + 5].data as String).split('\n');
                  for (int i = 0; i < songs.length; i++) {
                    tracklist.add(ListTile(
                      visualDensity: VisualDensity(vertical: -4),
                      title: Text(songs[i],
                      style: TextStyle(
                        fontSize: 12
                      )),
                      tileColor: i.isOdd ? Colors.black12 : Colors.white,
                    ));
                  }
                  children.add(ListView(
                    shrinkWrap: true,
                    children: tracklist,
                  ));
                  children.add(Divider(
                      color: Colors.black,
                      thickness: 1,
                      height: 0,
                  ));
                  children.add(SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: const Text(""),
                  ));
                  if (widget.inInventory) {
                    var _controller = TextEditingController();
                    children.add(Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        maxLength: 500,
                        decoration: InputDecoration(
                            labelText: 'Notes',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: _controller.clear,
                              icon: Icon(Icons.clear),
                            ),
                        ),
                      ),
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
