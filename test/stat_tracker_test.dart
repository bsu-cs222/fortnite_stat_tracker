import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:r6_getter_test/stat_tracker_classes.dart';

void main() {
  PlayerStatsDecoder playerStatsDecoder = PlayerStatsDecoder();
  AccountSorter accountSorter = AccountSorter();
  FilterHandler playerStatHandler = FilterHandler();
  Player drewdeshawn = Player();
  Player realWizard = Player();
  Player fakePlayerAccount = Player();
  SpaceReplacer replacer = SpaceReplacer();

  File drewdeshawnAccountFile = File('test/account.json');
  final String drewdeshawnFileContents =
      drewdeshawnAccountFile.readAsStringSync();
  final body = playerStatsDecoder.decodeJson(drewdeshawnFileContents);
  drewdeshawn.assignAllStats(body);

  File realWizardAccountFile = File('test/account2.json');
  final String realWizardFileContents =
      realWizardAccountFile.readAsStringSync();
  final body2 = playerStatsDecoder.decodeJson(realWizardFileContents);
  realWizard.assignAllStats(body2);

  File fakePlayerAccountFile = File('test/account3.json');
  final String fakePlayerFileContents =
      fakePlayerAccountFile.readAsStringSync();
  final body3 = playerStatsDecoder.decodeJson(fakePlayerFileContents);
  fakePlayerAccount.assignAllStats(body3);

  List<Player> listOfFortnitePlayers = [
    drewdeshawn,
    realWizard,
    fakePlayerAccount
  ];

  test('I can get a users account level', () {
    int drewdeshawnAccountLevel = playerStatsDecoder.parseLevel(body);
    expect(drewdeshawnAccountLevel, 4);
  });

  test('I can get the users overall number of eliminations', () {
    int realWizardOverallKills = playerStatsDecoder.parsePlayerKills(body2);
    expect(realWizardOverallKills, 1489);
  });

  test(
      'I can get the users number of eliminations in the solo game mode using a list',
      () {
    List drewdeshawnEliminationsList =
        playerStatsDecoder.parsePlayerGamemodeEliminations(body);
    int eliminations = drewdeshawnEliminationsList[0];
    expect(eliminations, 551);
  });

  test('I can sort a list of player objects based on their overall KD', () {
    List<Player> sortedListOfFortnitePlayers =
        accountSorter.sortAccountListByOverallStat(listOfFortnitePlayers, "KD");
    expect(sortedListOfFortnitePlayers[0].username, fakePlayerAccount.username);
  });

  test(
      'I can sort a list of player objects based on their overall eliminations',
      () {
    List<Player> sortedListOfFortnitePlayers = accountSorter
        .sortAccountListByOverallStat(listOfFortnitePlayers, "eliminations");
    expect(sortedListOfFortnitePlayers[0].username, fakePlayerAccount.username);
  });

  test('I can sort a list of player objects based on their solo KD', () {
    List<Player> sortedListOfFortnitePlayers = accountSorter
        .sortAccountListByGamemodeStat(listOfFortnitePlayers, "KD", "solo");
    expect(sortedListOfFortnitePlayers[0].username, fakePlayerAccount.username);
  });

  test('When given an overall stat, I can return the chosen stat', () {
    playerStatHandler.returnOverallStat(drewdeshawn, 'winRate');
    expect(drewdeshawn.winRate, 13.0875);
  });

  test('When given an overall stat, I can return the chosen stat', () {
    playerStatHandler.returnOverallStat(realWizard, 'matchesPlayed');
    expect(realWizard.matchesPlayed, 1598);
  });

  test('When given a specific stat, I can return the chosen stat', () {
    playerStatHandler.returnSpecificGamemodeStat(
        fakePlayerAccount, 'eliminations', "squad");
    expect(fakePlayerAccount.gamemodeEliminationsList[3], 601);
  });

  test('When given a specific stat, I can return the chosen stat', () {
    playerStatHandler.returnSpecificGamemodeStat(
        realWizard, 'matchesPlayed', "solo");
    expect(fakePlayerAccount.gamemodeMatchesPlayedList[0], 515);
  });

  test('I can sort a list of player objects based on trio winrate', () {
    List<Player> sortedPlayerList = accountSorter.sortAccountListByGamemodeStat(
        listOfFortnitePlayers, "winRate", "trio");
    expect(sortedPlayerList[2].username, fakePlayerAccount.username);
  });

  test(
      'I can replace the spaces in a string with the appropriate URL counterpart',
      () {
    String exampleString = "Apples and Bananas";
    exampleString = replacer.replaceSpaces(exampleString);
    expect(exampleString, "Apples%20and%20Bananas");
  });
}
