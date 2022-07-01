import 'package:flutter/material.dart';
import 'listEntry.dart';

class ListEntryList extends StatelessWidget {
  //const ListEntryList({Key? key}) : super(key: key);
  List<Widget> children = <Widget>[];

  ListEntryList(this.children);

  @override
  Widget build(BuildContext context) {
    // for (int i = 0; i < children.length; i++) {
    //   if (children is ListEntry) {
    //     children[i].color = i.isOdd ? Colors.black12 : Colors.white;
    //   }
    // }

    return Column(
      children: children,
    );
  }
}

