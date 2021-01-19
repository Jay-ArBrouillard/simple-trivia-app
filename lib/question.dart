import 'package:flutter/material.dart';

import './main.dart';

class QuestionWidget extends StatelessWidget {
  final Future<Question> futureQuestion;

  QuestionWidget(this.futureQuestion);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: 
        FutureBuilder<Question>(
          future: futureQuestion,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.getDisplayQuestion());
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