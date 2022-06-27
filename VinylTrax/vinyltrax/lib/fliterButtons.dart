import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class filterButtons extends StatefulWidget {
  const filterButtons({Key? key}) : super(key: key);

  @override
  State<filterButtons> createState() => _filterButtonsState();
}

enum _Tab {one, two, three, four}

class _filterButtonsState extends State<filterButtons> {
  _Tab _selectedTab = _Tab.one;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: CupertinoSegmentedControl(
            padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            selectedColor: Colors.black,
            borderColor: Colors.black,
            pressedColor: Colors.grey,
            children: {
              _Tab.one: Container(
                height: 40,
                width: 80,
                child: Center(
                  child: Text("Top"),
                ),
              ),
              _Tab.two: Container(
                height: 40,
                width: 80,
                child: Center(
                  child: Text("Artist"),
                ),
              ),
              _Tab.three: Container(
                height: 40,
                width: 80,
                child: Center(
                  child: Text("Album"),
                ),
              ),
              _Tab.four: Container(
                height: 40,
                width: 80,
                child: Center(
                  child: Text("Song"),
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
