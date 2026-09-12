// The nav is the one piece of stage chrome that has to survive a phone: nine
// pips, the day, the toggle and reset across 360 wide, on every beat, without a
// RenderFlex overflow — which Flutter reports as an exception, so the test
// fails on it.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stanford_edtech/lantern_story.dart';
import 'package:stanford_edtech/primer/content/doorways.dart';
import 'package:stanford_edtech/primer/widgets/widgets.dart';

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

    for (var beat = 9; beat >= 1; beat--) {
      await tester.tap(find.bySemanticsLabel(RegExp('^Beat $beat,')));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.byTooltip('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, Maya.'), findsOneWidget);
  });

  // The Grumble page waits for its lantern. If this ever regresses, the button
  // is on screen and tappable before the lantern has finished lighting.
  testWidgets('Grumble lights the lantern centred, raises it, then shows the page',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LanternStory()));
    await tester.tap(find.text("Open tonight's book"));
    await tester.pump(const Duration(milliseconds: 600)); // switcher, not lantern

    double opacityOf(String text) => tester
        .widget<AnimatedOpacity>(find
            .ancestor(of: find.text(text), matching: find.byType(AnimatedOpacity))
            .first)
        .opacity;

    Alignment lanternAt() => tester
        .widget<AnimatedAlign>(find.ancestor(of: find.byType(Lantern), matching: find.byType(AnimatedAlign)))
        .alignment as Alignment;

    expect(lanternAt(), Alignment.center);
    expect(opacityOf('Turn the page'), 0);

    // Lit, but not yet at the top: the page still waits.
    await tester.pump(const Duration(milliseconds: 4200));
    await tester.pump(const Duration(milliseconds: 100));
    expect(lanternAt(), Alignment.topCenter);
    expect(opacityOf('Turn the page'), 0);

    await tester.pumpAndSettle();
    expect(opacityOf('Turn the page'), 1);
  });

  testWidgets('The Dark puts the lantern out centred, raises it, then speaks',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LanternStory()));
    await tester.tap(find.bySemanticsLabel(RegExp('^Beat 9,')));
    await tester.pump(const Duration(milliseconds: 600));

    final lantern = find.ancestor(of: find.byType(Lantern), matching: find.byType(AnimatedAlign));
    final heading = find.ancestor(of: find.text('The lantern is dimming.'), matching: find.byType(AnimatedOpacity));

    expect(tester.widget<AnimatedAlign>(lantern).alignment, Alignment.center);
    expect(tester.widget<AnimatedOpacity>(heading.first).opacity, 0);

    await tester.pumpAndSettle();
    expect(tester.widget<AnimatedAlign>(lantern).alignment, Alignment.topCenter);
    expect(tester.widget<AnimatedOpacity>(heading.first).opacity, 1);
  });

  // The intercept is never-cut. It asks, never consoles, reads every line off
  // the door, and keeps nothing: leaving the beat clears what she tapped.
  testWidgets("the intercept asks what it said, then lets it go; day follows",
      (tester) async {
    final door = doorways['hilda-troll']!;
    await tester.pumpWidget(const MaterialApp(home: LanternStory()));
    expect(find.text('Day 1'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(RegExp('^Beat 8,')));
    await tester.pumpAndSettle();
    expect(find.text('Day 4'), findsOneWidget, reason: 'script calls it night four');
    expect(find.text('NIGHT 4'), findsOneWidget);

    await tester.tap(find.text("I couldn't do it"));
    await tester.pumpAndSettle();
    expect(find.text('What did it just say to you?'), findsOneWidget);
    for (final option in door.interceptOptions) {
      expect(find.text(option), findsOneWidget);
    }

    await tester.tap(find.text(door.interceptOptions.last));
    await tester.pumpAndSettle();
    expect(find.text(door.interceptClose), findsOneWidget);

    await tester.tap(find.byTooltip('Next day'));
    await tester.pumpAndSettle();
    expect(find.text('NIGHT 5'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(RegExp('^Beat 7,')));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel(RegExp('^Beat 8,')));
    await tester.pumpAndSettle();
    expect(find.text(door.interceptClose), findsNothing, reason: 'nothing kept');

    await tester.tap(find.byTooltip('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('Day 1'), findsOneWidget);
  });
}
