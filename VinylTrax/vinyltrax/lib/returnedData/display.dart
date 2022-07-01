import 'package:flutter/material.dart';
import '../database.dart';

class Display extends StatelessWidget {
  Display({Key? key}) : super(key: key);

  final Future<List<Text>> _results = Database.displayByArtist();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FutureBuilder<List<Text>>(
          future: _results,
          builder: (BuildContext context, AsyncSnapshot<List<Text>> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              children = <Widget>[
                // Center(child: snapshot.data?[0]),
                // Center(child: snapshot.data?[1]),
              ];
              for (int i = 0; i < snapshot.data!.length; i += 2) {
                children.add(SizedBox(
                  width: double.infinity,
                  height: 20,
                  child: const Text(""),
                ));
                children.add(Center(
                  child: snapshot.data?[i],
                ));
                children.add(Center(
                  child: snapshot.data?[i + 1],
                ));
              }
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
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children),
            );
          }),
    );
  }
}
