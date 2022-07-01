import 'package:flutter/material.dart';
import '../database.dart';
import '../show_data/listEntry.dart';
import '../show_data/listEntryList.dart';

class AlbumOrderArtist extends StatelessWidget {
  AlbumOrderArtist({Key? key}) : super(key: key);

  final Future<List<Text>> _results = Database.displayByArtist();
  List<Widget> children = <Widget>[];
  List<String> uniqueList = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FutureBuilder<List<Text>>(
          future: _results,
          builder: (BuildContext context, AsyncSnapshot<List<Text>> snapshot) {
            if (snapshot.hasData)
            {
              bool cont = true;
              List<String> uniqueList = [];
              for (int i = 0; i < snapshot.data!.length; i += 3)
              {
                for (int j = 0; j < uniqueList.length; j++)
                {
                  if (uniqueList[j] == snapshot.data?[i + 1].data as String)
                    cont = false;
                }
                if (cont)
                {
                  children.add(ListEntry(
                      snapshot.data?[i + 1].data as String,
                      snapshot.data?[i + 2].data as String,
                      false
                  ));
                  uniqueList.add(snapshot.data?[i + 1].data as String);
                }
                cont = true;
              }
            } else if (snapshot.hasError) {
              children = <Widget>[
                Icon(Icons.error),
              ];
            }
            // else {
            //   children = <Widget>[
            //     Center(
            //       child: SizedBox(
            //         width: 50,
            //         height: 50,
            //         child: CircularProgressIndicator(),
            //       ),
            //     )
            //   ];
            // }
            return ListEntryList(children);
          }),
    );
  }
}
