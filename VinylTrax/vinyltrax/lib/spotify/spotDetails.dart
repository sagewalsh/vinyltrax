import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:marquee/marquee.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../buttons/addAlbumPopUp.dart';
import 'spotify.dart';
import '../pages/nextPage.dart';
import '../pages/settingspage.dart' as settings;

class SpotDetails extends StatelessWidget {
  final List<String> input;
  final String inputType;
  SpotDetails(this.input, this.inputType);

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> _results;
    String name = "";
    Widget title;
    if (inputType == "barcode") {
      title = Text("Barcode Results",
          style: TextStyle(
              color: settings.darkTheme ? Colors.white : Colors.black));
    } else {
      title = Text("Cover Scan Results",
          style: TextStyle(
              color: settings.darkTheme ? Colors.white : Colors.black));
    }

    if (inputType == "text") {
      _results = Spotify.album(input[0]);
      name = input[1];
      title = Text(
        name,
        style: TextStyle(
          color: settings.darkTheme ? Colors.white : Colors.black,
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
              color: settings.darkTheme ? Colors.white : Colors.black,
            ),
          ),
        );
      }
    } else if (inputType == "barcode") {
      if (input.isEmpty)
        _results = Spotify.empty();
      else
        _results = Spotify.barcode(input[0], input[1]);
    } else {
      _results = Spotify.coverScan(input[0]);
    }

    // late String name = "Artist not found";

    Widget addBlackLine() {
      return Padding(
        padding: const EdgeInsets.only(top: 8, left: 5, right: 5),
        child: Divider(
          color: settings.darkTheme ? Colors.white : Colors.black,
          thickness: 1,
          height: 0,
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor:
            settings.darkTheme ? Color(0xFF1C1C1C) : Color(0xFFFFFDF6),
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * .10,
          backgroundColor:
              settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
          leading: BackButton(
            color: settings.darkTheme ? Colors.white : Colors.black,
          ),
          title: title,
          actions: [
            TextButton(
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
                      color: settings.darkTheme ? Colors.white : Colors.black,
                      fontSize: 18),
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

                      if (data.isEmpty) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "No results found",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        );
                      }

                      // Set the style of Album Name
                      Widget extendedName = Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          child: Text(
                            data[1].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              // color: Colors.grey[700],
                              color: Colors.black,
                              fontSize: 20,
                            ),
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
                              fontSize: 20,
                              color: settings.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ));
                      }
                      ;

                      // COVER ART
                      children.add(Center(
                        child: Container(
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Save Image?"),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                var response = await http.get(
                                                    Uri.parse(
                                                        data[5].toString()));
                                                Directory documentDirectory =
                                                    await getApplicationDocumentsDirectory();
                                                File file = new File(join(
                                                    documentDirectory.path,
                                                    '${data[0][0][0].toString()}$name.png'));
                                                file.writeAsBytesSync(
                                                    response.bodyBytes);
                                                await GallerySaver.saveImage(
                                                    file.path,
                                                    albumName: "Vinyl Trax");
                                              },
                                              child: Text("Yes")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("No"))
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Image(
                              image: NetworkImage(data[5].toString()),
                            ),
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
                              color: settings.darkTheme
                                  ? Colors.white
                                  : Color(0xFFFF5A5A),
                              // decoration: TextDecoration.underline,
                              fontSize: 18,
                            ),
                          ),
                        );
                        if (i + 1 < size) {
                          artists.add(TextSpan(
                            text: " & ",
                            style: TextStyle(
                              fontSize: 18,
                              color: settings.darkTheme
                                  ? Colors.white
                                  : Color(0xFFFF5A5A),
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
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: artists,
                              ),
                            ),
                          ),
                        ),
                      );

                      // GENRE AND YEAR
                      String gy = "";
                      if ((data[2] as List<dynamic>).isNotEmpty) {
                        if (data[3].toString().length == 4) {
                          // has genre and year
                          gy = data[2][0].toString() +
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
                      children.add(Center(
                        child: Text(
                          gy,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: settings.darkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ));

                      children.add(SizedBox(height: 30));

                      // TRACKLIST
                      if (data[4] != null) {
                        children.add(Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text("Tracklist",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: settings.darkTheme
                                      ? Colors.white
                                      : Colors.black)),
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
                                  color: settings.darkTheme
                                      ? Colors.white
                                      : Colors.black,
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
                                    color: settings.darkTheme
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),

                            // Track Contributors + bar
                            subtitle: Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: settings.darkTheme
                                        ? Color(0x64BB86FC)
                                        : Color(0x64FF5A5A),
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
                                  color: settings.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                            tileColor: settings.darkTheme
                                ? Color(0xFF181818)
                                : Color(0xFFFFFDF6),
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
                          height: (MediaQuery.of(context).size.height * 0.10),
                        ),
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
      ),
    );
  }
}
