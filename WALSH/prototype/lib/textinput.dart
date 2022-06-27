import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Search",
              hintText: "Artist, Album, Song",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              suffixIcon: Icon(Icons.search),
            ),
          )),
    );
  }
}
