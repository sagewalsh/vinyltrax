import 'package:flutter/material.dart';

class ListEntryList extends StatelessWidget {
  //const ListEntryList({Key? key}) : super(key: key);
  List<Widget> children = <Widget>[];

  ListEntryList(this.children);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: children,
    );
  }
}

