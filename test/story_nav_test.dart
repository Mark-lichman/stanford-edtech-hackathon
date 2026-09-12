// The nav is the one piece of stage chrome that has to survive a phone: eight
// pips, the toggle and reset across 360 wide, on every beat, without a
// RenderFlex overflow — which Flutter reports as an exception, so the test
// fails on it.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stanford_edtech/lantern_story.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('phone view fits every beat at 360 wide, and reset goes home',
      (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: LanternStory()));
    await tester.tap(find.byTooltip('Phone view'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Full width'), findsOneWidget);

    for (var beat = 8; beat >= 1; beat--) {
      await tester.tap(find.bySemanticsLabel(RegExp('^Beat $beat,')));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.byTooltip('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, Maya.'), findsOneWidget);
  });

  // The Grumble page waits for its lantern. If this ever regresses, the button
  // is on screen and tappable before the lantern has finished lighting.
  testWidgets('Grumble holds its controls back until the lantern is lit',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LanternStory()));
    await tester.tap(find.text("Open tonight's book"));
    await tester.pump(const Duration(milliseconds: 600)); // switcher, not lantern

    double opacityOf(String text) => tester
        .widget<AnimatedOpacity>(find
            .ancestor(of: find.text(text), matching: find.byType(AnimatedOpacity))
            .first)
        .opacity;

    expect(opacityOf('Keep the note'), 0);

    await tester.pumpAndSettle();
    expect(opacityOf('Keep the note'), 1);
  });
}
