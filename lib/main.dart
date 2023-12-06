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
          'Fortnite',
          style: TextStyle(
            fontSize: 70,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Stat Tracker',
          style: TextStyle(
            fontSize: 100,
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
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
        hintStyle: TextStyle(
          fontSize: 20,
          color: Colors.amber,
        ),
      ),
      controller: accountIDInput,
    );

    final sideBar = SafeArea(
      child: NavigationRail(
          labelType: NavigationRailLabelType.all,
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

    final searchButton = ElevatedButton(
      onPressed: () {
        if (playerGameMode == '' || playerPlatform == '') {
          final message = SnackBar(
            content: const Text('Insufficient Information Provided'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(message);
        } else {
          _onSearchButtonPressed();
        }
      },
      //searchForAccount,
      child: const Text(
        'Search',
        style: TextStyle(color: Colors.black),
      ),
    );

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
            searchButton,
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
        } else if (leaderboard.length == 5) {
          final message = SnackBar(
            content: const Text('Leaderboard at max'),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.black,
                      ),
                      child: Center(child: displayLeaderboard(leaderboard)),
                    ),
                    ElevatedButton(
                      onPressed: _returnHomeFromLeaderBoard,
                      child: const Text('Home',
                          style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton(
                        onPressed: _clearLeaderboard,
                        child: const Text(
                          'Clear Leaderboard',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
              ),
            ],
          ),
        );
      });
    } else {
      if (displayedOnScreen == 'Invalid Username') {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              sideBar,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: organizeStats(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onReturnHomeButtonPressed,
                      child: const Text(
                        'Return to Home',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: organizeStats(),
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
                    gameModeDropDown,
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Widget organizeStats() {
    int gameModeIndex = (gameModeList.indexOf(playerGameMode)) - 1;
    int decimalPlace = 2;
    if (displayedOnScreen == 'Invalid Username') {
      return RichText(
          text: const TextSpan(
              text: 'Invalid Input\n',
              style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber)));
    } else if (playerGameMode == gameModeList[0]) {
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
                text:
                    'KD: ${double.parse(player.kD.toStringAsFixed(decimalPlace))}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              TextSpan(
                text:
                    'Win Rate: ${double.parse(player.winRate.toStringAsFixed(decimalPlace))}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              TextSpan(
                text: 'Matches Played: ${player.matchesPlayed}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
            ]),
      );
    } else if (playerGameMode != gameModeList[0]) {
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
                    'KD: ${double.parse(player.gamemodeKDList[gameModeIndex].toStringAsFixed(decimalPlace))}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              TextSpan(
                text:
                    'Win Rate: ${double.parse(player.gamemodeWinrateList[gameModeIndex].toStringAsFixed(decimalPlace))}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
              TextSpan(
                text:
                    'Matches Played: ${player.gamemodeMatchesPlayedList[gameModeIndex]}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40),
              ),
            ]),
      );
    } else {
      throw const FormatException();
    }
  }

  Widget displayLeaderboard(List<Player> leaderboard) {
    if (leaderboard.isEmpty) {
      return RichText(
          text: const TextSpan(
              text: 'No Players Added',
              style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber)));
    } else if (leaderboard.length == 1) {
      return RichText(
          text: TextSpan(
              text: 'Leaderboard\n',
              style: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
              children: [
            TextSpan(
                text: '1st: ${leaderboard[0].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
          ]));
    } else if (leaderboard.length == 2) {
      return RichText(
          text: TextSpan(
              text: 'Leaderboard\n',
              style: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
              children: [
            TextSpan(
                text: '1st: ${leaderboard[0].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
            TextSpan(
                text: '2nd: ${leaderboard[1].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
          ]));
    } else if (leaderboard.length == 3) {
      return RichText(
          text: TextSpan(
              text: 'Leaderboard\n',
              style: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
              children: [
            TextSpan(
                text: '1st: ${leaderboard[0].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
            TextSpan(
                text: '2nd: ${leaderboard[1].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
            TextSpan(
                text: '3rd: ${leaderboard[2].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
          ]));
    } else if (leaderboard.length == 4) {
      return RichText(
          text: TextSpan(
              text: 'Leaderboard\n',
              style: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
              children: [
            TextSpan(
                text: '1st: ${leaderboard[0].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
            TextSpan(
                text: '2nd: ${leaderboard[1].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
            TextSpan(
                text: '3rd: ${leaderboard[2].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
            TextSpan(
                text: '4th: ${leaderboard[3].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
          ]));
    } else {
      return RichText(
          text: TextSpan(
              text: 'Leaderboard\n',
              style: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
              children: [
            TextSpan(
                text: '1st: ${leaderboard[0].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
            TextSpan(
                text: '2nd: ${leaderboard[1].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
            TextSpan(
                text: '3rd: ${leaderboard[2].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
            TextSpan(
                text: '4th: ${leaderboard[3].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
            TextSpan(
                text: '5th: ${leaderboard[4].username}\n',
                style: const TextStyle(color: Colors.blueAccent, fontSize: 40)),
          ]));
    }
  }

  void _onSearchButtonPressed() async {
    player = Player();
    final fetcher = StatFetcher();
    final currentUsername = accountIDInput.text;
    final currentPlatform = playerPlatform;
    final currentPlayerID = await fetcher.getID(currentUsername);
    if (currentPlayerID == null ||
        playerGameMode == '' ||
        playerPlatform == '') {
      setState(() {
        displayedOnScreen = 'Invalid Username';
      });
    } else {
      String jsonPlayerData =
          await fetcher.getStatJSON(currentPlayerID, currentPlatform);
      final decoder = JsonDecoder();
      final decodedData = decoder.decodeJson(jsonPlayerData);
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
          sortPlayers.sortAccountListByOverallStat(leaderboard, "KD");
      displayedOnScreen = 'leaderboard';
    });
  }

  void _returnHomeFromLeaderBoard() {
    setState(() {
      displayedOnScreen = '';
    });
  }

  void _clearLeaderboard() {
    leaderboard.clear();
    setState(() {
      displayedOnScreen == 'leaderboard';
    });
  }
}
