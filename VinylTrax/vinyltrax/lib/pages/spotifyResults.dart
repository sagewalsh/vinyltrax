import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import 'package:vinyltrax/show_data/listEntry.dart';
import '../show_data/icon.dart';
import 'dart:developer';
import '../spotify.dart';
import '../returnedData/spotScroll.dart';
import '../pages/settingspage.dart' as settings;

class SpotifyResults extends StatelessWidget {
  final String input;
  SpotifyResults(this.input);

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> _results = Spotify.search(input);
    // late String name = "Artist not found";
    String name = input;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFEF9),
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.10, //180
          backgroundColor: Color(0xFFFFFEF9),
          leading: BackButton(color: Colors.black),
          title: Text(
            name,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox(
                width: double.infinity,
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _results,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      children = <Widget>[];
                      List<Widget> albums = [];
                      List<Widget> singles = [];
                      List<Widget> artists = [];
                      List<Widget> tracks = [];

                      var map = snapshot.data!;
                      int max = 1;

                      // #######################################################
                      // Collect Artists
                      // #######################################################
                      var data = map["artists"];
                      var list = data as List<dynamic>;
                      if (settings.listBool)
                        list.forEach((element) {
                          children.add(ListEntry(
                            name: element[1],
                            image: element[2],
                            isAlbum: false,
                            location: "spotify",
                            id: element[0],
                          ));
                        });
                      // icon view
                      else
                        for (int i = 0; i < list.length && i <= 10; i++) {
                          var element = list[i];

                          artists.add(ShowIcon(
                            coverArt: element[2],
                            isArtist: true,
                            location: 'spotify',
                            id: element[0],
                            artistName: element[1],
                          ));
                        }

                      // #######################################################
                      // Collect Albums
                      // #######################################################
                      data = map["albums"];
                      list = data as List<dynamic>;

                      // list view
                      if (settings.listBool)
                        list.forEach((element) {
                          children.add(
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
                        for (int i = 0; i < list.length && i <= 10; i++) {
                          var element = list[i];

                          // Compile artist names
                          String artName = "";
                          for (int i = 0;
                              i < (element[2] as List<dynamic>).length;
                              i++) {
                            artName += element[2][i][0].toString();
                            if (i + 1 < (element[2] as List<dynamic>).length) {
                              artName += " & ";
                            }
                          }
                          if (max <= 10) {
                            albums.add(ShowIcon(
                              coverArt: element[3],
                              isArtist: false,
                              location: 'spotify',
                              id: element[0],
                              albumName: element[1],
                              artistName: artName,
                            ));
                            max++;
                          }
                        }
                      // #######################################################
                      // Collect Singles and EPs
                      // #######################################################
                      data = map["singles"];
                      list = data as List<dynamic>;

                      if (settings.listBool)
                        list.forEach((element) {
                          children.add(ListEntry(
                            name: element[1],
                            image: element[3],
                            isAlbum: true,
                            location: "spotify",
                            id: element[0],
                          ));
                        });

                      // icon view
                      else
                        for (int i = 0; i < list.length && i <= 10; i++) {
                          var element = list[i];
                          String artName = "";
                          for (int i = 0;
                              i < (element[2] as List<dynamic>).length;
                              i++) {
                            artName += element[2][i][0].toString();
                            if (i + 1 < (element[2] as List<dynamic>).length) {
                              artName += " & ";
                            }
                          }
                          singles.add(ShowIcon(
                            coverArt: element[3],
                            isArtist: false,
                            location: 'spotify',
                            id: element[0],
                            albumName: element[1],
                            artistName: artName,
                          ));
                        }

                      // #######################################################
                      // Collect Tracks
                      // #######################################################
                      data = map["tracks"];
                      list = data as List<dynamic>;

                      if (settings.listBool)
                        list.forEach((element) {
                          children.add(ListEntry(
                            name: element[1],
                            image: element[4],
                            isAlbum: true,
                            location: "spotify",
                            id: element[3],
                          ));
                        });

                      // icon view
                      else
                        for (int i = 0; i < list.length && i <= 10; i++) {
                          var element = list[i];
                          String artName = "";
                          for (int i = 0;
                              i < (element[2] as List<dynamic>).length;
                              i++) {
                            artName += element[2][i][0].toString();
                            if (i + 1 < (element[2] as List<dynamic>).length) {
                              artName += " & ";
                            }
                          }

                          tracks.add(ShowIcon(
                            coverArt: element[4],
                            isArtist: false,
                            location: 'spotify',
                            id: element[3],
                            albumName: element[1],
                            artistName: artName,
                          ));
                        }

                      // #######################################################
                      // Output each collection in its own horizontal section
                      // #######################################################
                      if (!settings.listBool) {
                        children.add(SpotScroll(artists, "Artists", snapshot));
                        children.add(SpotScroll(albums, "Albums", snapshot));
                        children.add(
                            SpotScroll(singles, "Singles & EPs", snapshot));
                        children.add(SpotScroll(tracks, "Tracks", snapshot));
                      }

                      // #######################################################
                      // Space
                      // #######################################################
                      children.add(SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: const Text(""),
                      ));
                    }

                    // #######################################################
                    // Error
                    // #######################################################
                    else if (snapshot.hasError) {
                      children = <Widget>[
                        Icon(Icons.error),
                      ];
                    }

                    // #######################################################
                    // In progress
                    // #######################################################
                    else {
                      children = <Widget>[
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width * 0.1275, //50
                          height:
                              MediaQuery.of(context).size.height * 0.062, //50
                          child: CircularProgressIndicator(),
                        )
                      ];
                    }
                    return Column(
                      children: [
                        // SizedBox(height: 10),
                        IconList(children),
                      ],
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }
}
