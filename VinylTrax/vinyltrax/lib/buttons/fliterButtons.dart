import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class filterButtons extends StatefulWidget {
  const filterButtons({Key? key}) : super(key: key);

  @override
  State<filterButtons> createState() => _filterButtonsState();
}

enum _Tab { one, two, three, four }

class _filterButtonsState extends State<filterButtons> {
  _Tab _selectedTab = _Tab.one;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: CupertinoSegmentedControl(
          padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
          selectedColor: Color.fromRGBO(225, 80, 129, 30),
          borderColor: Color.fromRGBO(225, 80, 129, 30),
          pressedColor: Color.fromRGBO(225, 80, 129, 30),
          children: {
            _Tab.one: Container(
              height: 30,
              width: 85,
              child: Center(
                child: Text("Top", style: TextStyle(fontSize: 14)),
              ),
            ),
            _Tab.two: Container(
              height: 30,
              width: 85,
              child: Center(
                child: Text("Artist", style: TextStyle(fontSize: 14)),
              ),
            ),
            _Tab.three: Container(
              height: 30,
              width: 85,
              child: Center(
                child: Text("Album", style: TextStyle(fontSize: 14)),
              ),
            ),
            _Tab.four: Container(
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
            });
          },
          groupValue: _selectedTab,
        ),
      ),
    );
  }
}
