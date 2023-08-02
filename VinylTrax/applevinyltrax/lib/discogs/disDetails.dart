import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../buttons/addAlbumPopUp.dart';
import 'discogs.dart';
import '../pages/nextPage.dart';
import '../pages/settingspage.dart' as settings;

class DisDetails extends StatelessWidget {
  final List<String> input;
  final bool isBarcode;
  DisDetails(this.input, this.isBarcode);

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> _results;
    String name = "";
    Widget title = Text("Barcode Results",
        style:
            TextStyle(color: settings.darkTheme ? Colors.white : Colors.black));

    if (!isBarcode) {
      _results = Collection.album(input[0]);
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
    } else
      _results = Collection.barcode(input[0]);

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
                      return AddAlbumPopUp(_results, "text");
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

                      Widget extendedName = Center(
                        child: Text(
                          data[1].toString(),
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                      );

                      if (name.length > 45) {
                        extendedName = Center(
                            child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          child: Marquee(
                            velocity: 10,
                            blankSpace: 100,
                            text: data[1].toString(),
                            style: TextStyle(
                              color: settings.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ));
                      }

                      children.add(SizedBox(
                        width: double.infinity,
                        height: 20,
                        child: const Text(""),
                      ));

                      // COVER ART
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
                                  return new NextPageDisArt(
                                      data[0][i][1].toString(),
                                      data[0][i][0].toString());
                                });
                                Navigator.of(context).push(route);
                              }),
                            style: TextStyle(
                              color: settings.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        );
                        if (i + 1 < size) {
                          artists.add(TextSpan(
                            text: " & ",
                            style: TextStyle(
                              color: settings.darkTheme
                                  ? Colors.white
                                  : Colors.black,
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

                      // GENRE AND YEAR
                      if (data[3].toString().length == 4) {
                        children.add(Center(
                            child: Text(
                          data[2][0].toString() + "  •  " + data[3].toString(),
                          style: TextStyle(
                              color: settings.darkTheme
                                  ? Colors.white
                                  : Colors.black),
                        )));
                      } else {
                        children.add(Center(
                            child: Text(data[2][0].toString(),
                                style: TextStyle(
                                    color: settings.darkTheme
                                        ? Colors.white
                                        : Colors.black))));
                      }

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
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                data[4][i][0].toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: settings.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),

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

                      // CONTRIBUTORS
                      if (data[5] != null) {
                        children.add(Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text("Contributors",
                              style: TextStyle(
                                fontSize: 17,
                                color: settings.darkTheme
                                    ? Colors.white
                                    : Colors.black,
                              )),
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
                                style: TextStyle(
                                  fontSize: 13,
                                  color: settings.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),

                            // Contributor Role
                            subtitle: Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
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
                              child: Text(
                                data[5][j][1].toString(),
                                // textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: settings.darkTheme
                                        ? Colors.white
                                        : Colors.black),
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
                          children: contributors,
                        ));
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
