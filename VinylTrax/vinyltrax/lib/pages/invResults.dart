import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/iconList.dart';
import '../database.dart';
import '../show_data/icon.dart';
import 'dart:developer';

class InvResults extends StatelessWidget {
  final String input;
  InvResults(this.input);

  @override
  Widget build(BuildContext context) {
    Future<List<List<dynamic>>> _results = Database.search(input);
    // late String name = "Artist not found";
    String name = input;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFEF9),
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFEF9),
          leading: BackButton(color: Colors.black),
          title: Text(
            name,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
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
                      if (snapshot.data!.length == 0) {
                        children.add(
                            Text("No Inventory Found with the Name: " + input));
                      }
                      snapshot.data!.forEach((result) {
                        // Artist Data
                        if (result.length == 3) {
                          children.add(ShowIcon(
                            artistName: result[0].toString(),
                            coverArt: result[2].toString(),
                            isArtist: true,
                            isInv: true,
                            id: result[1].toString(),
                          ));
                        }
                        // Album Data
                        if (result.length == 6) {
                          log("length 6");
                          String artists = "";
                          var list = result[2] as List<dynamic>;
                          for (int i = 0; i < list.length; i++) {
                            artists += list[i][0].toString();
                            if (i + 1 < list.length) {
                              artists += " & ";
                            }
                          }
                          children.add(ShowIcon(
                              artistName: artists,
                              albumName: result[1].toString(),
                              coverArt: result[3].toString(),
                              isArtist: false,
                              isInv: true,
                              id: result[0].toString()));
                        }
                      });
                      // for (int i = 0; i < snapshot.data!.length; i++) {
                      //   var data = snapshot.data![i];

                      //   }
                      // }
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
                          width:
                              MediaQuery.of(context).size.width * 0.1275, //50
                          height:
                              MediaQuery.of(context).size.height * 0.062, //50
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
