import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String label;
  // const TextInput({Key? key}) : super(key: key);
  const TextInput(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            hintText: "Artist, Album, Song",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            suffixIcon: Icon(Icons.search),
          ),
        ));
  }
}
