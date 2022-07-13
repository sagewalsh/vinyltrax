import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:marquee/marquee.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import '../database.dart';
import '../show_data/icon.dart';

class InvAlbumsBy extends StatelessWidget {
  final List<String> input;
  InvAlbumsBy(this.input);

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> _results = Database.albumsBy(input[0]);
    // late String name = "Artist not found";
    String name = input[1];

    Widget title = Text(
      name,
      style: TextStyle(
        color: Colors.black,
      ),
    );

    if (name.length > 25) {
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
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
              width: double.infinity,
              child: FutureBuilder<List<dynamic>>(
                future: _results,
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[];

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
                          artist,
                          snapshot.data![i + 1].toString(),
                          snapshot.data![i + 3].toString(),
                          false,
                          true,
                          snapshot.data![i].toString()));
                    }
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
