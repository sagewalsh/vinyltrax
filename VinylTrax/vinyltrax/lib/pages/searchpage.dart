import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vinyltrax/button_icons/barcode.dart';
import 'disResults.dart';
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
        color: Color(0xFFFFFEF9),
        child: SizedBox(
          height: 30,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: CupertinoSegmentedControl(
              padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              selectedColor: Color(0xFFFF5A5A),
              borderColor: Color(0xFFFF5A5A),
              pressedColor: Color(0x64FF5A5A),
              children: {
                // _Tab.one: Container(
                //   height: 30,
                //   width: 85,
                //   child: Center(
                //     child: Text("Top", style: TextStyle(fontSize: 14)),
                //   ),
                // ),
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
        ),
      );
    }
    else
      return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    double toolbarHeight = 130;
    if (settings.listBool)
      toolbarHeight = 170;
    else
      toolbarHeight = 130;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFFFFEF9),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 10,
          toolbarHeight: toolbarHeight,
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
                      child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            // color: Color.fromARGB(255, 244, 244, 244),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFFFFFEF9),
                            ),
                            child: TextField(
                              controller: textController,
                              focusNode: focus,
                              onTap: () =>
                                  FocusScope.of(context).requestFocus(focus),
                              decoration: InputDecoration(
                                labelText: "Search",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                hintText: "Artist, Album, Song",
                                hintStyle: TextStyle(
                                  color: Color(0xFFFF5A5A),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5A5A),
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: focus.hasFocus
                                      ? Color(0xFFFF5A5A)
                                      : Colors.black,
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
                      width: MediaQuery.of(context).size.width * 0.70,
                      height: MediaQuery.of(context).size.height * 0.09,
                    ),
                    IconButton(
                      color: Colors.black,
                      padding: EdgeInsets.all(5),
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.pushNamed(context, 'camera');
                      },
                      icon: Icon(Icons.camera_alt_sharp),
                      iconSize: MediaQuery.of(context).size.width * 0.1,
                    ),
                    IconButton(
                      color: Colors.black,
                      padding: EdgeInsets.all(5),
                      constraints: BoxConstraints(),
                      onPressed: scanBarcode,
                      icon: Icon(BarcodeIcon.barcode),
                      iconSize: MediaQuery.of(context).size.width * 0.094,
                    ),
                  ],
                ),
              ),
              AddFilterButtons(searchText),
            ],
          ),
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Divider between UI and output
              Container(
                color: Color(0xFFFFFEF9),
                height: 5,
              ),
              output
            ],
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
      // Under here is where you use the scan results information to do whatever you need
      // print(scanResult);
    });
  }
}
