import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import '../database.dart';
import '../show_data/icon.dart';

class InvAlbumsBy extends StatelessWidget {
  final List<String> input;
  InvAlbumsBy(this.input);

  @override
  Widget build(BuildContext context) {
    Future<List<Text>> _results = Database.albumsBy(input[0]);
    // late String name = "Artist not found";
    String name = input[1];

    return Scaffold(
      backgroundColor: Color(0xFFFFFEF9),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFEF9),
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          name,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
            width: double.infinity,
            child: FutureBuilder<List<Text>>(
              future: _results,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Text>> snapshot) {
                List<Widget> children;
                if (snapshot.hasData) {
                  children = <Widget>[];
                  //
                  for (int i = 0; i < snapshot.data!.length; i += 4) {
                    children.add(ShowIcon(
                        snapshot.data?[i + 1].data as String,
                        snapshot.data?[i].data as String,
                        snapshot.data?[i + 2].data as String,
                        false,
                        true,
                        snapshot.data?[i + 3].data as String));
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
