import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:r6_getter_test/stat_tracker_classes.dart';

void main() {
  PlayerStatsDecoder decodePlayerStats = PlayerStatsDecoder();
  File accountFile = File('test/account.json');
  final String fileContents = accountFile.readAsStringSync();
  final body = decodePlayerStats.decodeJson(fileContents);
  AccountSorter sortPlayers = AccountSorter();
  Player player1 = Player();
  Player player2 = Player();
  Player player3 = Player();

  player1.assignAllStats(body);

  File accountFile2 = File('test/account2.json');
  final String fileContents2 = accountFile2.readAsStringSync();
  final body2 = decodePlayerStats.decodeJson(fileContents2);
  player2.assignAllStats(body2);

  File accountFile3 = File('test/account3.json');
  final String fileContents3 = accountFile3.readAsStringSync();
  final body3 = decodePlayerStats.decodeJson(fileContents3);
  player3.assignAllStats(body3);

  List<Player> playerList = [player1, player2, player3];

  test('I can get a users account level', () {
    int level = decodePlayerStats.setLevel(body);
    expect(level, 4);
  });

  test('I can get the users overall number of eliminations', () {
    int eliminations = decodePlayerStats.setKills(body);
    expect(eliminations, 1488);
  });

  test(
      'I can get the users number of eliminations in the solo game mode using a list',
      () {
    List eliminationsList =
        decodePlayerStats.setGamemodeSpecificEliminations(body);
    int eliminations = eliminationsList[0];
    expect(eliminations, 551);
  });

  test('I can sort a list of player objects based on their overall KD', () {
    List<Player> sortedPlayerList =
        sortPlayers.sortAccountsByOverallStat(playerList, "KD");
    expect(sortedPlayerList[0].username, player3.username);
  });

  test(
      'I can sort a list of player objects based on their overall eliminations',
      () {
    List<Player> sortedPlayerList =
        sortPlayers.sortAccountsByOverallStat(playerList, "eliminations");
    expect(sortedPlayerList[0].username, player3.username);
  });

  test('I can sort a list of player objects based on solo KD', () {
    List<Player> sortedPlayerList =
        sortPlayers.sortAccountByGamemodeStat(playerList, "KD", "solo");
    expect(sortedPlayerList[0].username, player3.username);
  });

  test('I can sort a list of player objects based on trio winrate', () {
    List<Player> sortedPlayerList =
        sortPlayers.sortAccountByGamemodeStat(playerList, "winRate", "trio");
    expect(sortedPlayerList[1].username, player1.username);
  });
}
