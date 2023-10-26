import 'package:flutter/material.dart';
import 'package:r6_getter_test/stat_tracker_classes.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fortnite Stat Tracker App',
      home: StatTracker(),
    );
  }
}

// Define a custom Form widget.
class StatTracker extends StatefulWidget {

  @override
  State<StatTracker> createState() => _StatTrackerState();
}
class _StatTrackerState extends State<StatTracker>{
  Future<Player>? future;
  TextEditingController username = TextEditingController();
  TextEditingController platform = TextEditingController();

  @override
  Widget build(BuildContext context) {

    const homeTitle = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Fortnite Stat\nTracker',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 40,
          ),
        ),
      ],
    );

    final usernameInput = TextField(
      decoration: const InputDecoration(
          hintText: 'Platform (PC, Playstation, Xbox)',
          border: OutlineInputBorder()
      ),
      controller: username,
    );

    final platformInput = TextField(
      decoration: const InputDecoration(
          hintText: 'Platform (PC, Playstation, Xbox)',
          border: OutlineInputBorder()
      ),
      controller: platform,
    );

    //void searchForAccount(){
      //setState((){
        //null;
     // });
   // }

    final textColumn =  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        usernameInput,
        const SizedBox(height: 10.0, width: 10.0),
        platformInput,
        const SizedBox(height:5.0, width: 5.0),
        const ElevatedButton(onPressed:
        //searchForAccount,
        null,
            child: Text('Search'))

      ],
    );
    if (future == null) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child:
                homeTitle,
              ),
              Expanded(child:
                textColumn,
              ),
            ],
          )
      );
    } else {
      return FutureBuilder(
          future: (future),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('${snapshot.data}');
            } else {
              return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Text('Loading',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 30,
                          )),
                    ),
                  ]);
            }
          });
    }
  }
}
