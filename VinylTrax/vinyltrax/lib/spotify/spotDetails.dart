//import 'dart:html';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:vinyltrax/spotify/spotAddButton.dart';
import 'spotify.dart';
import '../pages/nextPage.dart';

class SpotDetails extends StatelessWidget {
  final List<String> input;
  SpotDetails(this.input);

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> _results;
    String name = "";
    Widget title =
        Text("Barcode Results", style: TextStyle(color: Colors.black));

    _results = Spotify.album(input[0]);
    name = input[1];
    title = Text(
      name,
      style: TextStyle(
        color: Colors.black,
      ),
    );

    if (name.length > 22) {
      title = Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Marquee(
          velocity: 20,
          blankSpace: 30,
          text: name,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );
    }

    // late String name = "Artist not found";

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
                      return SpotAddButton(_results, input[0]);
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
        body: Scrollbar(
          child: SingleChildScrollView(
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

                      Widget extendedName = Center(
                        child: Container(

                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          child: Text(
                            data[1].toString(),
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );

                      if (name.length > 35) {
                        extendedName = Center(
                            child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          child: Marquee(
                            startPadding: 20,
                            startAfter: Duration(seconds: 5),
                            velocity: 10,
                            blankSpace: 100,
                            text: data[1].toString(),
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 20,

                            ),
                          ),
                        ));
                      }

                      // children.add(SizedBox(
                      //   width: double.infinity,
                      //   height: 20,
                      //   child: const Text(""),
                      // ));

                      // COVER ART
                      children.add(Center(
                        child: Container(
                          height: MediaQuery.of(context).size.width, //150 square
                          width: MediaQuery.of(context).size.width,
                          child: Image(
                            image: NetworkImage(data[5].toString()),
                          ),
                        ),
                      ));

                      // ALBUM NAME
                      children.add(extendedName);

                      // ARTIST NAME
                      var artists = <TextSpan>[];
                      int size = (data[0] as List<dynamic>).length;
                      for (int i = 0; i < size; i++) {
                        artists.add(
                          TextSpan(
                            text: data[0][i][0]
                                .toString()
                                .replaceAll(RegExp(r'\([0-9]+\)'), ""),
                            recognizer: TapGestureRecognizer()
                              ..onTap = (() {
                                var route = new MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return new NextPageSpotArt(
                                    data[0][i][1].toString(),
                                    data[0][i][0].toString(),
                                  );
                                });
                                Navigator.of(context).push(route);
                              }),
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontSize: 18,
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
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 24,
                            child: RichText(
                              text: TextSpan(
                                children: artists,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );

                      // GENRE AND YEAR
                      String gy = "";
                      if ((data[2] as List<dynamic>).isNotEmpty) {
                        if (data[3].toString().length == 4) {
                          // has genre and year
                          gy = 
                            data[2][0].toString() +
                                "  •  " +
                                data[3].toString();
                        } else {
                          // has genre
                          gy = data[2][0].toString();
                        }
                      } else {
                        if (data[3].toString().length == 4) {
                          // has year
                          gy = data[3].toString();
                        }
                      }
                      children.add(Center(child: Text(
                        gy,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),));

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
                          // Cycle through the tracks

                          // Compile Track Contributors
                          String artist = "";
                          double size = 5;
                          double pad = 10;
                          var cont = (data[4][i][2] as List<dynamic>);
                          if (cont.isNotEmpty) {
                            size = 10;
                            pad = 5;
                            for (int j = 0; j < cont.length; j++) {
                              artist += cont[j][0].toString();

                              if (j + 1 < cont.length) {
                                artist += " & ";
                              }
                            }
                          }

                          tracklist.add(
                              // Track list item
                              ListTile(
                            visualDensity: VisualDensity(vertical: -4),

                            // Track Number
                            leading: Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
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
                              padding: EdgeInsets.fromLTRB(0, pad, 0, 5),
                              child: Text(
                                data[4][i][0].toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),

                            // Track Contributors + bar
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
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  artist,
                                  style: TextStyle(
                                    fontSize: size,
                                  ),
                                ),
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
        ),
      ),
    );
  }
}
