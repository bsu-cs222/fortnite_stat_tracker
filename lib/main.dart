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
  List<Player> leaderboard = [];
  late Player player;

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
                onPressed: _onHomeIconPressed,
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
            ),
          ),
        ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _onSearchButtonPressed,
              //searchForAccount,
              child: const Text(
                'Search',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );

    final addPlayerButton = ElevatedButton(
      onPressed: () {
        if (displayedOnScreen == '' ||
            playerGameMode == '' ||
            playerPlatform == '') {
          final message = SnackBar(
            content: const Text('Insufficient Information Provided'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(message);
        } else {
          leaderboard.add(player);
          final message = SnackBar(
            content: const Text('Account Added'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                leaderboard.remove(player);
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(message);
        }
      },
      //searchForAccount,
      child: const Text(
        'Add +',
        style: TextStyle(color: Colors.black),
      ),
    );

    if (displayedOnScreen == '') {
      return LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
            backgroundColor: Colors.black,
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sideBar,
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
      return LayoutBuilder(builder: (context, constraints) {
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
                      child: Center(child: leaderBoardDisplay(leaderboard)),
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
                    child: Center(
                      child: organizeStats(player),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _onReturnHomeButtonPressed,
                    child: const Text(
                      'Return to Home',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  addPlayerButton,
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget organizeStats(Player player) {
    int gameModeIndex = (gameModeList.indexOf(playerGameMode)) - 1;
    int decimalPlace = 2;
    if (playerGameMode == gameModeList[0]) {
      return RichText(
        text: TextSpan(
            text: '$playerGameMode\n',
            style: const TextStyle(
                fontSize: 70, fontWeight: FontWeight.bold, color: Colors.amber),
            children: [
              TextSpan(
                  text: 'Username: ${player.username}\n',
                  style:
                      const TextStyle(color: Colors.blueAccent, fontSize: 40)),
              TextSpan(
                text: 'Level: ${player.level}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              TextSpan(
                text: 'Eliminations: ${player.eliminations}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              TextSpan(
                text: 'KD: ${player.kD}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              TextSpan(
                text: 'Win Rate: ${player.winRate}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              TextSpan(
                text: 'Matches Played: ${player.matchesPlayed}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
            ]),
      );
    } else {
      return RichText(
        text: TextSpan(
            text: '$playerGameMode\n',
            style: const TextStyle(
                fontSize: 70, fontWeight: FontWeight.bold, color: Colors.amber),
            children: [
              TextSpan(
                  text: 'Username: ${player.username}\n',
                  style:
                      const TextStyle(color: Colors.blueAccent, fontSize: 40)),
              TextSpan(
                text: 'Level: ${player.level}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              TextSpan(
                text:
                    'Eliminations: ${player.gamemodeEliminationsList[gameModeIndex]}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              TextSpan(
                text:
                    'KD: ${player.gamemodeKDList[gameModeIndex].toStringAsFixed(decimalPlace)}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              TextSpan(
                text:
                    'Win Rate: ${player.gamemodeWinrateList[gameModeIndex].toStringAsFixed(decimalPlace)}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              TextSpan(
                text:
                    'Matches Played: ${player.gamemodeMatchesPlayedList[gameModeIndex]}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
            ]),
      );
    }
  }

  Widget leaderBoardDisplay(List<Player> leaderboard) {
    return RichText(
        text: TextSpan(
            text: 'Leaderboard\n',
            style: const TextStyle(
                fontSize: 70, fontWeight: FontWeight.bold, color: Colors.amber),
            children: [
          TextSpan(
              text: '1st: ${leaderboard[0].username}\n',
              style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
          TextSpan(
              text: '2st: ${leaderboard[1].username}\n',
              style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
        ]));
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
      final decoder = JsonDecoder();
      final decodedData = decoder.decodeJson(jsonPlayerData);
      player = Player();
      player.assignAllStats(decodedData);
      setState(() {
        try {
          displayedOnScreen = 'stats';
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

  void _onHomeIconPressed() {
    setState(() {
      displayedOnScreen = '';
      playerGameMode = '';
      accountPlatformInput.clear();
      accountIDInput.clear();
    });
  }

  void _onCastleIconPressed() {
    setState(() {
      AccountSorter sortPlayers = AccountSorter();
      List<Player> sortedLeaderboard =
          sortPlayers.sortAccountsByOverallStat(leaderboard, "KD");
      displayedOnScreen = 'leaderboard';
    });
  }

  void _returnHomeFromLeaderBoard() {
    setState(() {
      displayedOnScreen = '';
    });
  }
}
