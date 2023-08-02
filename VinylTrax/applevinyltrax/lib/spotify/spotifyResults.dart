import 'package:flutter/material.dart';
import 'package:applevinyltrax/show_data/listEntry.dart';
import '../show_data/icon.dart';
import 'dart:developer';
import 'spotify.dart';
import 'spotScroll.dart';
import '../pages/settingspage.dart' as settings;

class SpotifyResults extends StatelessWidget {
  final String input, tab;
  SpotifyResults(this.input, this.tab);

  @override
  Widget build(BuildContext context) {
    Future<Map<String, List<dynamic>>> _results = Spotify.search(input);
    // late String name = "Artist not found";
    String name = input;

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
                List<Widget> artists = [];
                List<Widget> tracks = [];

                var map = snapshot.data!;

                // #######################################################
                // Collect Artists
                // #######################################################
                var list = map["artists"]!;

                if (settings.listBool && this.tab != "None")
                  list.forEach((element) {
                    artists.add(ListEntry(
                      name: element[1],
                      image: element[2],
                      isAlbum: false,
                      location: "spotify",
                      id: element[0],
                    ));
                  });
                // icon view
                else
                  for (int i = 0; i < list.length && i < 10; i++) {
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
                list = map["albums"]!;

                // list view
                if (settings.listBool && this.tab != "None")
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
                    albums.add(ShowIcon(
                      coverArt: element[3],
                      isArtist: false,
                      location: 'spotify',
                      id: element[0],
                      albumName: element[1],
                      artistName: artName,
                    ));
                  }
                // #######################################################
                // Collect Singles and EPs
                // #######################################################
                list = map["singles"]!;

                if (settings.listBool && this.tab != "None")
                  list.forEach((element) {
                    singles.add(ListEntry(
                      name: element[1],
                      image: element[3],
                      isAlbum: true,
                      location: "spotify",
                      id: element[0],
                    ));
                  });

                // icon view
                else
                  for (int i = 0; i < list.length && i < 10; i++) {
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
                list = map["tracks"]!;

                if (settings.listBool && this.tab != "None")
                  list.forEach((element) {
                    tracks.add(ListEntry(
                      name: element[1],
                      image: element[3],
                      isAlbum: true,
                      location: "spotify",
                      id: element[0],
                    ));
                  });

                // icon view
                else
                  for (int i = 0; i < list.length && i < 10; i++) {
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
                      coverArt: element[3],
                      isArtist: false,
                      location: 'spotify',
                      id: element[0],
                      albumName: element[1],
                      artistName: artName,
                    ));
                  }

                // #######################################################
                // Output each collection in its own horizontal section
                // #######################################################
                if (!settings.listBool) {
                  if (artists.length > 0)
                    children.add(SpotScroll(artists, "Artists", snapshot));
                  if (albums.length > 0)
                    children.add(SpotScroll(albums, "Albums", snapshot));
                  if (singles.length > 0)
                    children
                        .add(SpotScroll(singles, "Singles & EPs", snapshot));
                  if (tracks.length > 0)
                    children.add(SpotScroll(tracks, "Tracks", snapshot));
                  if (children.length == 0)
                    children.add(Text(
                      "No results found for ${input}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ));
                }
                // #######################################################
                // Output a specific section in list view
                // #######################################################
                else {
                  if (tab == "one")
                    children.add(ListEntryList(artists));
                  else if (tab == "two")
                    children.add(ListEntryList(albums));
                  else if (tab == "three")
                    children.add(ListEntryList(singles));
                  else
                    children.add(ListEntryList(tracks));
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
                    width: MediaQuery.of(context).size.width * 0.1275, //50
                    height: MediaQuery.of(context).size.height * 0.062, //50
                    child: CircularProgressIndicator(),
                  )
                ];
              }
              return Column(
                children: children,
                // children: [
                //   IconList(children),
                // ],
              );
            },
          )),
    );
  }
}
