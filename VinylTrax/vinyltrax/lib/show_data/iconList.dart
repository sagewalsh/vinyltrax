import 'package:flutter/material.dart';

class IconList extends StatelessWidget {
  //IconList({Key? key}) : super(key: key);

  List<Widget> children = <Widget>[];

  IconList(this.children);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.0765,
          vertical: MediaQuery.of(context).size.height * 0.0062),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
              direction: Axis.horizontal,
              spacing: MediaQuery.of(context).size.width * 0.0765,
              runSpacing: MediaQuery.of(context).size.width * 0.051,
              children: children),
        ),
      ),
    );
  }
}
