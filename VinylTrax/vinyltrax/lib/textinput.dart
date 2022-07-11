import 'package:flutter/material.dart';
import 'pages/invResults.dart';
import 'pages/disResults.dart';

class TextInput extends StatefulWidget {
  final textController = TextEditingController();
  final String label;
  final bool isInventory;
  late Widget output = SizedBox();
  // const TextInput({Key? key}) : super(key: key);
  TextInput(this.label, this.isInventory);

  Text getText() {
    return Text(textController.text);
  }

  String getString() {
    return textController.text;
  }

  @override
  _TextInputState createState() =>
      _TextInputState(label, textController, isInventory);
}

class _TextInputState extends State<TextInput> {
  final String label;
  final TextEditingController textController;
  final bool isInventory;
  FocusNode focus = FocusNode();

  _TextInputState(this.label, this.textController, this.isInventory);

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFEF9),
      // backgroundColor: Color.fromARGB(255, 244, 244, 244),
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            // color: Color.fromARGB(255, 244, 244, 244),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFFFFFEF9),
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
                  color: Color(0xFFFF5A5A),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Color(0xFFFF5A5A),
                  ),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: focus.hasFocus ? Color(0xFFFF5A5A) : Colors.black,
                ),
              ),
              onSubmitted: (text) {
                isInventory
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                        return InvResults(text);
                      }))
                    : setState((){
                  widget.output = DisResults(text);
                });
              },
            ),
          )),
    );
  }
}
