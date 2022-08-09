import 'package:flutter/material.dart';
import 'package:googleapis/dfareporting/v3_5.dart';
import 'package:marquee/marquee.dart';
import 'package:vinyltrax/buttons/addCustomAlbumPopUp.dart';
import '../show_data/icon.dart';
import 'spotify.dart';
import '../pages/settingspage.dart' as settings;
import '../show_data/listEntry.dart';
import 'spotScroll.dart';

import 'dart:developer';

class SpotAlbumsBy extends StatefulWidget {
  final List<String> input;
  final String tab;

  SpotAlbumsBy(this.input, this.tab);

  @override
  State<SpotAlbumsBy> createState() => _SpotAlbumsByState();
}

class _SpotAlbumsByState extends State<SpotAlbumsBy> {
  List<Widget> children = [];

  @override
  Widget build(BuildContext context) {
    // Future<Map<String, List<String>>> _results = Collection.albumsBy(input[0]);
    Future<Map<String, List<dynamic>>> _results =
        Spotify.albumsBy(widget.input[0]);
    // late String name = "Artist not found";
    String name = widget.input[1];

    Widget title = Text(
      name.replaceAll(RegExp(r'\([0-9]+\)'), ""),
      style: TextStyle(
        color: settings.darkTheme ? Colors.white : Colors.black,
      ),
    );

    if (name.length > 27) {
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

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: SizedBox(
          width: double.infinity,
          child: FutureBuilder<Map<String, List<dynamic>>>(
            future: _results,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, List<dynamic>>> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[];
                List<Widget> albums = [];
                List<Widget> singles = [];
                List<Widget> appears = [];

                var map = snapshot.data!;
                List<dynamic> list;

                // #######################################################
                // Collect Albums
                // #######################################################
                list = map["albums"] as List<dynamic>;

                // list view
                if (settings.listBool)
                  list.forEach((element) {
                    albums.add(
                      ListEntry(
                        name: element[1],
                        image: element[3],
                        isAlbum: true,
                        location: "spotify",
                        id: element[0],
                      ),
                    );
                  });

                // icon view
                else
                  for (int i = 0; i < list.length && i < 10; i++) {
                    var element = list[i];
                    albums.add(ShowIcon(
                      coverArt: element[3],
                      isArtist: false,
                      location: 'spotify',
                      id: element[0],
                      albumName: element[1],
                    ));
                  }

                // #######################################################
                // Collect Singles and EPs
                // #######################################################
                list = map["singles"] as List<dynamic>;

                // list view
                if (settings.listBool)
                  list.forEach((element) {
                    singles.add(
                      ListEntry(
                        name: element[1],
                        image: element[3],
                        isAlbum: true,
                        location: "spotify",
                        id: element[0],
                      ),
                    );
                  });

                // icon view
                else
                  for (int i = 0; i < list.length && i < 10; i++) {
                    var element = list[i];

                    // log(element[1]);
                    singles.add(ShowIcon(
                      coverArt: element[3],
                      isArtist: false,
                      location: 'spotify',
                      id: element[0],
                      albumName: element[1],
                    ));
                  }
                // #######################################################
                // Collect Albums the Artist Appears On
                // #######################################################
                list = map["appears"] as List<dynamic>;

                // list view
                if (settings.listBool)
                  list.forEach((element) {
                    appears.add(
                      ListEntry(
                        name: element[1],
                        image: element[3],
                        isAlbum: true,
                        location: "spotify",
                        id: element[0],
                      ),
                    );
                  });

                // icon view
                else
                  for (int i = 0; i < list.length && i < 10; i++) {
                    var element = list[i];
                    appears.add(ShowIcon(
                      coverArt: element[3],
                      isArtist: false,
                      location: 'spotify',
                      id: element[0],
                      albumName: element[1],
                    ));
                  }
                // #######################################################
                // Output each collection in its own horizontal section
                // #######################################################
                if (!settings.listBool) {
                  if (albums.length > 0)
                    children.add(SpotScroll(albums, "Albums", snapshot));
                  if (singles.length > 0)
                    children
                        .add(SpotScroll(singles, "Singles & EPs", snapshot));
                  if (appears.length > 0)
                    children.add(SpotScroll(appears, "Appears On", snapshot));
                  if (children.length == 0)
                    children.add(Text(
                      "No results for ${widget.input[1]}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ));
                }
                // #######################################################
                // Output list view in sections
                // #######################################################
                else {
                  if (widget.tab == "one")
                    children.add(ListEntryList(albums));
                  else if (widget.tab == "two")
                    children.add(ListEntryList(singles));
                  else if (widget.tab == "three")
                    children.add(ListEntryList(appears));
                }

                children.add(SizedBox(
                  height: 20,
                ));

                // #######################################################
                // Button on the bottom that allows users to add a custom button
                // #######################################################
                children.add(InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddCustomAlbumPopUp(widget.input);
                          });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * .8,
                      height: MediaQuery.of(context).size.height * .05,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: settings.darkTheme
                                ? Color(0xFFBB86FC)
                                : Color(0xFFFF5A5A),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        "Add Custom Album",
                        style: TextStyle(
                            color: settings.darkTheme
                                ? Color(0xFFBB86FC)
                                : Color(0xFFFF5A5A)),
                      )),
                    )));

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
                children: children,
              );
            },
          )),
    );
  }
}
