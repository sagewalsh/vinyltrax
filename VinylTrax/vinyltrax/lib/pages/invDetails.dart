import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:vinyltrax/pages/nextPage.dart';
import '../database.dart';
import '../returnedData/getInvNotes.dart';
import '../returnedData/getInvPressing.dart';

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
    Future<List<dynamic>> _results = Database.albumDetails(widget.input[0]);
    String album = widget.input[1];

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
      ));
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
                        tracklist.add(
                            // Track list item
                            ListTile(
                          // contentPadding: EdgeInsets.only(bottom: 5),
                          visualDensity: VisualDensity(vertical: -4),

                          // Track Number
                          leading: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              // "\t" + i.toString() + "\t",
                              i.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(122, 0, 0, 0),
                                fontSize: 13,
                              ),
                            ),
                          ),

                          // Track Title
                          title: Container(
                            // padding: EdgeInsets.only(bottom: 5),
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text(
                              data[4][i][0].toString(),
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),

                          // Underline
                          subtitle: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(86, 255, 90, 90),
                                ),
                              ),
                            ),
                            child: Text(
                              " ",
                              style: TextStyle(fontSize: 5),
                            ),
                          ),

                          // Track Duration
                          trailing: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              data[4][i][1],
                              style: TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                color: Color.fromARGB(122, 0, 0, 0),
                              ),
                            ),
                          ),
                          tileColor: Color(0xFFFFFEF9),
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
                          contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          onTap: () {
                            var route = new MaterialPageRoute(
                                builder: (BuildContext context) {
                              return new NextPageCon(
                                id: data[5][j][2].toString(),
                                name: data[5][j][0],
                              );
                            });
                            Navigator.of(context).push(route);
                          },
                          // Contributor name
                          title: Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              data[5][j][0]
                                  .toString()
                                  .replaceAll(RegExp(r'\([0-9]+\)'), ""),
                              style: TextStyle(fontSize: 13),
                            ),
                          ),

                          // Contributor Role
                          subtitle: Container(
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(86, 255, 90, 90),
                                ),
                              ),
                            ),
                            child: Text(
                              data[5][j][1].toString(),
                              // textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          tileColor: Color(0xFFFFFEF9),
                        ));
                      }
                      children.add(ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: contributors,
                      ));
                    }

                    children.add(SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: const Text(""),
                    ));

                    // NOTES SECTION
                    children.add(GetInvNotes(widget.input));

                    // PRESSING DATA
                    children.add(GetInvPressing(widget.input));

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
