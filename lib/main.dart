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
  String currentPlayerUsername = '';
  TextEditingController accountIDInput = TextEditingController();
  TextEditingController accountPlatformInput = TextEditingController();
  final platformList = <String>[
    "Select a platform",
    "PC",
    "Playstation",
    "Xbox"
  ];
  final gamemodeList = <String>[
    'Select a game mode',
    'Overall Stats',
    'Solo',
    'Duos',
    'Trios',
    'Squads'
  ];
  String playerPlatform = '';
  String playerGameMode = '';

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

    final platformDropdown = DropdownButtonFormField<String>(
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
          width: 1,
          color: Colors.grey,
        ))),
        value: platformList.first,
        items: platformList
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                  ),
                ))
            .toList(),
        onChanged: (item) => setState(() => playerPlatform = item!));

    final gamemodeDropDown = DropdownButtonFormField<String>(
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
          width: 1,
          color: Colors.grey,
        ))),
        value: gamemodeList.first,
        items: gamemodeList
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                  ),
                ))
            .toList(),
        onChanged: (item) => setState(() => playerGameMode = item!));

    final textColumn = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        usernameInput,
        const SizedBox(height: 10.0, width: 10.0),
        platformDropdown,
        const SizedBox(height: 10.0, width: 10.0),
        gamemodeDropDown,
        const SizedBox(height: 5.0, width: 5.0),
        ElevatedButton(
            onPressed: _onButtonPressed,
            //searchForAccount,
            child: const Text('Search'))
      ],
    );
    if (currentPlayerUsername == '') {
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
                    currentPlayerUsername,
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

  String organizeStats(String jsonBody, String playerGameMode) {
    final player = Player();
    player.assignAllStats(jsonBody);
    String organizedStats = '';
    switch (playerGameMode) {
      case 'Overall Stats':
        organizedStats = 'Overall Stats:'
            '\nUsername: ${player.username}'
            '\nLevel: ${player.level}\nK/D: ${double.parse(player.overallKD.toStringAsFixed(2))}'
            '\nWin Rate: ${double.parse(player.overallWinRate.toStringAsFixed(2))}'
            '\nEliminations: ${player.overallEliminations}\n'
            'Matches Played: ${player.overallMatchesPlayed}\n';
      case 'Solo':
        organizedStats = 'Solo Stats:'
            '\nUsername: ${player.username}'
            '\nLevel: ${player.level}\nK/D: ${double.parse(player.kDList[0].toStringAsFixed(2))}'
            '\nWin Rate: ${double.parse(player.winrateList[0].toStringAsFixed(2))}'
            '\nEliminations: ${player.eliminationsList[0]}\n'
            'Matches Played: ${player.matchesPlayedList[0]}\n';
      case 'Duos':
        organizedStats = 'Duo Stats:'
            '\nUsername: ${player.username}'
            '\nLevel: ${player.level}\nK/D: ${double.parse(player.kDList[1].toStringAsFixed(2))}'
            '\nWin Rate: ${double.parse(player.winrateList[1].toStringAsFixed(2))}'
            '\nEliminations: ${player.eliminationsList[1]}\n'
            'Matches Played: ${player.matchesPlayedList[1]}\n';
      case 'Trios':
        organizedStats = 'Trio Stats:'
            '\nUsername: ${player.username}'
            '\nLevel: ${player.level}\nK/D: ${double.parse(player.kDList[2].toStringAsFixed(2))}'
            '\nWin Rate: ${double.parse(player.winrateList[2].toStringAsFixed(2))}'
            '\nEliminations: ${player.eliminationsList[2]}\n'
            'Matches Played: ${player.matchesPlayedList[2]}\n';
      case 'Squads':
        organizedStats = 'Squad Stats:'
            '\nUsername: ${player.username}'
            '\nLevel: ${player.level}\nK/D: ${double.parse(player.kDList[3].toStringAsFixed(2))}'
            '\nWin Rate: ${double.parse(player.winrateList[3].toStringAsFixed(2))}'
            '\nEliminations: ${player.eliminationsList[3]}\n'
            'Matches Played: ${player.matchesPlayedList[3]}\n';
    }
    return organizedStats;
  }

  void _onButtonPressed() async {
    final fetcher = StatFetcher();
    final username = accountIDInput.text;
    final platform = playerPlatform;
    final playerID = await fetcher.getID(username);
    if (playerID == null ||
        playerGameMode == '' ||
        playerPlatform == '' ||
        playerGameMode == gamemodeList[0] ||
        playerPlatform == platformList[0]) {
      currentPlayerUsername = 'Account ID Invalid';
      setState(() {});
    } else {
      String jsonBody = await fetcher.getStatJSON(playerID, platform);
      final stats = organizeStats(jsonBody, playerGameMode);
      setState(() {
        try {
          currentPlayerUsername = stats;
        } catch (e) {
          currentPlayerUsername = 'There was a network error';
        }
      });
    }
  }

  void _onPressed() {
    setState(() {
      currentPlayerUsername = '';
      accountPlatformInput.clear();
      accountIDInput.clear();
    });
  }
}
