import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import '../database.dart';
import '../returnedData/albumData.dart';
import '../show_data/icon.dart';

class Results extends StatelessWidget {
  final String input;
  Results(this.input);

  @override
  Widget build(BuildContext context) {
    Future<List<List<Text>>> _results = Database.search(input);
    // late String name = "Artist not found";
    String name = input;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
            width: double.infinity,
            child: FutureBuilder<List<List<Text>>>(
              future: _results,
              builder: (BuildContext context,
                  AsyncSnapshot<List<List<Text>>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[];
                  //
                  for (int i = 0; i < snapshot.data!.length; i++) {
                    var data = snapshot.data![i];
                    // Artist Data
                    if (data.length == 3) {
                      children.add(ShowIcon(
                          data[0].data.toString(),
                          "",
                          data[2].data.toString(),
                          true,
                          true,
                          data[1].data.toString()));
                    }
                    // Album Data
                    if (data.length == 4) {
                      children.add(ShowIcon(
                          data[1].data.toString(),
                          data[0].data.toString(),
                          data[2].data.toString(),
                          false,
                          true,
                          data[3].data.toString()));
                    }
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
    );
  }
}
