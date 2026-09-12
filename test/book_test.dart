import 'package:flutter_test/flutter_test.dart';
import 'package:stanford_edtech/primer/book.dart';

void main() {
  const source = SeededBookSource();

  test('always three doors, always one of them home ground', () async {
    for (final reach in [0, 1, 2, 3, 9]) {
      final doors = await source.doorsFor(interest: 'sharks', reach: reach);
      expect(doors.length, 3, reason: 'reach $reach gave ${doors.length} doors');
      expect(doors.where((b) => b.isHomeGround).length, 1);
    }
  });

  test('reach decides how far the other two doors go', () async {
    final near = await source.doorsFor(interest: 'sharks', reach: 1);
    final far = await source.doorsFor(interest: 'sharks', reach: 3);
    expect(near.map((b) => b.stepsOut), containsAll([0, 1]));
    expect(far.map((b) => b.stepsOut).reduce((a, b) => a > b ? a : b),
        greaterThan(near.map((b) => b.stepsOut).reduce((a, b) => a > b ? a : b)));
  });

  test('unknown interest fails loudly rather than showing an empty shelf', () {
    expect(
      () => source.doorsFor(interest: 'dinosaurs', reach: 1),
      throwsArgumentError,
    );
  });
}
