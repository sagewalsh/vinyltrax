import 'package:flutter/material.dart';
import '../database.dart';
import '../show_data/icon.dart';
import '../show_data/iconList.dart';

class GetInvGenre extends StatelessWidget {
  final String genre;
  final String format;
  // AlbumsOfGenre({Key? key}) : super(key: key);
  GetInvGenre(this.genre, this.format);

  @override
  Widget build(BuildContext context) {
    final Future<List<List<dynamic>>> _results =
        Database.displayByGenre(genre, format);
    return SizedBox(
      width: double.infinity,
      child: FutureBuilder<List<List<dynamic>>>(
          future: _results,
          builder: (BuildContext context,
              AsyncSnapshot<List<List<dynamic>>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[];

              snapshot.data!.forEach((element) {
                // Compile the Artists' Names
                String artist = "";
                var data = element[2] as List<dynamic>;
                for (int i = 0; i < data.length; i++) {
                  artist += data[i][0].toString();
                  if (i + 1 < data.length) {
                    artist += " & ";
                  }
                }

                children.add(ShowIcon(
                  artistName: artist,
                  albumName: element[1].toString(),
                  coverArt: element[3].toString(),
                  isArtist: false,
                  location: 'inv',
                  id: element[0].toString(),
                ));
              });
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
