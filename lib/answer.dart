import 'package:flutter/material.dart';

import './main.dart';

class AnswerWidget extends StatefulWidget {
  final Future<Question> futureQuestion;
  AnswerWidget(this.futureQuestion);

  @override
  State<StatefulWidget> createState() {
    return new AnswerWidgetState(futureQuestion);
  }
}

class AnswerWidgetState extends State<AnswerWidget> {
  final Future<Question> futureQuestion;
  Color _buttonColor1 = Colors.grey;

  AnswerWidgetState(this.futureQuestion);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: 
        FutureBuilder<Question>(
          future: futureQuestion,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data.choices);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for(String item in snapshot.data.choices) 
                    RaisedButton(
                      color: _buttonColor1,
                      child: Text(item), 
                      onPressed: () {
                        setState(() {
                          if (item == snapshot.data.correctAnswer) {
                            _buttonColor1 = Colors.green;
                          }
                          else {
                            _buttonColor1 = Colors.red;
                          }
                        });
                      }
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