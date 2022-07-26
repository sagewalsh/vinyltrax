import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vinyltrax/pages/homePage.dart';
import 'package:vinyltrax/show_data/camera.dart';
import 'buttons/tabs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(VinylTrax(firstCamera));
}

class VinylTrax extends StatelessWidget {
  final camera;
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  VinylTrax(this.camera);
  //VinylTrax({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Test.fillDatabase();
    Test.database();
    Test.discogs();
    // Test.spotify();

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
      darkTheme: ThemeData.dark(),
      initialRoute:
          'inven', //switch to 'inven' for our sake, but for testing I'll leave as is
      routes: {
        'home': (context) => const HomePage(),
        'inven': (context) => Tabs(0),
        'wish': (context) => Tabs(1),
        'search': (context) => Tabs(2),
        'setting': (context) => Tabs(3),
        'camera': (context) => Camera(camera),
      },
      theme: ThemeData(fontFamily: 'OpenSans'),
    );
  }
}
