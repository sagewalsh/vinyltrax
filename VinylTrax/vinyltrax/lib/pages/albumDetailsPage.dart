import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../database.dart';
import '../buttons/addAlbumPopUp.dart';

class AlbumDetailsPage extends StatefulWidget {
  final List<String> input;
  final bool inInventory;

  AlbumDetailsPage(this.input, this.inInventory);

  @override
  State<AlbumDetailsPage> createState() => _AlbumDetailsPageState();
}

class _AlbumDetailsPageState extends State<AlbumDetailsPage> {
  late String locationValue;
  late String format;

  @override
  Widget build(BuildContext context) {
    Future<List<Text>> _results;
    if (widget.inInventory)
      _results = Database.fullData(widget.input[0]);
    else
      _results = Database.fullData(widget.input[0]); //replace this with discogs info
    String album = widget.input[1];
    var _controller = TextEditingController();
    Widget temp = SizedBox();

    if (!widget.inInventory) {
      temp = TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddAlbumPopUp(_results);
              },
            );
           // addToButton(context);
          },
          child: Text(
            "Add",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18
            ),
          )
      );
    }

    // [0] artist name
    // [1] album name
    // [2] album cover
    // [3] genre
    // [4] year
    // [5] tracklist (on a single string, it is parsed here)

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(album),
        actions: [temp],
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
                        image: NetworkImage(snapshot.data?[i + 2]
                            .data as String),
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
                        (snapshot.data?[i + 3].data as String) + "  •  " +
                            (snapshot.data?[i + 4].data as String)
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

                  // Assuming the tracklist is one string, below will parse through it
                  List<ListTile> tracklist = <ListTile>[];
                  List<String> songs = (snapshot.data?[i + 5].data as String)
                      .split('\n');
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

                  //Notes section
                  if (widget.inInventory) {
                    children.add(Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        maxLength: 500,
                        onSubmitted: (value) {
                          //value here is the text after enter is pressed
                          //within here you can add it to the database
                          print(value);
                        },
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
                    Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
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
