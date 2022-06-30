import 'package:flutter/material.dart';
import 'listEntry.dart';

class ListEntryList extends StatefulWidget {
  //const ListEntryList({Key? key}) : super(key: key);

  @override
  State<ListEntryList> createState() => _ListListState();
}

class _ListListState extends State<ListEntryList> {
  List<ListEntry> itemList = [
    ListEntry("Cat1", "", true),
    ListEntry("Cat2", "", false),
    ListEntry("Cat3", "", true),
    ListEntry("Cat4", "", false),
    ListEntry("Cat6", "", false),
    ListEntry("Cat7", "", false),
    ListEntry("Cat8", "", false),
    ListEntry("Cat9", "", false),
    ListEntry("Cat10", "", false),
    ListEntry("Cat11", "", false),
    ListEntry("Cat12", "", false),
    ListEntry("Cat13", "", false),
    ListEntry("Cat14", "", false),
    ListEntry("Cat15", "", false),
  ];

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < itemList.length; i++) {
      itemList[i].color = i.isOdd ? Colors.black12 : Colors.white;
    }

    return Column(
      children: itemList,
    );
  }
}
