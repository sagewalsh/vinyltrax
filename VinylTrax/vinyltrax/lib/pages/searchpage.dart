import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vinyltrax/button_icons/barcode.dart';
import '../discogs/disDetails.dart';
import '../discogs/disResults.dart';
import 'settingspage.dart' as settings;
//import 'package:camera/camera.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

enum _Tab { one, two, three }

class _SearchPageState extends State<SearchPage> {
  String? scanResult; //use this to get the barcode number of an album
  _Tab _selectedTab = _Tab.one;

  Widget output = SizedBox();
  final TextEditingController textController = TextEditingController();
  FocusNode focus = FocusNode();
  String searchText = "";

  Widget AddFilterButtons(String text) {
    if (settings.listBool) {
      return Container(
        //Icon/List buttons and Top/Artist/Album/Song buttons
        color: settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
        padding: EdgeInsets.only(bottom: 5, top: 10),
        child: SizedBox(
          height: 30,
          child: CupertinoSegmentedControl(
              padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              selectedColor: settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
              borderColor: settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
              pressedColor: settings.darkTheme ? Color(0x64BB86FC) : Color(0x64FF5A5A),
              children: {
                _Tab.one: Container(
                  height: 30,
                  width: 85,
                  child: Center(
                    child: Text("Artist", style: TextStyle(fontSize: 14)),
                  ),
                ),
                _Tab.two: Container(
                  height: 30,
                  width: 85,
                  child: Center(
                    child: Text("Album", style: TextStyle(fontSize: 14)),
                  ),
                ),
                _Tab.three: Container(
                  height: 30,
                  width: 85,
                  child: Center(
                    child: Text("Song", style: TextStyle(fontSize: 14)),
                  ),
                ),
              },
              onValueChanged: (value) {
                setState(() {
                  _selectedTab = value as _Tab;
                  output = DisResults(text, _selectedTab.name);
                });
              },
              groupValue: _selectedTab,
            ),
          ),
      );
    } else
      return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    double toolbarHeight = 110;
    if (settings.listBool)
      toolbarHeight = 160;
    else
      toolbarHeight = 110;

    return SafeArea(
      child: Scaffold(
        backgroundColor: settings.darkTheme ? Color(0xFF1C1C1C) : Color(0xFFFFFDF6),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 10,
          toolbarHeight: toolbarHeight,
          backgroundColor: settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
          title: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text("Search Page",
                    style: TextStyle(color: settings.darkTheme ? Colors.white : Colors.black)),
              ),
              Container(
                color: settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
                //Search bar, Camera button, and barcode scanning button
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.68,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Container(
                            // color: Color.fromARGB(255, 244, 244, 244),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
                            ),
                            child: TextField(
                              style: TextStyle(color: settings.darkTheme ? Colors.white : Colors.black),
                              textAlignVertical: TextAlignVertical.center,
                              controller: textController,
                              focusNode: focus,
                              onTap: () =>
                                  FocusScope.of(context).requestFocus(focus),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: settings.darkTheme ? Colors.white : Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                contentPadding: EdgeInsets.only(left: 15),
                                isCollapsed: true,
                                labelText: "Search Discogs",
                                labelStyle: TextStyle(color: settings.darkTheme ? Colors.white : Colors.black),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                hintText: "Artist, Album, Song",
                                hintStyle: TextStyle(
                                  color: settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: settings.darkTheme ? Colors.white : Colors.black),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: focus.hasFocus
                                      ? settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A)
                                      : settings.darkTheme ? Colors.white : Colors.black,
                                ),
                              ),
                              onSubmitted: (text) {
                                setState(() {
                                  this.searchText = text;
                                  output = DisResults(text, _selectedTab.name);
                                });
                              },
                            ),
                          )),
                    ),
                    IconButton(
                      color: settings.darkTheme ? Colors.white : Colors.black,
                      padding: EdgeInsets.fromLTRB(
                          5, 0, 5, 0),
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.pushNamed(context, 'camera');
                      },
                      icon: Icon(Icons.photo_camera),
                      iconSize: MediaQuery.of(context).size.width * 0.1,
                    ),
                    IconButton(
                      color: settings.darkTheme ? Colors.white : Colors.black,
                      padding: EdgeInsets.fromLTRB(
                          5, 0, 5, 0),
                      constraints: BoxConstraints(),
                      onPressed: scanBarcode,
                      icon: Icon(BarcodeIcon.barcode),
                      iconSize: MediaQuery.of(context).size.width * 0.085,
                    ),
                  ],
                ),
              ),
              AddFilterButtons(searchText),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: settings.darkTheme ? [Color(0xFF181818), Color(0xFF222222)] : [Color(0xFFFFFDF6), Color(0xFFFFFDF6)]
            ),
          ),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Divider between UI and output
                Container(
                  color: settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
                  height: 5,
                ),
                output
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dispose() {
    textController.dispose();
    super.dispose();
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
    setState(() {
      this.scanResult = scanResult;
      if (scanResult == "-1")
        Navigator.pushNamed(context, 'search');
      else {
        // Under here is where you use the scan results information to do whatever you need
        var route = new MaterialPageRoute(builder: (BuildContext context) {
          return new DisDetails([scanResult, ""], true);
        });
        Navigator.of(context).push(route);
      }
      // print(scanResult);
    });
  }
}
