import 'package:flutter/material.dart';
import 'icon.dart';

class IconList extends StatelessWidget {
  //IconList({Key? key}) : super(key: key);

  List<Widget> children = <Widget>[];

  IconList(this.children);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
            direction: Axis.horizontal,
            spacing: 30,
            runSpacing: 20,
            children: children),
      ),
    );
  }
}
