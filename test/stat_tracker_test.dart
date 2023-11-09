import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:r6_getter_test/stat_tracker_classes.dart';

void main() {
  test('I can get a users account level', () {
    PlayerStatsDecoder decodePlayerStats = PlayerStatsDecoder();
    File accountFile = File('test/account.json');
    final String fileContents = accountFile.readAsStringSync();
    final body = decodePlayerStats.decodeJson(fileContents);
    int level = decodePlayerStats.setLevel(body);
    expect(level, 4);
  });

  test('I can get the users overall number of eliminations', () {
    PlayerStatsDecoder decodePlayerStats = PlayerStatsDecoder();
    File accountFile = File('test/account.json');
    final String fileContents = accountFile.readAsStringSync();
    final body = decodePlayerStats.decodeJson(fileContents);
    int eliminations = decodePlayerStats.setKills(body);
    expect(eliminations, 1488);
  });

  test('I can get the users number of eliminations in the solo game mode', () {
    PlayerStatsDecoder decodePlayerStats = PlayerStatsDecoder();
    File accountFile = File('test/account.json');
    final String fileContents = accountFile.readAsStringSync();
    final body = decodePlayerStats.decodeJson(fileContents);
    List eliminationsList =
        decodePlayerStats.setGamemodeSpecificEliminations(body);
    int eliminations = eliminationsList[0];
    expect(eliminations, 551);
  });
}
