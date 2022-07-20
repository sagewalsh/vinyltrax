import 'package:flutter/material.dart';
import '../database.dart';
import '../show_data/icon.dart';
import '../show_data/iconList.dart';
import '../pages/staxpage.dart';

class GetInvAlbum extends StatelessWidget {
  // GetInvAlbum({Key? key}) : super(key: key);
  GetInvAlbum(this._selectedType);

  final Type _selectedType;
  final Future<List<dynamic>> _results = Database.displayByName();
  final List<Widget> children = <Widget>[];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FutureBuilder<List<dynamic>>(
          future: _results,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[];
              if (_selectedType == Type.vinyl) {
                for (int i = 0; i < snapshot.data!.length; i += 5) {
                  if (snapshot.data![i + 4] == "Vinyl") {
                    // Compile the Artists' Names
                    String artist = "";
                    var data = snapshot.data![i + 2] as List<dynamic>;
                    for (int j = 0; j < data.length; j++) {
                      artist += data[j][0].toString();
                      if (j + 1 < data.length) {
                        artist += " & ";
                      }
                    }

                    children.add(ShowIcon(
                        artistName: artist,
                        albumName: snapshot.data![i + 1].toString(),
                        coverArt: snapshot.data![i + 3].toString(),
                        isArtist: false,
                        isInv: true,
                        id: snapshot.data![i].toString()));
                  }
                }
              } else if (_selectedType == Type.cd) {
                for (int i = 0; i < snapshot.data!.length; i += 5) {
                  if (snapshot.data![i + 4] == "CD") {
                    // Compile the Artists' Names
                    String artist = "";
                    var data = snapshot.data![i + 2] as List<dynamic>;
                    for (int j = 0; j < data.length; j++) {
                      artist += data[j][0].toString();
                      if (j + 1 < data.length) {
                        artist += " & ";
                      }
                    }

                    children.add(ShowIcon(
                        artistName: artist,
                        albumName: snapshot.data![i + 1].toString(),
                        coverArt: snapshot.data![i + 3].toString(),
                        isArtist: false,
                        isInv: true,
                        id: snapshot.data![i].toString()));
                  }
                }
              } else {
                for (int i = 0; i < snapshot.data!.length; i += 5) {
                  // Compile the Artists' Names
                  String artist = "";
                  var data = snapshot.data![i + 2] as List<dynamic>;
                  for (int j = 0; j < data.length; j++) {
                    artist += data[j][0].toString();
                    if (j + 1 < data.length) {
                      artist += " & ";
                    }
                  }

                  children.add(ShowIcon(
                      artistName: artist,
                      albumName: snapshot.data![i + 1].toString(),
                      coverArt: snapshot.data![i + 3].toString(),
                      isArtist: false,
                      isInv: true,
                      id: snapshot.data![i].toString()));
                }
              }
            } else if (snapshot.hasError) {
              children = <Widget>[
                Icon(Icons.error),
              ];
            } else {
              children = <Widget>[
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1275, //50
                    height: MediaQuery.of(context).size.height * 0.062, //50
                    child: CircularProgressIndicator(),
                  ),
                )
              ];
            }
            return IconList(children);
          }),
    );
  }
}
