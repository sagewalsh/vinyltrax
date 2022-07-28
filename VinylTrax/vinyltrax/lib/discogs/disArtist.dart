import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import 'discogs.dart';
import '../pages/settingspage.dart' as settings;

class DisArtist extends StatelessWidget {
  final List<String> input;
  DisArtist(this.input);

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> _results = Collection.artistData(input[0]);
    // late String name = "Artist not found";
    String name = input[1];

    return SafeArea(
      child: Scaffold(
        backgroundColor: settings.darkTheme ? Color(0xFF1C1C1C) : Color(0xFFFFFDF6),
        appBar: AppBar(
          backgroundColor: settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
          leading: BackButton(
            color: settings.darkTheme ? Colors.white : Colors.black,
          ),
          title: Text(
            name,
            style: TextStyle(
              color: settings.darkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
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
                      var data = snapshot.data!;
                      if (data.length == 3) {
                        children.add(Text(data[0].toString()));
                        children.add(Text(data[1].toString()));
                        children.add(Text(data[2].toString()));
                      }
                      if (data.length == 4) {
                        var members = data[3] as List<dynamic>;
                        var names = "Band Members:\n";
                        members.forEach((element) {
                          element = element as Map<dynamic, dynamic>;
                          names += "id: " +
                              element["id"].toString() +
                              "   name: " +
                              element["name"].toString() +
                              "\n";
                        });
                        children.add(Text(data[0].toString()));
                        children.add(Text(data[1].toString()));
                        children.add(Text(data[2].toString()));
                        children.add(Text(names));
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
      ),
    );
  }
}
