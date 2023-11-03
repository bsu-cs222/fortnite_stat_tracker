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

class _StatTrackerState extends State<StatTracker> {
  String currentPlayer = '';
  TextEditingController accountIDInput = TextEditingController();
  TextEditingController accountPlatformInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const homeTitle = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Fortnite Stat\nTracker',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 40,
          ),
        ),
      ],
    );

    final usernameInput = TextField(
      decoration: const InputDecoration(
          hintText: 'Account ID', border: OutlineInputBorder()),
      controller: accountIDInput,
    );

    final platformInput = TextField(
      decoration: const InputDecoration(
          hintText: 'Platform (PC, PlayStation, Xbox)',
          border: OutlineInputBorder()),
      controller: accountPlatformInput,
    );

    final textColumn = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        usernameInput,
        const SizedBox(height: 10.0, width: 10.0),
        platformInput,
        const SizedBox(height: 5.0, width: 5.0),
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
              const Expanded(
                child: homeTitle,
              ),
              Expanded(
                child: textColumn,
              ),
            ],
          ));
    } else {
      return Scaffold(
        backgroundColor: Colors.grey,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.blueAccent,
                ),
                child: Center(
                  child: Text(
                    currentPlayer,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _onPressed,
                child: const Text('Return to Home'),
              ),
            ]),
      );
    }
  }

  String organizeStats(jsonBody) {
    final player = PlayerStatsAssigner();
    player.assignJsonStats(jsonBody);
    String organizedStats = 'Username: ${player.username}'
        '\nLevel: ${player.level}\nK/D: ${player.kD}'
        '\nWin Rate: ${player.winRate}\nEliminations: ${player.winRate}\n'
        'Matches Played: ${player.matchesPlayed}\n';
    return organizedStats;
  }

  void _onButtonPressed() async {
    final fetcher = StatFetcher();
    final username = accountIDInput.text;
    final platform = accountPlatformInput.text;
    final playerID = await fetcher.getID(username);
    if (playerID == null) {
      currentPlayer = 'Account ID Invalid';
      setState(() {});
    } else {
      String jsonBody = await fetcher.getStatJSON(playerID, platform);
      final stats = organizeStats(jsonBody);
      setState(() {
        try {
          currentPlayer = stats;
        } catch (e) {
          currentPlayer = 'There was a network error';
        }
      });
    }
  }

  void _onPressed() {
    setState(() {
      currentPlayer = '';
      accountPlatformInput.clear();
      accountIDInput.clear();
    });
  }
}
