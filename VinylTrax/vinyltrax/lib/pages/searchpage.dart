import 'package:flutter/material.dart';
import 'package:vinyltrax/button_icons/barcode.dart';
import 'package:vinyltrax/buttons/fliterButtons.dart';
import '../textinput.dart';
import '../buttons/iconOrList.dart';
import './searchresultspage.dart';
import './results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textBox = TextInput("Search", false);
  var input = "";

  @override
  Widget build(BuildContext context) {
    input = textBox.getString();
    if (input.isNotEmpty) return Results(input);
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(30, 0, 105, 1),
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text("Search Page"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Color.fromRGBO(30, 0, 105, 1),
              //Search bar, Camera button, and barcode scanning button
              child: Row(
                children: [
                  Container(
                    child: textBox,
                    width: 295,
                    height: 75,
                  ),
                  IconButton(
                    color: Colors.white,
                    padding: EdgeInsets.all(5),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("camera");
                    },
                    icon: Icon(Icons.camera_alt_sharp),
                    iconSize: 37,
                  ),
                  IconButton(
                    color: Colors.white,
                    padding: EdgeInsets.all(5),
                    constraints: BoxConstraints(),
                    onPressed: () {
                      print("barcode");
                    },
                    icon: Icon(BarcodeIcon.barcode),
                    iconSize: 35,
                  ),
                ],
              ),
            ),
            Container(
              //Icon/List buttons and Top/Artist/Album/Song buttons
              color: Color.fromRGBO(30, 0, 105, 1),
              child: Row(
                children: [
                  iconOrList(),
                  SizedBox(width: 5),
                  filterButtons(),
                ],
              ),
            ),
            //Divider between UI and output
            Container(
              color: Color.fromRGBO(30, 0, 105, 1),
              height: 5,
            ),
            Divider(
              color: Color.fromRGBO(225, 80, 129, 30),
              height: 5,
              thickness: .5,
              indent: 8,
              endIndent: 8,
            ),
          ],
        ),
      ),
    );
  }
}
