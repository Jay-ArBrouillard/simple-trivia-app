import 'package:flutter/material.dart';

import './main.dart';

class MyAnswerWidget extends StatefulWidget {
  Future<Question> futureQuestion;
  Function func;

  MyAnswerWidget(this.futureQuestion, this.func);
  @override
  State<StatefulWidget> createState() {
    return AnswerWidget(futureQuestion, func);
  }
  
}

class AnswerWidget extends State<MyAnswerWidget> {
  Future<Question> futureQuestion;
  int showColor = 0;
  Function func;

  AnswerWidget(Future<Question> futureQuestion, Function func) {
      this.futureQuestion = futureQuestion;
      this.func = func;
  }

  void temp() {
    setState(() {
      showColor = 1;
    });
    new Future.delayed(const Duration(seconds: 2), () => "2");
    func.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: 
        FutureBuilder<Question>(
          future: futureQuestion,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var entry in snapshot.data.choices.entries)
                    RaisedButton(
                      color: showColor == 1 ? entry.value ? Colors.green : Colors.red : Colors.grey,
                      child: Text(entry.key), 
                      onPressed: temp
                    ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
    );
  }
}