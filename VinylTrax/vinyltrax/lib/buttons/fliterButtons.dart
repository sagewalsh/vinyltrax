import 'package:flutter/cupertino.dart';

class FilterButtons extends StatefulWidget {
  const FilterButtons({Key? key}) : super(key: key);

  @override
  State<FilterButtons> createState() => _FilterButtonsState();
}

enum _Tab { one, two, three, four }

class _FilterButtonsState extends State<FilterButtons> {
  _Tab _selectedTab = _Tab.one;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: CupertinoSegmentedControl(
          padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
          selectedColor: Color(0xFFFF5A5A),
          borderColor: Color(0xFFFF5A5A),
          pressedColor: Color(0x64FF5A5A),
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
