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

  String getString() {
    return textController.text;
  }

  @override
  _TextInputState createState() => _TextInputState(label, textController);
}

class _TextInputState extends State<TextInput> {
  final String label;
  final TextEditingController textController;
  FocusNode focus = FocusNode();

  _TextInputState(this.label, this.textController);

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 0, 105, 1),
      // backgroundColor: Color.fromARGB(255, 244, 244, 244),
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            // color: Color.fromARGB(255, 244, 244, 244),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 244, 244, 244),
            ),
            child: TextField(
              controller: textController,
              focusNode: focus,
              onTap: () => FocusScope.of(context).requestFocus(focus),
              decoration: InputDecoration(
                labelText: label,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: "Artist, Album, Song",
                hintStyle: TextStyle(
                  color: Color.fromRGBO(225, 80, 129, 30),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(225, 80, 129, 1),
                  ),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: focus.hasFocus
                      ? Color.fromRGBO(225, 80, 129, 1)
                      : Colors.black,
                ),
              ),
            ),
          )),
    );
  }
}
