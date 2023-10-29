import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:r6_getter_test/stat_tracker_classes.dart';

void main() {
  final StatFetcher fetcher = StatFetcher();
  String exampleID = '4767a665af914f04b73fe8742a1e083e';
  String platform = 'pc';

  test('I can get a user ID', () async {
    const username = 'Drewdeshawn';
    var result = await fetcher.getID(username);
    expect(result, startsWith(exampleID));
  });

  test('I can get a users stats', () async {
    var result = await fetcher.getStatJSON(exampleID,platform);
    expect(result, startsWith('{"result":true,"name":"Drewdeshawn","account'));
  });

  test('I can store stats', () async {
    var body = await fetcher.getStatJSON(exampleID,platform);
    var player = fetcher.assignStats(body);
    expect(player.getMatchesPlayed(), 1589);
  });
}
