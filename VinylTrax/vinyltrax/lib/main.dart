import 'package:flutter/material.dart';
import './tabs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import './database.dart';

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
    Database.startingData();

    // Database.orderByAlbum();
    // Database.orderByArtist();
    // Database.printAlbumBy(1112);
    // Database.printArtistName(1112);
    Database.printAlbumDetails(1217);

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
    return MaterialApp(home: Tabs());
  }
}
