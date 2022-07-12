import 'package:flutter/material.dart';
import 'package:vinyltrax/buttons/addAlbumPopUp.dart';
import 'package:vinyltrax/returnedData/scrollResults.dart';
import '../database.dart';
import '../show_data/icon.dart';
import '../show_data/iconList.dart';

class GetInvAlbum extends StatelessWidget {
  GetInvAlbum({Key? key}) : super(key: key);

  final Future<List<dynamic>> _results = Database.displayByName();
  List<Widget> children = <Widget>[];

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
              for (int i = 0; i < snapshot.data!.length; i += 4) {
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
                    artist,
                    snapshot.data![i + 1].toString(),
                    snapshot.data![i + 3].toString(),
                    false,
                    true,
                    snapshot.data![0].toString()));
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
