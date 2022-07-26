import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import '../show_data/icon.dart';
import 'dart:developer';
import '../spotify.dart';
import '../returnedData/spotScroll.dart';

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

                      // #######################################################
                      // Collect Albums
                      // #######################################################
                      var data = map["albums"];
                      (data as List<dynamic>).forEach((element) {
                        element = element as List<dynamic>;

                        String artName = "";
                        for (int i = 0;
                            i < (element[2] as List<dynamic>).length;
                            i++) {
                          artName += element[2][i][0].toString();
                          if (i + 1 < (element[2] as List<dynamic>).length) {
                            artName += " & ";
                          }
                        }

                        albums.add(ShowIcon(
                          coverArt: element[3],
                          isArtist: false,
                          isInv: false,
                          id: element[0],
                          albumName: element[1],
                          artistName: artName,
                        ));
                      });

                      // #######################################################
                      // Collect Singles and EPs
                      // #######################################################
                      data = map["singles"];
                      (data as List<dynamic>).forEach((element) {
                        element = element as List<dynamic>;

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
                          isInv: false,
                          id: element[0],
                          albumName: element[1],
                          artistName: artName,
                        ));
                      });

                      // #######################################################
                      // Collect Tracks
                      // #######################################################
                      data = map["tracks"];
                      (data as List<dynamic>).forEach((element) {
                        element = element as List<dynamic>;

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
                          isInv: false,
                          id: element[3],
                          albumName: element[1],
                          artistName: artName,
                        ));
                      });

                      // #######################################################
                      // Collect Artists
                      // #######################################################
                      data = map["artists"];
                      (data as List<dynamic>).forEach((element) {
                        artists.add(ShowIcon(
                          coverArt: element[2],
                          isArtist: true,
                          isInv: false,
                          id: element[0],
                          artistName: element[1],
                        ));
                      });

                      // #######################################################
                      // Output each collection in its own horizontal section
                      // #######################################################
                      children.add(SpotScroll(artists, "Artists", snapshot));
                      children.add(SpotScroll(albums, "Albums", snapshot));
                      children
                          .add(SpotScroll(singles, "Singles & EPs", snapshot));
                      children.add(SpotScroll(tracks, "Tracks", snapshot));

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
                        SizedBox(height: 20),
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
