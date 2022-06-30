import 'package:flutter/material.dart';
import 'listEntry.dart';

class ListList extends StatefulWidget {
  //const ListList({Key? key}) : super(key: key);

  @override
  State<ListList> createState() => _ListListState();
}

class _ListListState extends State<ListList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          Color color = index.isOdd ? Colors.black12 : Colors.white;
          return ShowListEntry("Cat", "", color);
        }
    );
  }
}
