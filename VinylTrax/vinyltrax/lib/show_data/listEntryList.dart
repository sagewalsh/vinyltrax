import 'package:flutter/material.dart';
import 'listEntry.dart';

class ListEntryList extends StatefulWidget {
  const ListEntryList({Key? key}) : super(key: key);

  @override
  State<ListEntryList> createState() => _ListListState();
}

class _ListListState extends State<ListEntryList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          Color color = index.isOdd ? Colors.black12 : Colors.white;
          List<ListEntry> itemList = [
            ListEntry("Cat1", "", true),
            ListEntry("Cat2", "", false),
            ListEntry("Cat3", "", true),
            ListEntry("Cat4", "", false),
            ListEntry("Cat5", "", false),
          ];
          itemList[index].color = color;
          return itemList[index];
        }
    );
  }
}
