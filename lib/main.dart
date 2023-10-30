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
  String currentPlayer = '';
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

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
          hintText: 'Account ID',
          border: OutlineInputBorder()
      ),
      controller: controller1,
    );

    final platformInput = TextField(
      decoration: const InputDecoration(
          hintText: 'Platform (PC, PlayStation, Xbox)',
          border: OutlineInputBorder()
      ),
      controller: controller2,
    );

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
    if (currentPlayer == '') {
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
      return Scaffold(
          backgroundColor: Colors.white,
          body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.grey,

                ),
              child: Center(
                child: Text(currentPlayer,
                style:  const TextStyle(
                color: Colors.blue,
                  fontSize: 40,
            ),
            ),

          ),
            ),
            ElevatedButton(onPressed: _onPressed,
              child: const Text('Return to Home'
              ),
            ),
    ]),

          );
            }
    }
    String organizeStats(PlayerStats player){
      String organizedStats = 'Username: ${player.getUsername()}'
          '\nLevel: ${player.getLevel()}\nK/D: ${player.getPlayerKD()}'
          '\nWin Rate: ${player.getPlayerWinRate()}\nEliminations: ${player.getPlayerKills()}\n'
          'Matches Played: ${player.getMatchesPlayed()}\n';
      return organizedStats;
    }
  void _onButtonPressed()async{
    final fetcher = StatFetcher();
    final username = controller1.text;
    final platform = controller2.text;
      final playerID = await fetcher.getID(username);
      if(playerID==null){
        currentPlayer = 'Account ID Invalid';
        setState(() {

        });
      }else {
        final jsonBody = await fetcher.getStatJSON(playerID, platform);
        final playerObj = fetcher.assignStats(jsonBody);
        final stats = organizeStats(playerObj);
        setState(() {
          try{
            currentPlayer = stats;
          } catch (e){
            currentPlayer = 'There was a network error';
          }
        });
      }
  }
  void _onPressed(){
    setState(() {
      currentPlayer = '';
      controller2.clear();
      controller1.clear();
    });
  }
}


