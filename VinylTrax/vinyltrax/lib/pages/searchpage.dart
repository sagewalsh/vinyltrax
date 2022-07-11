import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vinyltrax/button_icons/barcode.dart';
import 'package:vinyltrax/buttons/fliterButtons.dart';
import '../textinput.dart' as search;
import 'invResults.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textBox = search.TextInput("Search", false);
  var input = "";
  String? scanResult; //use this to get the barcode number of an album

  @override
  Widget build(BuildContext context) {
    input = textBox.getString();
    if (input.isNotEmpty) return InvResults(input);
    return Scaffold(
      backgroundColor: Color(0xFFFFFEF9),
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 150,
        backgroundColor: Color(0xFFFFFEF9),
        title: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text("Search Page",
                  style: TextStyle(color: Colors.black)),
            ),
            Container(
              color: Color(0xFFFFFEF9),
              //Search bar, Camera button, and barcode scanning button
              child: Row(
                children: [
                  Container(
                    child: textBox,
                    width: 295,
                    height: 75,
                  ),
                  IconButton(
                    color: Colors.black,
                    padding: EdgeInsets.all(5),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("camera");
                    },
                    icon: Icon(Icons.camera_alt_sharp),
                    iconSize: 37,
                  ),
                  IconButton(
                    color: Colors.black,
                    padding: EdgeInsets.all(5),
                    constraints: BoxConstraints(),
                    onPressed: scanBarcode,
                    icon: Icon(BarcodeIcon.barcode),
                    iconSize: 35,
                  ),
                ],
              ),
            ),
            Container(
              //Icon/List buttons and Top/Artist/Album/Song buttons
              color: Color(0xFFFFFEF9),
              child: FilterButtons(),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Divider between UI and output
            Container(
              color: Color(0xFFFFFEF9),
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Future scanBarcode() async {
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          "#E52638", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      scanResult = 'Failed to get platform version';
    }
    if (!mounted) return;
    setState(() => this.scanResult = scanResult);
  }
}
