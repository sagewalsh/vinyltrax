import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TextInput extends StatefulWidget {
  final textController = TextEditingController();
  final String label;
  // const TextInput({Key? key}) : super(key: key);
  TextInput(this.label);

  Text getText() {
    return Text(textController.text);
  }

  @override
  _TextInputState createState() => _TextInputState(label, textController);
}

class _TextInputState extends State<TextInput> {
  final String label;
  final TextEditingController textController;

  _TextInputState(this.label, this.textController);

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: label,
              hintText: "Artist, Album, Song",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              suffixIcon: Icon(Icons.search),
            ),
          )),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     showDialog(
      //         context: context,
      //         builder: (context) {
      //           return AlertDialog(
      //             content: Text(textController.text),
      //           );
      //         });
      //   },
      //   child: const Icon(Icons.text_fields),
      // ),
    );
  }
}
