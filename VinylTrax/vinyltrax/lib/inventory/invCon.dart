import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../discogs/discogs.dart';
import '../show_data/icon.dart';
import '../pages/settingspage.dart' as settings;

class InvCon extends StatelessWidget {
  final List<String> input;
  InvCon(this.input);
  int max = 1;

  @override
  Widget build(BuildContext context) {
    Future<List<String>> _results = Collection.getCredits(input[0]);
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
        backgroundColor: settings.darkTheme ? Color(0xFF1C1C1C) : Color(0xFFFFFDF6),
        appBar: AppBar(
          backgroundColor: settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
          leading: BackButton(
            color: settings.darkTheme ? Colors.white : Colors.black,
          ),
          title: title,
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: FutureBuilder<List<String>>(
                future: _results,
                builder: (BuildContext context,
                    AsyncSnapshot<List<String>> snapshot) {
                  List<Widget> children = <Widget>[];
                  ;
                  if (snapshot.hasData) {
                    for (int i = 0; i < snapshot.data!.length; i += 3) {
                      var data = [
                        snapshot.data![i],
                        snapshot.data![i + 1],
                        snapshot.data![i + 2],
                      ];
                      var artist_album = data[0].split(" - ");
                      if (max <= 10) {
                        children.add(ShowIcon(
                          artistName: artist_album[0],
                          albumName: artist_album[1],
                          coverArt: data[2],
                          isArtist: false,
                          location: 'inv',
                          id: data[1],
                        ));
                        max++;
                      }
                    }
                  }
                  return Column(
                    children: children,
                  );
                }),
          ),
        ),
      ),
    );
  }
}
