import 'package:flutter/material.dart';
import 'package:r6_getter_test/stat_tracker_classes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Fortnite Stat Tracker App',
      home: StatTrackerApplication(),
    );
  }
}

// Define a custom Form widget.
class StatTrackerApplication extends StatefulWidget {
  const StatTrackerApplication({super.key});

  @override
  State<StatTrackerApplication> createState() => _StatTrackerHomePage();
}

class _StatTrackerHomePage extends State<StatTrackerApplication> {
  String displayedOnScreen = '';
  TextEditingController accountIDInput = TextEditingController();
  TextEditingController accountPlatformInput = TextEditingController();
  final platformList = <String>["PC", "Playstation", "Xbox"];
  final gameModeList = <String>[
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
            color: Colors.blueAccent,
            fontSize: 40,
          ),
        ),
      ],
    );

    final usernameInput = TextField(
      style: const TextStyle(color: Colors.amber, fontSize: 20),
      decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.amber)),
          hintText: 'Account ID',
          hintStyle: TextStyle(fontSize: 20, color: Colors.amber)),
      controller: accountIDInput,
    );

    final sideBar = SafeArea(
      child: NavigationRail(
          backgroundColor: Colors.black26,
          destinations: [
            NavigationRailDestination(
              icon: IconButton(
                onPressed: _onIconPressed,
                icon: const Icon(
                  Icons.house,
                ),
                color: Colors.amber,
              ),
              label: const Text(
                'Home',
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
            NavigationRailDestination(
              icon: IconButton(
                onPressed: _onCastleIconPressed,
                icon: const Icon(
                  Icons.castle_rounded,
                ),
                color: Colors.amber,
              ),
              label: const Text(
                'LeaderBoard',
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
          selectedIndex: 0,
          onDestinationSelected: (value) {
            setState(() {
              value = 0;
            });
          }),
    );

    final platformDropdown = DropdownButtonFormField<String>(
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
          width: 1,
          color: Colors.amber,
        ))),
        dropdownColor: Colors.black,
        items: platformList
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item,
                      style:
                          const TextStyle(color: Colors.amber, fontSize: 20)),
                ))
            .toList(),
        isDense: true,
        isExpanded: true,
        hint: const Align(
            alignment: Alignment.topLeft,
            child: Text("Select a platform",
                style: TextStyle(color: Colors.amber, fontSize: 20))),
        onChanged: (item) => setState(() => playerPlatform = item!));

    final gameModeDropDown = DropdownButtonFormField<String>(
        decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
          width: 1,
          color: Colors.amber,
        ))),
        dropdownColor: Colors.black,
        items: gameModeList
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item,
                      style:
                          const TextStyle(color: Colors.amber, fontSize: 20)),
                ))
            .toList(),
        isDense: true,
        isExpanded: true,
        hint: const Align(
            alignment: Alignment.topLeft,
            child: Text("Select a Game Mode",
                style: TextStyle(color: Colors.amber, fontSize: 20))),
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
            onPressed: _onSearchButtonPressed,
            //searchForAccount,
            child: const Text(
              'Search',
              style: TextStyle(color: Colors.black),
            )),
      ],
    );
    if (displayedOnScreen == '') {
      return LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
            backgroundColor: Colors.black,
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SafeArea(
                  child: NavigationRail(
                      backgroundColor: Colors.black26,
                      extended: constraints.maxWidth >= 600,
                      destinations: [
                        NavigationRailDestination(
                          icon: IconButton(
                            onPressed: _onIconPressed,
                            icon: const Icon(
                              Icons.house,
                            ),
                            color: Colors.amber,
                          ),
                          label: const Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        NavigationRailDestination(
                          icon: IconButton(
                            onPressed: _onCastleIconPressed,
                            icon: const Icon(
                              Icons.castle_rounded,
                            ),
                            color: Colors.amber,
                          ),
                          label: const Text(
                            'LeaderBoard',
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                      selectedIndex: 0,
                      onDestinationSelected: (value) {
                        setState(() {
                          value = 0;
                        });
                      }),
                ),
                const Expanded(
                  child: homeTitle,
                ),
                Expanded(
                  child: textColumn,
                ),
              ],
            ));
      });
    } else if (displayedOnScreen == 'leaderboard') {
      return LayoutBuilder(builder: (context, contraints) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              sideBar,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.black,
                      ),
                      child: const Center(
                        child: Text(
                          'Here is my leaderboard',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 60,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _returnHomeFromLeaderBoard,
                      child: const Text('Home',
                          style: TextStyle(color: Colors.amber)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    } else {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.black,
                ),
                child: Center(
                  child: Text(
                    displayedOnScreen,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _onReturnHomeButtonPressed,
                child: const Text(
                  'Return to Home',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ]),
      );
    }
  }

  String organizeStatsInString(String jsonPlayerData, String playerGameMode) {
    final searchedAccount = Player();
    final decoder = JsonDecoder();
    dynamic decodedStats = decoder.decodeJson(jsonPlayerData);
    searchedAccount.assignAllStats(decodedStats);
    String organizedStats = '';
    organizedStats = buildStringForStats(searchedAccount, playerGameMode);
    return organizedStats;
  }

  String buildStringForStats(Player assigner, String playerGameMode) {
    int gameModeIndex = (gameModeList.indexOf(playerGameMode)) - 2;
    String organizedData = '';
    int decimalPlaceLimit = 2;
    if (playerGameMode == 'Overall Stats') {
      organizedData = '$playerGameMode:'
          '\nUsername: ${assigner.username}'
          '\nLevel: ${assigner.level}\n'
          'K/D: ${double.parse(assigner.kD.toStringAsFixed(decimalPlaceLimit))}'
          '\nWin Rate: ${double.parse(assigner.winRate.toStringAsFixed(decimalPlaceLimit))}'
          '\nEliminations: ${assigner.eliminations}\n'
          'Matches Played: ${assigner.matchesPlayed}\n';
    } else {
      organizedData = '$playerGameMode:'
          '\nUsername: ${assigner.username}'
          '\nLevel: ${assigner.level}'
          '\nK/D: ${double.parse(assigner.gamemodeKDList[gameModeIndex].toStringAsFixed(decimalPlaceLimit))}'
          '\nWin Rate: ${double.parse(assigner.gamemodeWinrateList[gameModeIndex].toStringAsFixed(decimalPlaceLimit))}'
          '\nEliminations: ${assigner.gamemodeEliminationsList[gameModeIndex]}\n'
          'Matches Played: ${assigner.gamemodeMatchesPlayedList[gameModeIndex]}\n';
    }
    return organizedData;
  }

  void _onSearchButtonPressed() async {
    final fetcher = StatFetcher();
    final currentUsername = accountIDInput.text;
    final currentPlatform = playerPlatform;
    final currentPlayerID = await fetcher.getID(currentUsername);
    if (currentPlayerID == null ||
        playerGameMode == '' ||
        playerPlatform == '') {
      setState(() {
        displayedOnScreen = 'Invalid Input';
      });
    } else {
      String jsonPlayerData =
          await fetcher.getStatJSON(currentPlayerID, currentPlatform);
      final stats = organizeStatsInString(jsonPlayerData, playerGameMode);
      setState(() {
        try {
          displayedOnScreen = stats;
        } catch (e) {
          displayedOnScreen = 'There was a network error';
        }
      });
    }
  }

  void _onReturnHomeButtonPressed() {
    setState(() {
      playerGameMode = '';
      displayedOnScreen = '';
      accountPlatformInput.clear();
      accountIDInput.clear();
    });
  }

  void _onIconPressed() {
    setState(() {
      displayedOnScreen = '';
      playerGameMode = '';
      accountPlatformInput.clear();
      accountIDInput.clear();
    });
  }

  void _onCastleIconPressed() {
    setState(() {
      displayedOnScreen = 'leaderboard';
    });
  }

  void _returnHomeFromLeaderBoard() {
    setState(() {
      displayedOnScreen = '';
    });
  }
}
