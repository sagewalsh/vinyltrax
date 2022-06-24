import 'package:flutter/material.dart';
import './quiz.dart';
import './result.dart';

// void main() => runApp(MyApp());

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

// _NAME means that the class is private and can only be used in
// this file
class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;

  final _questions = const [
    {
      "questionText": "What's your favorite color?",
      "answers": ["blue", "red", "green", "yellow"]
    },
    {
      "questionText": "What's your favorite animal?",
      "answers": ["dog", "cat", "horse", "turtle"]
    },
    {
      "questionText": "What's your favorite food?",
      "answers": ["thai", "italian", "mexican"]
    }
  ];

  void _answerQuestion() {
    setState(() {
      if (_questionIndex < _questions.length) {
        _questionIndex = _questionIndex + 1;
      } else {
        // _questionIndex = 0;
      }
    });
    print(_questionIndex);
    print("Answer chosen");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("My First App"),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                answerQuestion: _answerQuestion,
                questionIndex: _questionIndex,
                questions: _questions)
            : Result(),
      ),
    );
  }
}
