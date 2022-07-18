import 'package:flutter/material.dart';
import 'buttons/tabs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(VinylTrax());
}

class VinylTrax extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  VinylTrax({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Test.fillDatabase();
    Test.database();
    Test.discogs();
    Test.spotify();

    FutureBuilder(
        future: _fbApp,
        builder: (contrext, snapshot) {
          if (snapshot.hasError) {
            print("You have an error! ${snapshot.error.toString()}");
            return Text("Something went wrong!");
            // } else if (snapshot.hasData) {
            // return MyHomePage(title: "Vinyl Trax");
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
    return MaterialApp(
      home: Tabs(),
      theme: ThemeData(fontFamily: 'OpenSans'),
    );
  }
}
