import 'package:flutter_test/flutter_test.dart';
import 'package:stanford_edtech/primer/book.dart';
import 'package:stanford_edtech/primer/content/doorways.dart';

void main() {
  const source = SeededBookSource();

  test('always three doors, always one of them home ground', () async {
    for (final reach in [0, 1, 2, 3, 9]) {
      final doors = await source.doorsFor(interest: 'creatures', reach: reach);
      expect(doors.length, 3, reason: 'reach $reach gave ${doors.length} doors');
      expect(doors.where((b) => b.isHomeGround).length, 1);
    }
  });

  test('reach decides how far the other two doors go', () async {
    final near = await source.doorsFor(interest: 'creatures', reach: 1);
    final far = await source.doorsFor(interest: 'creatures', reach: 3);
    expect(near.map((b) => b.stepsOut), containsAll([0, 1]));
    expect(far.map((b) => b.stepsOut).reduce((a, b) => a > b ? a : b),
        greaterThan(near.map((b) => b.stepsOut).reduce((a, b) => a > b ? a : b)));
  });

  // The Cover's adventures fall back to the home door when she taps one that
  // isn't written yet, so the home door must always be.
  test('every adventure shelf has three doors and an authored home door', () async {
    for (final interest in ['meadow', 'animal-talk', 'forest']) {
      final doors = await source.doorsFor(interest: interest, reach: 1);
      expect(doors.length, 3, reason: interest);
      final home = doors.singleWhere((b) => b.isHomeGround);
      expect(doorways.containsKey(home.id), isTrue, reason: '$interest home ${home.id}');
      expect(doors.every((b) => b.linkConfirmed), isTrue, reason: interest);
    }
  });

  test('unknown interest fails loudly rather than showing an empty shelf', () {
    expect(
      () => source.doorsFor(interest: 'aeroplanes', reach: 1),
      throwsArgumentError,
    );
  });
}
