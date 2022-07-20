import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../database.dart';

class InvDetails extends StatefulWidget {
  final List<String> input;

  InvDetails(this.input);

  @override
  State<InvDetails> createState() => _InvDetails();
}

class _InvDetails extends State<InvDetails> {
  late String locationValue;
  late String format;

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> _results =
        Database.albumDetails(widget.input[0]); //replace this with discogs info
    String album = widget.input[1];
    var _controller = TextEditingController();

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

    Widget title = Text(
      album,
      style: TextStyle(
        color: Colors.black,
      ),
    );

    if (album.length > 22) {
      title = Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Marquee(
          velocity: 20,
          blankSpace: 30,
          text: album,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );
    }

    Widget extendedName = Center(
      child: Text(
        album,
        style: TextStyle(
          color: Colors.grey[700],
        ),
      ),
    );

    if (album.length > 45) {
      extendedName = Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 20,
            child: Marquee(
              velocity: 10,
              blankSpace: 100,
              text: album,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFEF9),
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFEF9),
          leading: BackButton(
            color: Colors.black,
          ),
          title: title,
          actions: [
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Removal?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  // Remove album from inventory
                                  Database.removeAlbum(widget.input[0]);

                                  //below will take you back two pages, to the album page
                                  Navigator.pushNamed(context, 'inven');
                                },
                                child: Text("Yes")),
                            SizedBox(width: 20),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context); //returns user back to page
                                },
                                child: Text("No")),
                          ],
                        ),
                      );
                    });
              },
              child: Text("Remove", style: TextStyle(color: Colors.black)),
            )
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
                    if (data[6] != null) {
                      children.add(Center(
                        child: Container(
                          height: MediaQuery.of(context).size.width *
                              .38, //150 square
                          width: MediaQuery.of(context).size.width * .38,
                          child: Image(
                            image: NetworkImage(data[6].toString()),
                          ),
                        ),
                      ));
                    }

                    // ALBUM NAME
                    if (data[1] != null) {
                      children.add(extendedName);
                    }

                    // ARTIST NAME
                    if (data[0] != null) {
                      var artists = <TextSpan>[];
                      int size = (data[0] as List<dynamic>).length;
                      for (int i = 0; i < size; i++) {
                        artists.add(
                          TextSpan(
                            text: data[0][i][0]
                                .toString()
                                .replaceAll(RegExp(r'\([0-9]+\)'), ""),
                            // recognizer: TapGestureRecognizer()
                            //   ..onTap = (() {
                            //     var route = new MaterialPageRoute(
                            //         builder: (BuildContext context) {
                            //       return new NextPageDisArt(
                            //           data[0][i][1].toString(),
                            //           data[0][i][0].toString());
                            //     });
                            //     Navigator.of(context).push(route);
                            //   }),
                            style: TextStyle(
                              color: Colors.black,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                        );
                        if (i + 1 < size) {
                          artists.add(TextSpan(
                            text: " & ",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ));
                        }
                      }
                      children.add(
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: artists,
                            ),
                          ),
                        ),
                      );
                    }

                    // GENRE AND YEAR
                    if (data[2] != null && data[3] != null && data[3] != 0) {
                      children.add(Center(
                          child: Text(
                        data[2][0].toString() + "  •  " + data[3].toString(),
                      )));
                    } else if (data[2] != null) {
                      children.add(Center(
                        child: Text(data[2][0].toString()),
                      ));
                    } else if (data[3] != null && data[3] != 0) {
                      children.add(Center(
                        child: Text(data[3].toString()),
                      ));
                    }

                    children.add(SizedBox(height: 30));

                    // TRACKLIST
                    if (data[4] != null) {
                      children.add(Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child:
                            Text("Tracklist", style: TextStyle(fontSize: 17)),
                      ));
                      children.add(addBlackLine());
                      List<ListTile> tracklist = <ListTile>[];
                      for (int i = 0;
                          i < (data[4] as List<dynamic>).length;
                          i++) {
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
                    }

                    // CONTRIBUTORS
                    if (data[5] != null) {
                      children.add(Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text("Contributors",
                            style: TextStyle(fontSize: 17)),
                      ));
                      children.add(addBlackLine());
                      List<ListTile> contributors = <ListTile>[];
                      for (int j = 0;
                          j < (data[5] as List<dynamic>).length;
                          j++) {
                        contributors.add(ListTile(
                          visualDensity: VisualDensity(vertical: -4),
                          // Contributor name
                          title: Text(
                            data[5][j][0]
                                .toString()
                                .replaceAll(RegExp(r'\([0-9]+\)'), ""),
                            style: TextStyle(fontSize: 13),
                          ),
                          // Contributor Role
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
                    }

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
                          // print(value);
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
      ),
    );
  }
}
