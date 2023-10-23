import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:r6_getter_test/stat_tracker_classes.dart';

void main() {
  final StatFetcher fetcher = StatFetcher();
  String exampleID = '2087736e0e6a4af48e1ae529ee1c3da2';
  test('I can get a user ID', () async {
    const username = 'MaxSineFN';
    var result = await fetcher.getID(username);
    expect(result, startsWith(exampleID));
  });

  test('I can get a users stats', () async {
    var result = await fetcher.getStats(exampleID);
    expect(result, startsWith('{"result":true,"name":"MaxSineFN","accoun'));
  });

  test('I can store stats', () async {
    var body = await fetcher.getStats(exampleID);
    var player = fetcher.assignStats(body);
    expect(player.getMatchesPlayed(), 21706);
  });
}
