import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../textinput.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

enum _Tab {one, two}

class _SearchPageState extends State<SearchPage> {
  _Tab _selectedTab = _Tab.one;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text("Search Page"),
        ),
      ),
      body: Column(
        children: [
          TextInput(),
          Row(
            children: [
              CupertinoSegmentedControl(
                padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                selectedColor: Colors.black,
                borderColor: Colors.black,
                pressedColor: Colors.grey,
                children: {
                  _Tab.one: Container(
                    height: 30,
                    width: 70,
                    child: Center(
                      child: Text("Icon"),
                    ),
                  ),
                  _Tab.two: Container(
                    height: 20,
                    width: 70,
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}