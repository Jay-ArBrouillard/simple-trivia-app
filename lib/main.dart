import 'package:flutter/material.dart';
import 'package:flutter_course/Quiz.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}


class MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "productsans"),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        child:SingleChildScrollView(
          child: Column(
            // Column accepts multiple children widgets
            children: <Widget> [
              SizedBox(
                height: 90
              ),

              Center(child:
                Image(
                  image: AssetImage("assets/icon-circle.png"),
                  width: 300,
                  height: 300,
                )
              ),

              Text("Quizimus",
                style: 
                  TextStyle(
                    color: Color(0xFFA20CBE),
                    fontSize: 80,
                  )
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 40,
                  ),
                  child: 
                    Text("PLAY",
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  color: Color(0xFFFFBA00),
                  textColor: Colors.white,
                  
                  onPressed: () {
                    //go to quiz screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Quiz()
                      )
                    );
                  },
                ),
              ),
            ]
          ),
        )
      ),
    );
  }
  
}