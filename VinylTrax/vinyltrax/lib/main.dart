import 'package:flutter/material.dart';
import './tabs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import './database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // startingData();
  runApp(VinylTrax());
}

class VinylTrax extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  // final fb = FirebaseDatabase.instance;

  VinylTrax({Key? key}) : super(key: key);

  // void startingData() async {
  //   final ref = fb.ref();

  //   await ref.set({
  //     "Albums": {
  //       "1216": {
  //         "UniqueID": 1216,
  //         "Name": "The Life of Pablo",
  //         "Artist": "Kanye West",
  //         "Year": 2016,
  //         "Genre": "Hip-Hop",
  //         "Tracklist": "Ultralight Beam (explicit)\n...\nSaint Pablo (explicit)"
  //       },
  //       "1217": {
  //         "UniqueID": 1217,
  //         "Name": "My Beautiful Dark Twisted Fantasy",
  //         "Artist": "Kanye West",
  //         "Year": 2010,
  //         "Genre": "Hip-Hop",
  //         "Tracklist":
  //             "Dark Fantasy (explicit)\n...\nWho Will Survive in America (explicit)"
  //       },
  //       "1218": {
  //         "UniqueID": 1218,
  //         "Name": "808s & Heartbreak",
  //         "Artist": "Kanye West",
  //         "Year": 2008,
  //         "Genre": "Hip-Hop",
  //         "Tracklist": "Say You Will\n...\nColdest Winter"
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // startingData();
    Database.startingData();

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
