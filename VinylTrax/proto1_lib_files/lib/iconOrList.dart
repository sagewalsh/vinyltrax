import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class iconOrList extends StatefulWidget {
  const iconOrList({Key? key}) : super(key: key);

  @override
  State<iconOrList> createState() => _iconOrListState();
}

enum _Tab { one, two }

class _iconOrListState extends State<iconOrList> {
  _Tab _selectedTab = _Tab.one;

  @override
  Widget build(BuildContext context) {
    return CupertinoSegmentedControl(
      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      selectedColor: const Color.fromARGB(255, 120, 120, 120),
      borderColor: const Color.fromARGB(255, 120, 120, 120),
      pressedColor: Colors.grey,
      children: {
        _Tab.one: Container(
          height: 30,
          width: 80,
          child: Center(
            child: Text("Icon"),
          ),
        ),
        _Tab.two: Container(
          height: 30,
          width: 80,
          child: Center(
            child: Text("List"),
          ),
        ),
      },
      onValueChanged: (value) {
        setState(() {
          _selectedTab = value as _Tab;
        });
      },
      groupValue: _selectedTab,
    );
  }
}
