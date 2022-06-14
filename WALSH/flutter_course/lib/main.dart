import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void answer() {
    print("answer chosen");
  }

  @override
  Widget build(BuildContext context) {
    var questions = [
      "What\'s your favorite color?",
      "What\'s your favorite animal?"
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("My First App"),
        ),
        body: Column(
          children: <Widget>[
            Text("Hello World!"),
            RaisedButton(
              child: Text("Answer 1"),
              onPressed: answer,
            ),
            RaisedButton(
              child: Text("Answer 2"),
              onPressed: answer,
            ),
            RaisedButton(
              child: Text("Answer 3"),
              onPressed: answer,
            ),
          ],
        ),
      ),
    );
  }
}
