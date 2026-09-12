// The two bits of Track A/E logic that can actually break on stage: a tap
// advances exactly one beat, and a long press lands on The Dark from anywhere.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stanford_edtech/main.dart';
import 'package:stanford_edtech/primer/run.dart';

void main() {
  testWidgets('seven taps walk the beats to the end without throwing',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Beats()));
    expect(find.text('cover'), findsOneWidget);

    for (var i = 0; i < 7; i++) {
      await tester.tap(find.byType(PageView));
      await tester.pumpAndSettle();
    }

    expect(find.text('the dark'), findsOneWidget);
  });

  testWidgets('a long press jumps to The Dark mid-pitch', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Beats()));
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

  // §11: the stories touch, the children don't. The page left behind is ours,
  // hand-made and seeded, so nothing a child wrote reaches another child. This
  // is the guard that fails if live content ever gets swapped in.
  test('the page left behind is seeded, unnamed, and not hers', () {
    final run = Run();
    expect(Run.leftBehind, isNot(contains(run.childName)));
    expect(run.fieldGuide, isNot(contains(Run.leftBehind)));
  });
}
