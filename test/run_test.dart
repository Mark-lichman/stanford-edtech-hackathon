// The two bits of Track A/E logic that can actually break on stage: a tap
// advances exactly one beat, and a long press lands on The Dark from anywhere.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stanford_edtech/main.dart';
import 'package:stanford_edtech/primer/run.dart';

void main() {
  testWidgets('seven taps walk the beats to the end without throwing',
      (tester) async {
    await tester.pumpWidget(const PrimerApp());
    expect(find.text('cover'), findsOneWidget);

    for (var i = 0; i < 7; i++) {
      await tester.tap(find.byType(PageView));
      await tester.pumpAndSettle();
    }

    expect(find.text('the dark'), findsOneWidget);
  });

  testWidgets('a long press jumps to The Dark mid-pitch', (tester) async {
    await tester.pumpWidget(const PrimerApp());
    await tester.longPress(find.byType(PageView));
    await tester.pumpAndSettle();

    expect(find.text('the dark'), findsOneWidget);
  });

  test('the run is seeded lived-in, not empty', () {
    final run = Run();
    expect(run.judgeName, 'Grumble');
    expect(run.fieldGuide, hasLength(2));

    run.earn('A new page');
    expect(run.artifactEarned, isTrue);
    expect(run.fieldGuide, hasLength(3));
  });
}
