import 'package:flutter/material.dart';
import 'package:r6_getter_test/stat_tracker_classes.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Fortnite Stat Tracker App',
      home: StatTracker(),
    );
  }
}

// Define a custom Form widget.
class StatTracker extends StatefulWidget {
  const StatTracker({super.key});


  @override
  State<StatTracker> createState() => _StatTrackerState();
}
class _StatTrackerState extends State<StatTracker>{
  String future = 'pp';
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
          hintText: 'Username',
          border: OutlineInputBorder()
      ),
      controller: username,
    );

    final platformInput = TextField(
      decoration: const InputDecoration(
          hintText: 'Platform (pc, psn, xbl)',
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
         ElevatedButton(
            onPressed: _onButtonPressed,
        //searchForAccount,
            child: const Text('Search'))

      ],
    );
    if (future == '') {
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
      return const Scaffold(
          backgroundColor: Colors.white,
          body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('player'),
          ]
          )
      );
            }
    }
  void _onButtonPressed() {
    final fetcher = StatFetcher();
    fetcher.getID(username);
    final jsonBody = fetcher.getStatJSON(username, platform);
    final playerObj = fetcher.assignStats(jsonBody);
    setState(() {
      try{
        final fetcher = StatFetcher();
        fetcher.getID(username);
        final jsonBody = fetcher.getStatJSON(username, platform);
        final playerObj = fetcher.assignStats(jsonBody);
        future = 'gay';
      } catch (e){
        future = 'There was a network error';
      }

    });
  }
}
