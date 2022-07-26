import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import '../show_data/icon.dart';
import '../discogs.dart';

class DisAlbumsBy extends StatelessWidget {
  final List<String> input;
  DisAlbumsBy(this.input);

  @override
  Widget build(BuildContext context) {
    // Future<Map<String, List<String>>> _results = Collection.albumsBy(input[0]);
    Future<Map<String, List<String>>> _results =
        Collection.albumsBy(input[1], 1, {});
    // late String name = "Artist not found";
    String name = input[1];

    Widget title = Text(
      name.replaceAll(RegExp(r'\([0-9]+\)'), ""),
      style: TextStyle(
        color: Colors.black,
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
            color: Colors.black,
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFEF9),
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFEF9),
          leading: BackButton(
            color: Colors.black,
          ),
          title: title,
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox(
                width: double.infinity,
                child: FutureBuilder<Map<String, List<String>>>(
                  future: _results,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, List<String>>> snapshot) {
                    List<Widget> children;
                    if (snapshot.hasData) {
                      children = <Widget>[];
                      snapshot.data!.forEach((key, value) {
                        // print(key.toString() + ": " + value.toString());
                        children.add(ShowIcon(
                          albumName: value[0],
                          coverArt: value[3],
                          isArtist: false,
                          location: 'discogs',
                          id: value[1],
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
      ),
    );
  }
}
