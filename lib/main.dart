import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GradeHelp App',
      home: EnterPercentage(),
    );
  }
}

// Define a custom Form widget.
class EnterPercentage extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final homeTitle = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Fortnite\nStat \nTracker',
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 40,
          ),
        ),
      ],
    );

    final usernameInput = TextField(
      decoration: InputDecoration(
          hintText: 'Platform (PC, Playstation, Xbox)',
          border: OutlineInputBorder()
      ),
    );

    final platformInput = TextField(
      decoration: InputDecoration(
          hintText: 'Platform (PC, Playstation, Xbox)',
          border: OutlineInputBorder()
      ),
    );

    final textColumn = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        usernameInput,
        SizedBox(height: 10.0, width: 10.0),
        platformInput,
        SizedBox(height:5.0, width: 5.0),

      ],
    );

    return Scaffold(
        backgroundColor: Colors.blue,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center ,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child:
            homeTitle,
            ),
            Expanded(child:
            textColumn,
            )
          ],
        )
    );
  }
}