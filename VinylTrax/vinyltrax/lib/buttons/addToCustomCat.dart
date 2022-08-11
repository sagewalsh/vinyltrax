import 'package:flutter/material.dart';
import '../inventory/database.dart';

class AddToCustomCat extends StatefulWidget {
  final String albumID;
  final List<String> categories;

  AddToCustomCat(this.albumID, this.categories);

  @override
  State<AddToCustomCat> createState() => _AddToCustomCatState();
}

class _AddToCustomCatState extends State<AddToCustomCat> {
  String currentCategory = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Select Category:"),
          DropdownButton(
              value: currentCategory,
              items: widget.categories.map((value){
                return DropdownMenuItem(
                    value: value, child: Text(value));
              }).toList(),
              onChanged: (String? value) {
                setState ((){
                  currentCategory = value!;
                });
              })
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Database.addCatTag(widget.albumID, currentCategory);
              Navigator.pop(context);
            },
            child: Text("Confirm")
        ),
        TextButton(
            onPressed: () {Navigator.pop(context);},
            child: Text("Cancel")
        )
      ],
    );
  }
}
