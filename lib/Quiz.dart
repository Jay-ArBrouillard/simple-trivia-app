import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'QuizModel.dart';

import 'package:http/http.dart' as http;

import 'package:html_unescape/html_unescape.dart';


class Quiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _QuizState();
  }

}

class _QuizState extends State<Quiz> {
  final String apiURL = "https://opentdb.com/api.php?amount=10";
  QuizModel quizModel;
  int currentQuestion = 0;
  int elapsedSeconds = 0;
  int numCorrect = 0;
  int numIncorrect = 0;

  Timer timer;

  @override
  void initState() {
      //Fetch question
      fetchQuizQuestions();

      super.initState();
  }

  fetchQuizQuestions() async {
    var response = await http.get(apiURL);
    var body = response.body;

    var json = jsonDecode(body);

    setState(() {
      quizModel = QuizModel.fromJson(json);
      var unescape = new HtmlUnescape();
      
      for (int i = 0; i < 10; i += 1) {
        //Convert question
        quizModel.results[i].question = unescape.convert(quizModel.results[i].question);
        //Convert answers
        quizModel.results[i].incorrectAnswers.add(
          quizModel.results[i].correctAnswer
        );
        quizModel.rQesults[i].incorrectAnswers.shuffle();

        List<String> tempList = quizModel.results[i].incorrectAnswers;
        for (int j = 0; j < tempList.length; j += 1) {
          String ans = tempList[j];
          quizModel.results[i].incorrectAnswers[j] = unescape.convert(ans);
        }
      }

      initTimer();
    });
  }

  void initTimer() {
    timer = Timer.periodic(Duration(seconds: 1),
     (t) {
        setState(() {
          elapsedSeconds = t.tick;
        });
     }
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void isAnswerCorrect(String answer) {
    String correctAnswer = quizModel.results[currentQuestion].correctAnswer;
    if (correctAnswer.toUpperCase() == answer.toUpperCase()) {
      setState(() {
        numCorrect += 1;
      });
    }
    else {
      setState(() {
        numIncorrect += 1;
      });
    }

    // Sleep 2 second before changing the question
    new Future.delayed(const Duration(seconds: 2), () => "2");
    setState(() {
      changeQuestion();
    });
  }

  void changeQuestion() {
    if (currentQuestion == 9) {
      setState(() {
        currentQuestion = 0;
        timer.cancel();
        fetchQuizQuestions();
      });
    }
    else {
      setState(() {
        currentQuestion += 1;
        timer.cancel();
        initTimer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (quizModel != null) {
      return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget> [

                // TIMER
                Container(
                  margin: EdgeInsets.fromLTRB(20, 60, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image(
                        image: AssetImage("assets/icon-circle.png"),
                        width: 70,
                        height: 70,
                      ),

                      Text(
                        "$elapsedSeconds s",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18
                        ),
                      ),
                    ],
                  ),
                ),

                // CORRECT AND INCORRECT ANSWERS
                Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.thumb_up_outlined,
                            color: Colors.green,
                            size: 36.0,
                          ),
                          Text("$numCorrect")
                        ],
                      ),

                      Column(
                        children: [
                          Icon(
                            Icons.thumb_down_outlined,
                            color: Colors.red,
                            size: 36.0,
                          ),
                          Text("$numIncorrect")
                        ],
                      )

                    ],
                  ),
                ),

                // QUESTION
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Q. ${quizModel.results[currentQuestion].question}",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  textAlign: TextAlign.center,
                  ),
                ),

                // ANSWERS
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 40,
                  ),
                  child: Column(
                    children: quizModel.results[currentQuestion].incorrectAnswers.map((option) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: RaisedButton(
                          color: Colors.cyan,
                          colorBrightness: Brightness.dark,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 20,
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 18,
                            )
                          ),
                          onPressed: () {
                            isAnswerCorrect(option);
                          }
                        )
                      );
                    }).toList(),
                  ),
                ),


                // NEW QUESTION
                RaisedButton(
                  color: Colors.cyan,
                  colorBrightness: Brightness.dark,
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10,
                  ),
                  child: Text("New Question",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    changeQuestion();
                }),
              ],
            ),
          ),
        ),
      );
    }
    else { // Loading screen
      return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          )
        ),
      );
    }
  }
}