// The nav is the one piece of stage chrome that has to survive a phone: thirteen
// pips, the day, the toggle and reset across 360 wide, on every beat, without a
// RenderFlex overflow — which Flutter reports as an exception, so the test
// fails on it.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stanford_edtech/lantern_story.dart';
import 'package:stanford_edtech/primer/chapter.dart';
import 'package:stanford_edtech/primer/content/doorways.dart';
import 'package:stanford_edtech/primer/content/week_story.dart';
import 'package:stanford_edtech/primer/run.dart';
import 'package:stanford_edtech/primer/widgets/widgets.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  // Chapter text loads from the asset bundle, which a widget test's fake clock
  // never waits for. Load every chapter for real before any test, so pages
  // find them already loaded instead of on a load that never finishes.
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final id in ['old-mother-west-wind', 'story-of-doctor-dolittle', 'winnie-the-pooh']) {
      expect(await Chapter.load(id), isNotNull, reason: id);
    }
  });

  testWidgets('phone view fits every beat at 360 wide, and reset goes home',
      (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: LanternStory()));
    await tester.tap(find.byTooltip('Phone view'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Full width'), findsOneWidget);

    for (var beat = 13; beat >= 1; beat--) {
      await tester.tap(find.bySemanticsLabel(RegExp('^Beat $beat,')));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.byTooltip('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, Maya.'), findsOneWidget);
  });

  // The Grumble page waits for its lantern. If this ever regresses, the page
  // is on screen and tappable before the lantern has finished lighting.
  testWidgets('Grumble lights the lantern centred, raises it, then shows the page',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LanternStory()));
    // The Cover scrolls; at the test's 800x600 the button sits on the fold.
    await tester.ensureVisible(find.text("Open tonight's book"));
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

    const heading = 'Meet Grumble.';
    expect(lanternAt(), Alignment.center);
    expect(opacityOf(heading), 0);

    // Lit, but not yet at the top: the page still waits.
    // Frame by frame, as a screen would: a single big jump of the clock ends
    // the lighting a frame later than it would on a device.
    for (var i = 0; i < 50 && lanternAt() != Alignment.topCenter; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(lanternAt(), Alignment.topCenter);
    expect(opacityOf(heading), 0);

    await tester.pumpAndSettle();
    expect(opacityOf(heading), 1);
  });

  // He is introduced, with his face, before his note; she taps him to the edge rather than
  // rubbing him out, and the page doesn't move on until the ink has answered.
  testWidgets('Grumble moves to the edge, can be renamed, and ink answers him',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LanternStory()));
    await tester.tap(find.bySemanticsLabel(RegExp('^Beat 2,')));
    await tester.pumpAndSettle();

    expect(find.text('Meet Grumble.'), findsOneWidget, reason: 'introduced before his note');
    expect(find.bySemanticsLabel(RegExp('drawing of Grumble')), findsOneWidget);
    expect(find.text('Turn the page'), findsNothing, reason: 'no way on until she has met him');

    await tester.tap(find.bySemanticsLabel(RegExp("^Grumble's note")));
    await tester.pumpAndSettle();
    expect(find.text(Run.inkNote.text), findsOneWidget);

    await tester.ensureVisible(find.text('Mutter'));
    await tester.tap(find.text('Mutter'));
    await tester.pumpAndSettle();
    expect(find.text('Meet Mutter.'), findsOneWidget);
    expect(find.text('Turn the page'), findsOneWidget);
  });

  // The night as the journey draws it: listen, a tiny read, the quest, then
  // her own reading from the part that answers it, and a celebration of what
  // she found. No mic anywhere.
  testWidgets('a whole night runs from the chapter to The Dark', (tester) async {
    tester.view.physicalSize = const Size(900, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final door = doorways['old-mother-west-wind']!;

    await tester.pumpWidget(const MaterialApp(home: LanternStory()));
    await tester.tap(find.bySemanticsLabel(RegExp('^Beat 5,')));
    await tester.pumpAndSettle();
    expect(find.text("Mrs. Redwing's Speckled Egg"), findsOneWidget);

    await tester.tap(find.text("I'll read it myself"));
    await tester.pumpAndSettle();
    expect(find.text('Pick a line first'), findsOneWidget);
    await tester.tapOnText(find.textRange.ofSubstring('Old Mother West Wind came down from the Purple Hills').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('I read it'));
    await tester.pumpAndSettle();

    expect(find.text(door.behavior), findsOneWidget);
    await tester.tap(find.text("I'm back"));
    await tester.pumpAndSettle();
    await tester.tap(find.text('I did it'));
    await tester.pumpAndSettle();

    expect(find.text(door.readOn), findsOneWidget);
    expect(find.text("I'm done reading"), findsOneWidget);
    await tester.tap(find.text('a line'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Chug-arum', findRichText: true), findsOneWidget, reason: 'opens where the quest points');
    await tester.tap(find.text("I'm done reading"));
    await tester.pumpAndSettle();

    expect(find.text(door.celebration), findsOneWidget);
    await tester.tap(find.text('Close the book'));
    await tester.pumpAndSettle();
    expect(find.text('The lantern is dimming.'), findsOneWidget);
  });

  testWidgets('The Dark puts the lantern out centred, raises it, then speaks',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LanternStory()));
    await tester.tap(find.bySemanticsLabel(RegExp('^Beat 11,')));
    await tester.pump(const Duration(milliseconds: 600));

    final lantern = find.ancestor(of: find.byType(Lantern), matching: find.byType(AnimatedAlign));
    final heading = find.ancestor(of: find.text('The lantern is dimming.'), matching: find.byType(AnimatedOpacity));

    expect(tester.widget<AnimatedAlign>(lantern).alignment, Alignment.center);
    expect(tester.widget<AnimatedOpacity>(heading.first).opacity, 0);

    await tester.pumpAndSettle();
    expect(tester.widget<AnimatedAlign>(lantern).alignment, Alignment.topCenter);
    expect(tester.widget<AnimatedOpacity>(heading.first).opacity, 1);
  });

  // The intercept is never-cut. Back from a quest she couldn't do, it asks,
  // never consoles, reads every line off the door, and keeps nothing: leaving
  // the beat clears what she tapped.
  testWidgets("the intercept asks what it said, then lets it go; day follows",
      (tester) async {
    final door = doorways['old-mother-west-wind']!;
    await tester.pumpWidget(const MaterialApp(home: LanternStory()));
    expect(find.text('Day 1'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(RegExp('^Beat 8,')));
    await tester.pumpAndSettle();
    expect(find.text('NIGHT 1'), findsOneWidget);

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
    expect(find.text('NIGHT 2'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(RegExp('^Beat 7,')));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel(RegExp('^Beat 8,')));
    await tester.pumpAndSettle();
    expect(find.text(door.interceptClose), findsNothing, reason: 'nothing kept');

    await tester.tap(find.byTooltip('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('Day 1'), findsOneWidget);
  });

  // A week later the book tells a story made from her week. Scrawl writes in
  // pencil, every note is answered on the same page, and the voice never reads
  // his lines.
  testWidgets('the grown-ups slide shows her week, then her story answers Scrawl', (tester) async {
    tester.view.physicalSize = const Size(900, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: LanternStory()));
    await tester.tap(find.bySemanticsLabel(RegExp('^Beat 12,')));
    await tester.pumpAndSettle();
    expect(find.text('A week goes by.'), findsOneWidget);
    expect(find.text('Day 8'), findsOneWidget);
    for (final n in weekNights) {
      expect(find.text(n.found), findsOneWidget, reason: n.day);
    }
    expect(find.text(aboutScrawl), findsOneWidget);
    for (final src in storySources) {
      expect(find.text(src.text), findsOneWidget, reason: src.label);
    }
    expect(find.text('Who answered Grumble'), findsOneWidget);

    await tester.ensureVisible(find.text("Show Maya's story"));
    await tester.tap(find.text("Show Maya's story"));
    await tester.pumpAndSettle();
    expect(find.text(weekStoryTitle), findsOneWidget);
    await tester.tap(find.text('Open the story'));
    await tester.pumpAndSettle();
    for (final page in weekStory) {
      if (page.text.isNotEmpty) expect(find.text(page.text), findsOneWidget);
      if (page.scrawl != null) {
        expect(find.text(page.scrawl!), findsOneWidget);
        expect(page.answer, isNotNull, reason: 'every note of his is answered');
        expect(page.spoken, isNot(contains(page.scrawl!)), reason: 'his pencil is never read aloud');
      }
      if (page.quiet != null) expect(find.text(page.quiet!), findsOneWidget);
      if (page == weekStory.last) break;
      await tester.tap(find.text('Turn the page'));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('Close the book'));
    await tester.pumpAndSettle();
    expect(find.text('The lantern is dimming.'), findsOneWidget);
  });
}
