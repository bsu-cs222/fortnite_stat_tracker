import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:r6_getter_test/stat_tracker_classes.dart';

void main() {
  test('I can get a user ID', () async {
    final StatFetcher fetcher = StatFetcher();
    const username = 'MaxSineFN';
    var result = await fetcher.getID(username);
    expect(result, startsWith('2087736e0e6a4af48e1ae529ee1c3da2'));
  });
}
