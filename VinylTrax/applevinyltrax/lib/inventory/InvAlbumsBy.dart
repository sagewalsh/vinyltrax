import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'database.dart';
import '../show_data/icon.dart';
import '../pages/settingspage.dart' as settings;

class InvAlbumsBy extends StatelessWidget {
  final List<String> input;
  InvAlbumsBy(this.input);

  @override
  Widget build(BuildContext context) {
    Future<List<List<dynamic>>> _results =
        Database.albumsBy(artistid: input[0], format: input[2]);
    // late String name = "Artist not found";
    String name = input[1];

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
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
              width: double.infinity,
              child: FutureBuilder<List<List<dynamic>>>(
                future: _results,
                builder: (BuildContext context,
                    AsyncSnapshot<List<List<dynamic>>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[];

                    snapshot.data!.forEach((element) {
                      children.add(ShowIcon(
                        albumName: element[1].toString(),
                        coverArt: element[3].toString(),
                        isArtist: false,
                        location: 'inv',
                        id: element[0].toString(),
                      ));
                    });

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
                    children: [
                      SizedBox(height: 20),
                      IconList(children),
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }
}
