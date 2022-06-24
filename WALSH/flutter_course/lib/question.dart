import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  // const MyWidget({Key? key}) : super(key: key);

  final String questionText;

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    // Container
    //  child: content of container
    //  padding: surrounds the content
    //  border: surrounds the padding
    //  margin: surrounds the border
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(15.0),
      child: Text(
        questionText,
        style: const TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
      ),
    );
  }
}
