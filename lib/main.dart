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
  final platformList = <String>[
    "Select a platform",
    "PC",
    "Playstation",
    "Xbox"
  ];
  final gameModeList = <String>[
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

    final gameModeDropDown = DropdownButtonFormField<String>(
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
          width: 1,
          color: Colors.grey,
        ))),
        value: gameModeList.first,
        items: gameModeList
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
        gameModeDropDown,
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

  String organizeStats(String jsonBody, String playerGameMode) {
    final player = PlayerStatsAssigner();
    player.assignAllStats(jsonBody);
    String organizedStats = '';
    switch (playerGameMode) {
      case 'Overall Stats':
        organizedStats = 'Overall Stats:'
            '\nUsername: ${player.username}'
            '\nLevel: ${player.level}\nK/D: ${double.parse(player.kD.toStringAsFixed(2))}'
            '\nWin Rate: ${double.parse(player.winRate.toStringAsFixed(2))}'
            '\nEliminations: ${player.eliminations}\n'
            'Matches Played: ${player.matchesPlayed}\n';
      case 'Solo':
        organizedStats = 'Solo Stats:'
            '\nUsername: ${player.username}'
            '\nLevel: ${player.level}\nK/D: ${double.parse(player.gamemodeKDList[0].toStringAsFixed(2))}'
            '\nWin Rate: ${double.parse(player.gamemodeWinrateList[0].toStringAsFixed(2))}'
            '\nEliminations: ${player.gamemodeEliminationsList[0]}\n'
            'Matches Played: ${player.gamemodeMatchesPlayedList[0]}\n';
      case 'Duos':
        organizedStats = 'Duo Stats:'
            '\nUsername: ${player.username}'
            '\nLevel: ${player.level}\nK/D: ${double.parse(player.gamemodeKDList[1].toStringAsFixed(2))}'
            '\nWin Rate: ${double.parse(player.gamemodeWinrateList[1].toStringAsFixed(2))}'
            '\nEliminations: ${player.gamemodeEliminationsList[1]}\n'
            'Matches Played: ${player.gamemodeMatchesPlayedList[1]}\n';
      case 'Trios':
        organizedStats = 'Trio Stats:'
            '\nUsername: ${player.username}'
            '\nLevel: ${player.level}\nK/D: ${double.parse(player.gamemodeKDList[2].toStringAsFixed(2))}'
            '\nWin Rate: ${double.parse(player.gamemodeWinrateList[2].toStringAsFixed(2))}'
            '\nEliminations: ${player.gamemodeEliminationsList[2]}\n'
            'Matches Played: ${player.gamemodeMatchesPlayedList[2]}\n';
      case 'Squads':
        organizedStats = 'Squad Stats:'
            '\nUsername: ${player.username}'
            '\nLevel: ${player.level}\nK/D: ${double.parse(player.gamemodeKDList[3].toStringAsFixed(2))}'
            '\nWin Rate: ${double.parse(player.gamemodeWinrateList[3].toStringAsFixed(2))}'
            '\nEliminations: ${player.gamemodeEliminationsList[3]}\n'
            'Matches Played: ${player.gamemodeMatchesPlayedList[3]}\n';
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
        playerGameMode == gameModeList[0] ||
        playerPlatform == platformList[0]) {
      currentPlayer = 'Account ID Invalid';
      setState(() {});
    } else {
      String jsonBody = await fetcher.getStatJSON(playerID, platform);
      final stats = organizeStats(jsonBody, playerGameMode);
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
