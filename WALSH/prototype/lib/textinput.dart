import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
          )
        ],
      ),
    );
  }
}
