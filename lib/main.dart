import 'package:flutter/material.dart';
import 'package:flutter_course/answer.dart';
import 'package:html_unescape/html_unescape.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import './question.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

Future<Question> fetchQuestion() async {
  final response = await http.get('https://opentdb.com/api.php?amount=1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Question.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Question');
  }
}

class MyAppState extends State<MyApp> {
  Future<Question> _futureQuestion;

  @override
  void initState() {
    super.initState();
    _futureQuestion = fetchQuestion();
  }

  void _getNewQuestion() {
    setState(() {
      _futureQuestion = fetchQuestion();
    
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Trivia Application'),
        ),
        body: Column(
            children: <Widget>[
              QuestionWidget(_futureQuestion),
              AnswerWidget(_futureQuestion),
              RaisedButton(child: Text('New Question'), onPressed: _getNewQuestion),
            ],
        ),
      ),
    );
  }
}

class Question {
  Future<Question> futureQuestion;
  final String questionText;
  final String category;
  final String difficulty;
  final String type;
  final String correctAnswer;
  final List<String> choices;

  Question({this.questionText, this.category, this.difficulty, this.type, this.correctAnswer,
            this.choices});

  factory Question.fromJson(Map<String, dynamic> json) {
    Question question = new Question(
      questionText: json['results'][0]['question'],
      category: json['results'][0]['category'],
      difficulty: json['results'][0]['difficulty'],
      type: json['results'][0]['type'],
      correctAnswer: json['results'][0]['correct_answer'],
      choices: json['results'][0]['incorrect_answers'].cast<String>(),
    );
    question.choices.add(json['results'][0]['correct_answer']);
    question.choices.shuffle();
    // print(question.choices);
    return question;
  }

  String getDisplayQuestion() {
    var unescape = new HtmlUnescape();
    return unescape.convert(questionText);
  }
}


