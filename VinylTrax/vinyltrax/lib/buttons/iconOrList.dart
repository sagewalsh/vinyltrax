import 'package:flutter/cupertino.dart';

class IconOrList extends StatefulWidget {
  const IconOrList({Key? key}) : super(key: key);

  @override
  State<IconOrList> createState() => _IconOrListState();
}

enum _Tab { one, two }

class _IconOrListState extends State<IconOrList> {
  _Tab _selectedTab = _Tab.one;

  @override
  Widget build(BuildContext context) {
    return CupertinoSegmentedControl(
      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      selectedColor: Color.fromRGBO(225, 80, 129, 30),
      borderColor: Color.fromRGBO(225, 80, 129, 30),
      pressedColor: Color.fromRGBO(225, 80, 129, 30),
      children: {
        _Tab.one: Container(
          height: 30,
          width: 80,
          child: Center(
            child: Text("Icon", style: TextStyle(fontSize: 14)),
          ),
        ),
        _Tab.two: Container(
          height: 30,
          width: 80,
          child: Center(
            child: Text("List", style: TextStyle(fontSize: 14)),
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
