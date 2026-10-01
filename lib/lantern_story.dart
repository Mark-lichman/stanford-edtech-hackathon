import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';

import 'primer/book.dart';
import 'primer/chapter.dart';
import 'primer/content/doorways.dart';
import 'primer/read_aloud.dart';
import 'primer/run.dart';
import 'primer/widgets/widgets.dart';

class LanternStory extends StatefulWidget {
  const LanternStory({super.key});
  @override
  State<LanternStory> createState() => _LanternStoryState();
}

class _LanternStoryState extends State<LanternStory> {
  int _step = 0;
  String _interest = _adventures.first.key;
  /// Tonight's three doors for [_interest], and the one she tapped.
  List<Book> _shelfDoors = const [];
  Book? _picked;
  final _reader = ReadAloud();
  bool _mobile = false;
  /// Grumble's page: she has tapped his note to the edge, and what she calls
  /// him. The name lives only in this state; nothing she picks is kept.
  bool _grumbleSet = false;
  String _judgeName = 'Grumble';
  /// Listen along: the paragraph being read, whether the voice is going, and
  /// whether she has heard it to the end.
  int _listenPara = 0;
  bool _listening = false;
  bool _heardAll = false;
  /// A tiny read: the line she picked, as (paragraph, sentence).
  (int, int)? _favourite;
  /// Read on: how much she chose to read. Null until she picks; one line is
  /// the floor, never nothing.
  String? _amount;
  /// Back again, in order: she taps "I couldn't do it", then picks what it
  /// said. Lives only in this state and is cleared whenever the beat is left;
  /// nothing she taps here is kept.
  bool _couldnt = false;
  String? _heard;
  /// The prototype controls' day counter: which night of the eight it is.
  int _day = 1;
  /// Grumble's page and The Dark run the same three steps: the lantern plays
  /// in the middle, rises to its place, then the page appears under it. Only
  /// one of them is ever on screen, so they share the flags.
  bool _lanternDone = false;
  bool _lanternUp = false;

  static const _beats = [
    'Cover',
    'Grumble',
    'Three doors',
    'The way in',
    'Listen along',
    'A tiny read',
    'The quest',
    'Back again',
    'Read on',
    'Celebration',
    'The Dark',
  ];

  static const _listenStep = 4, _readOnStep = 8, _darkStep = 10;

  /// What she can call him instead. Picked, never typed: she contributes
  /// through choices, never free text.
  static const _judgeNames = ['Grumble', 'Mutter', 'Scrawl'];

  /// The celebration's first line changes a little from night to night, so it
  /// never turns into a payout she expects for finishing.
  static const _found = ['You found it.', 'That one is yours now.', 'Look what you noticed.'];

  /// What the Cover offers, one public-domain series each (book.dart has the
  /// shelves). [door] is the series' home-ground book, the one that is
  /// authored, and [title] is its title so the way in can name it before the
  /// shelf has loaded.
  static const _adventures = [
    (key: 'meadow', label: 'meadow creatures', door: 'old-mother-west-wind', title: 'Old Mother West Wind'),
    (key: 'animal-talk', label: 'talking animals', door: 'story-of-doctor-dolittle', title: 'The Story of Doctor Dolittle'),
    (key: 'forest', label: 'a bear in the woods', door: 'winnie-the-pooh', title: 'Winnie-the-Pooh'),
  ];

  static const _source = SeededBookSource();

  /// How far the two other doors may go. Fixed for the demo: one step, which
  /// with the one-stretch rule shows steps 0, 1 and 2.
  static const _reach = 1;

  ({String key, String label, String door, String title}) get _adventure =>
      _adventures.firstWhere((a) => a.key == _interest);

  /// The authored door for tonight. The story screens read their quest off
  /// this rather than carrying their own copy — doorways.dart is the writing of
  /// record. Only each series' home book is authored, so a door she taps that
  /// has none falls back to it, and [_doorTitle] follows, so the page never
  /// names one book and tells the story of another.
  Doorway get _door => doorways[_picked?.id] ?? doorways[_adventure.door]!;

  String get _doorTitle => doorways.containsKey(_picked?.id) ? _picked!.title : _adventure.title;

  @override
  void initState() {
    super.initState();
    _loadDoors();
  }

  /// Asks the shelf for tonight's doors. A slow answer for an adventure she has
  /// since changed away from is dropped rather than shown.
  void _loadDoors() {
    final interest = _interest;
    _source.doorsFor(interest: interest, reach: _reach).then((doors) {
      if (!mounted || interest != _interest) return;
      setState(() {
        _shelfDoors = doors;
        _picked = null;
      });
    });
  }

  void _choose(String interest) {
    setState(() => _interest = interest);
    _loadDoors();
  }

  /// Every way onto a beat goes through here, so arriving back on Grumble
  /// always relights the lantern and hides the page again until it is lit.
  void _go(int step) {
    // The voice belongs to the page it was reading; leaving the page ends it.
    _reader.stop();
    _goTo(step);
  }

  void _goTo(int step) => setState(() {
        _step = step;
        _lanternDone = false;
        _lanternUp = false;
        _listening = false;
        _couldnt = false;
        _heard = null;
      });

  void _next() => _go(math.min(_step + 1, _beats.length - 1));

  @override
  void dispose() {
    _reader.dispose();
    super.dispose();
  }

  void _reset() {
    _reader.stop();
    _resetState();
    _loadDoors();
  }

  void _resetState() => setState(() {
        _step = 0;
        _interest = _adventures.first.key;
        _picked = null;
        _grumbleSet = false;
        _judgeName = 'Grumble';
        _listenPara = 0;
        _heardAll = false;
        _favourite = null;
        _amount = null;
        _lanternDone = false;
        _lanternUp = false;
        _couldnt = false;
        _heard = null;
        _day = 1;
      });

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 480),
          switchInCurve: Curves.easeOutCubic,
          child: KeyedSubtree(key: ValueKey(_step), child: _screen()),
        ),
      ),
    );

    // The prototype controls always sit above and outside the app, never inside
    // the phone frame: they are the presenter's, and nobody watching should
    // read them as something the child sees.
    return Scaffold(
      backgroundColor: _mobile ? const Color(0xFFE7D5B8) : null,
      body: SafeArea(
        child: Column(children: [
          StoryNav(
            beats: _beats,
            step: _step,
            day: _day,
            mobile: _mobile,
            onJump: _go,
            onDay: (day) => setState(() => _day = day),
            onReset: _reset,
            onToggleMobile: () => setState(() => _mobile = !_mobile),
          ),
          Expanded(
            child: !_mobile
                ? content
                // Phone view: a 390 x 844 frame, the size of the device the
                // demo is written for, holding the app and nothing else.
                : Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 390, maxHeight: 844),
                      margin: const EdgeInsets.all(16),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFF3A2E1F), width: 2),
                      ),
                      child: content,
                    ),
                  ),
          ),
        ]),
      ),
    );
  }

  Widget _screen() {
    switch (_step) {
      case 0: return _welcome();
      case 1: return _marginNote();
      case 2: return _doors();
      case 3: return _storyPage();
      case 4: return _listen();
      case 5: return _tinyRead();
      case 6: return _quest();
      case 7: return _backAgain();
      case 8: return _readOn();
      case 9: return _earnedPage();
      default: return _close();
    }
  }

  Widget _welcome() => _PageScaffold(eyebrow: 'A little book for tonight', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _LanternMark(), const SizedBox(height: 52),
        Text('Hello, Maya.', style: _display(46)), const SizedBox(height: 12),
        Text('What kind of adventure do you want tonight?', style: _body(21)), const SizedBox(height: 30),
        Wrap(spacing: 10, runSpacing: 10, children: [for (final a in _adventures) ChoiceChip(
          label: Text(a.label), selected: _interest == a.key, onSelected: (_) => _choose(a.key),
          labelStyle: TextStyle(color: _interest == a.key ? const Color(0xFFF7F0E2) : const Color(0xFF325171), fontWeight: FontWeight.w800),
          selectedColor: const Color(0xFF3D6170), backgroundColor: const Color(0xFFE6D8C3), side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        )]), const SizedBox(height: 42),
        _WarmButton(label: 'Open tonight\'s book', icon: Icons.arrow_forward_rounded, onTap: _next), const SizedBox(height: 24),
        Text('You can change your mind at any time.', style: _small()),
      ]));

  /// The lantern, centred over whatever it sits in a Stack with, until it has
  /// finished [phase]; then it rises to the top. The screen leaves a gap of its
  /// height at the top for it to land in, so nothing jumps.
  Widget _risingLantern(LanternPhase phase, double height, {bool onDark = false}) => Positioned.fill(child: AnimatedAlign(
        alignment: _lanternDone || MediaQuery.of(context).disableAnimations ? Alignment.topCenter : Alignment.center,
        duration: const Duration(milliseconds: 470),
        curve: Curves.easeInOutCubic,
        onEnd: () => setState(() => _lanternUp = true),
        child: Lantern(phase: phase, height: height, onDark: onDark, onEnd: () => setState(() => _lanternDone = true)),
      ));

  /// Held back, and untappable, until the lantern has played and reached the top.
  Widget _afterLantern(Widget child) {
    final lit = _lanternUp || MediaQuery.of(context).disableAnimations;
    return IgnorePointer(
      ignoring: !lit,
      child: AnimatedOpacity(opacity: lit ? 1 : 0, duration: const Duration(milliseconds: 400), curve: Curves.easeOut, child: child),
    );
  }

  // Grumble is the Judge, not a curious friend (PLAN.md §5). The research on
  // externalizing a child's critic changed three things here. He is named
  // before she meets him, so she knows what she is looking at. She taps him to
  // the edge rather than rubbing him out: pushing a thought away tends to bring
  // it back, noticing it and reading on anyway does not. And he never gets the
  // last word on the page: an answer in ink points at something she really did.
  // She can rename him, by picking, because the name should be hers.
  //
  // He is a character, not a note that turns up from nowhere: on the first
  // night the book introduces him, with his face, before his note appears. On
  // later nights it only says he's back.
  Widget _marginNote() => _PageScaffold(eyebrow: _day == 1 ? 'Before we start' : 'A note in the margin', child: Stack(clipBehavior: Clip.none, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 66 + 18),
          _afterLantern(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_day == 1 ? 'Meet $_judgeName.' : '$_judgeName is back.', style: _display(42)), const SizedBox(height: 14),
                Text(_day == 1
                    ? "He lives in the margins of books and scribbles in grey pencil. He likes to tell you what you can't do. He is almost always wrong."
                    : 'Still scribbling. Still mostly wrong.', style: _body(20)),
              ])),
              const SizedBox(width: 16),
              GrumbleSketch(name: _judgeName),
            ]),
            const SizedBox(height: 22),
            Text('Here is what he wrote tonight.', style: _small()), const SizedBox(height: 6),
            AnimatedAlign(
              alignment: _grumbleSet ? Alignment.centerRight : Alignment.centerLeft,
              duration: const Duration(milliseconds: 520), curve: Curves.easeInOutCubic,
              // Faded and smaller at the edge, never erased: he is still there,
              // and she reads on anyway.
              child: AnimatedOpacity(
                opacity: _grumbleSet ? .45 : 1, duration: const Duration(milliseconds: 520),
                child: AnimatedScale(
                  scale: _grumbleSet ? .8 : 1, alignment: Alignment.centerRight, duration: const Duration(milliseconds: 520), curve: Curves.easeInOutCubic,
                  child: SizedBox(width: 245, child: MarginNote(
                    text: _door.marginalia.first,
                    label: "$_judgeName's note", hint: 'Tap the note to move it to the edge',
                    onWiped: _grumbleSet ? null : () => setState(() => _grumbleSet = true),
                  )),
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (!_grumbleSet)
              Text('Tap his note to move it to the edge. It can stay there.', style: _small())
            else ...[
              Text('He can stay at the edge. You can read anyway.', style: _small()), const SizedBox(height: 18),
              Text('Want to call him something else?', style: _body(18)), const SizedBox(height: 10),
              Wrap(spacing: 10, runSpacing: 10, children: [for (final name in _judgeNames) _Chip(label: name, selected: _judgeName == name, onTap: () => setState(() => _judgeName = name))]),
              const SizedBox(height: 26),
              _InkNote(text: Run.inkNote.text, from: Run.inkNote.from),
              const SizedBox(height: 34),
              _WarmButton(label: 'Turn the page', icon: Icons.arrow_forward_rounded, onTap: _next),
            ],
          ])),
        ]),
        _risingLantern(LanternPhase.lit, 66),
      ]));

  Widget _doors() {
    const colors = [Color(0xFFB8CDBD), Color(0xFFE6B28F), Color(0xFFA9B5D0)];
    String distance(Book b) => switch (b.stepsOut) { 0 => 'home ground', 1 => 'a small step away', _ => 'a little farther' };
    final books = _shelfDoors;
    return _PageScaffold(eyebrow: 'Three doors', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Which one is calling?', style: _display(43)), const SizedBox(height: 10), Text('There is no wrong door. Just one for tonight.', style: _body(20)), const SizedBox(height: 28),
      for (var i = 0; i < books.length; i++) ...[_Door(title: books[i].title, subtitle: distance(books[i]), color: colors[i % colors.length], onTap: () { setState(() { _picked = books[i]; _listenPara = 0; _heardAll = false; _favourite = null; _amount = null; }); _next(); }), if (i != books.length - 1) const SizedBox(height: 13)],
    ]));
  }

  Widget _storyPage() => _PageScaffold(eyebrow: 'The book opens', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // The whole passage is the button: a weak reader shouldn't have to find
        // the small line to be read to. Tap again to stop.
        ListenableBuilder(listenable: _reader, builder: (context, _) {
          final text = _door.spokenWayIn(_doorTitle);
          final reading = _reader.speaking == text;
          return Semantics(button: true, label: reading ? 'Stop reading' : 'Read this page to me', child: InkWell(
            onTap: () => _reader.toggle(text), borderRadius: BorderRadius.circular(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_doorTitle, style: _display(38)), const SizedBox(height: 25),
              Text(_door.wayIn, style: _story(21)),
              // The story stops here and the book turns to her: a quiet mark on
              // the page, as the recording pauses and chimes at the same place.
              if (_door.wayInAsk.isNotEmpty) ...[
                const SizedBox(height: 20),
                Center(child: Text('✦  ✦  ✦', style: _small().copyWith(color: const Color(0xFFB77A1F), letterSpacing: 2))),
                const SizedBox(height: 16),
                Text(_door.wayInAsk, style: _body(20, color: const Color(0xFF3D6170))),
              ],
              const SizedBox(height: 34),
              Row(children: [Icon(reading ? Icons.graphic_eq_rounded : Icons.volume_up_rounded, color: const Color(0xFF3D6170)), const SizedBox(width: 8), Flexible(child: Text(reading ? 'Reading to you. Tap to stop.' : 'Tap the page to read it to me', style: _small().copyWith(color: const Color(0xFF3D6170), fontWeight: FontWeight.w800)))]),
            ]),
          ));
        }), const SizedBox(height: 28),
        _WarmButton(label: 'Listen to the chapter', icon: Icons.headphones_rounded, onTap: _next),
      ]));

  /// The chapter for tonight's door, once it has loaded. Loaded once per book
  /// and cached, so moving between these pages doesn't flash.
  Widget _withChapter(Widget Function(Chapter c) page) {
    Widget show(Chapter? c) => c == null
        ? _PageScaffold(eyebrow: 'The book opens', child: Text("This book isn't in Lantern's library yet.", style: _body(20)))
        : page(c);
    final (done, chapter) = Chapter.loaded(_door.bookId);
    if (done) return show(chapter);
    return FutureBuilder<Chapter?>(
      future: Chapter.load(_door.bookId),
      builder: (context, snap) => snap.connectionState == ConnectionState.done ? show(snap.data) : const SizedBox.shrink(),
    );
  }

  // Listen along. Hearing a text before reading it is the best-supported way
  // to make a struggling reader's own reading easier, but following along only
  // helps when the pace is set for her, so the voice keeps a steady pace and
  // the word being read is marked. Paragraph by paragraph, so she can pause.
  Widget _listen() => _withChapter((c) => _PageScaffold(eyebrow: 'Listen along', fill: true, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: ListenableBuilder(listenable: _reader, builder: (context, _) => SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(c.title, style: _display(30)), const SizedBox(height: 16),
          for (var i = 0; i < c.paragraphs.length; i++)
            Padding(key: _paraKeys.putIfAbsent(i, GlobalKey.new), padding: const EdgeInsets.only(bottom: 14), child: _listenParagraph(c.paragraphs[i], i)),
        ])))),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: _WarmButton(
            label: _listening ? 'Pause' : _heardAll ? 'Hear it again' : _listenPara > 0 ? 'Keep listening' : 'Start listening',
            icon: _listening ? Icons.pause_rounded : Icons.play_arrow_rounded,
            onTap: () => _listening ? _pause() : _playFrom(_heardAll ? 0 : _listenPara, c),
          )),
          if (_heardAll) ...[const SizedBox(width: 12), Expanded(child: _WarmButton(label: 'Next', icon: Icons.arrow_forward_rounded, onTap: _next))],
        ]),
        if (!_heardAll) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _next, child: Text("I'll read it myself", style: _small()))),
      ])));

  final _paraKeys = <int, GlobalKey>{};

  Widget _listenParagraph(String text, int i) {
    final current = i == _listenPara && (_listening || _reader.speaking == text);
    final word = _reader.speaking == text ? _reader.word : null;
    final style = _story(20).copyWith(color: current || !_listening ? const Color(0xFF2B3939) : const Color(0xFF8A938F));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: current ? const Color(0xFFF4E3BE) : null, borderRadius: BorderRadius.circular(8)),
      child: word == null || word.$2 > text.length
          ? Text(text, style: style)
          : Text.rich(TextSpan(style: style, children: [
              TextSpan(text: text.substring(0, word.$1)),
              TextSpan(text: text.substring(word.$1, word.$2), style: const TextStyle(backgroundColor: Color(0xFFE9B96A))),
              TextSpan(text: text.substring(word.$2)),
            ])),
    );
  }

  void _playFrom(int i, Chapter c) {
    setState(() { _listenPara = i; _listening = true; _heardAll = false; });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _paraKeys[i]?.currentContext;
      if (ctx != null) Scrollable.ensureVisible(ctx, alignment: .25, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    });
    _reader.speak(c.paragraphs[i], onDone: () {
      if (!mounted || _step != _listenStep || !_listening) return;
      if (i + 1 < c.paragraphs.length) {
        _playFrom(i + 1, c);
      } else {
        setState(() { _listening = false; _heardAll = true; _listenPara = 0; });
      }
    });
  }

  void _pause() {
    _reader.stop();
    setState(() => _listening = false);
  }

  // A tiny read, straight after listening: a listening preview works when her
  // own reading follows it at once. One line she chose, read to herself. No
  // mic and no right answer; the Persona tab found she won't read aloud on
  // demand, and nothing she picks is kept.
  Widget _tinyRead() => _withChapter((c) => _PageScaffold(eyebrow: 'A tiny read', fill: true, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Find your favourite line.', style: _display(34)), const SizedBox(height: 8),
          Text('Tap it, then read it to yourself. Nobody is listening.', style: _body(19)), const SizedBox(height: 16),
          _TapText(
            paragraphs: c.paragraphs, bySentence: true, selected: _favourite,
            onTap: (p, i, _) => setState(() => _favourite = (p, i)),
          ),
        ]))),
        const SizedBox(height: 16),
        _WarmButton(label: _favourite == null ? 'Pick a line first' : 'I read it', icon: Icons.check_rounded, onTap: _favourite == null ? null : _next),
      ])));

  // The quest, after the chapter: a hands-on thing before her main reading,
  // and the one place she cannot be wrong. Anchor, quest and the line she says
  // when it is done, all read off the door.
  Widget _quest() => _DarkInterlude(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.nights_stay_rounded, size: 38, color: Color(0xFFECCB87)), const SizedBox(height: 26),
          Text('Now go find out.', style: _display(40, color: const Color(0xFFF7F0E2))), const SizedBox(height: 34),
          Text(_door.prompt, style: _display(24, color: const Color(0xFFECCB87))), const SizedBox(height: 12),
          Text(_door.behavior, style: _story(20).copyWith(color: const Color(0xFFE8DECB))), const SizedBox(height: 22),
          Text(_door.celebration, style: _body(19, color: const Color(0xFFD9CDBD))), const SizedBox(height: 44),
          TextButton(onPressed: _next, child: Text("I'm back", style: _small().copyWith(color: const Color(0xFFECCB87), fontWeight: FontWeight.w800))),
        ])),
      )));

  // Back from the quest. "I did it" goes on to her reading. "I couldn't" is the
  // intercept (PLAN.md \u00a75): one tap at real friction, then the book asks what
  // it said. It does not console her and does not reframe: two options, one
  // about the night rather than about her, and a close that lets it go. All
  // three read off the door.
  Widget _backAgain() => _PageScaffold(eyebrow: 'Night $_day', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (!_couldnt) ...[
          Text('Back again.', style: _display(44)), const SizedBox(height: 12), Text('How did the quest go?', style: _body(21)), const SizedBox(height: 34),
          _QuietChoice(label: 'I did it', onTap: () => _go(_readOnStep)), const SizedBox(height: 12),
          _QuietChoice(label: "I couldn't do it", onTap: () => setState(() => _couldnt = true)),
        ] else if (_heard == null) ...[
          Text('What did it just say to you?', style: _display(40)), const SizedBox(height: 28),
          for (final option in _door.interceptOptions) ...[_QuietChoice(label: option, onTap: () => setState(() => _heard = option)), const SizedBox(height: 12)],
        ] else ...[
          Text(_heard!, style: _story(20).copyWith(fontStyle: FontStyle.italic, color: const Color(0xFF7D827F))), const SizedBox(height: 18),
          Text(_door.interceptClose, style: _display(40)), const SizedBox(height: 42),
          _WarmButton(label: 'Close the book', icon: Icons.nights_stay_rounded, onTap: () => _go(_darkStep)),
        ],
      ]));

  // Read on, as much as she likes, from the part that answers what the quest
  // made her notice. Choosing raises motivation, but choosing how much is
  // untested and can settle at zero, so the floor is one line. Any word she
  // taps is read to her: help on demand, never instead of her reading.
  Widget _readOn() => _withChapter((c) {
        final from = c.paragraphWith(_door.readOnFrom);
        final shown = switch (_amount) {
          'a line' => [Chapter.sentences(c.paragraphs[from]).firstWhere((x) => x.contains(_door.readOnFrom ?? ''), orElse: () => Chapter.sentences(c.paragraphs[from]).first)],
          'a paragraph' => [c.paragraphs[from]],
          'a page' => _page(c.paragraphs, from),
          'the whole chapter' => c.paragraphs,
          _ => const <String>[],
        };
        return _PageScaffold(eyebrow: 'Read on', fill: true, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Read on, as much as you like.', style: _display(34)), const SizedBox(height: 8),
            Text(_door.readOn, style: _body(19)), const SizedBox(height: 14),
            Wrap(spacing: 10, runSpacing: 10, children: [for (final a in const ['a line', 'a paragraph', 'a page', 'the whole chapter']) _Chip(label: a, selected: _amount == a, onTap: () => setState(() => _amount = a))]),
            const SizedBox(height: 16),
            if (_amount == null)
              Text('Pick how much. One line counts.', style: _small())
            else ...[
              Text('Tap any word to hear it.', style: _small()), const SizedBox(height: 10),
              _TapText(paragraphs: shown, bySentence: false, onTap: (_, _, word) => _reader.speak(word)),
            ],
          ]))),
          const SizedBox(height: 16),
          _WarmButton(label: "I'm done reading", icon: Icons.check_rounded, onTap: _amount == null ? null : _next),
        ]));
      });

  /// About a page: paragraphs from [from] until roughly 150 words.
  static List<String> _page(List<String> paragraphs, int from) {
    final out = <String>[];
    var words = 0;
    for (var i = from; i < paragraphs.length && words < 150; i++) {
      out.add(paragraphs[i]);
      words += paragraphs[i].split(RegExp(r'\s+')).length;
    }
    return out;
  }

  // Celebrate what she found, never how much she read: a reward she can expect
  // for finishing undermines the wanting, and praise does little for children.
  // She says the line herself, and the first line shifts from night to night.
  Widget _earnedPage() => _PageScaffold(eyebrow: 'What you found', celebration: true, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Text('✦', style: TextStyle(fontSize: 34, color: Color(0xFFB77A1F))), const SizedBox(width: 10), Flexible(child: Text(_found[(_day - 1) % _found.length], style: _small().copyWith(fontWeight: FontWeight.w900, color: const Color(0xFF8B5B1F))))]), const SizedBox(height: 26),
        Text(_door.celebration, style: _display(36)), const SizedBox(height: 22), Text(_door.artifactInUse, style: _story(21)), const SizedBox(height: 24),
        _ArtifactSketch(label: _door.artifact), const SizedBox(height: 20), Text('There is still more to find tomorrow.', style: _story(21).copyWith(fontStyle: FontStyle.italic)), const SizedBox(height: 32), _WarmButton(label: 'Close the book', icon: Icons.nights_stay_rounded, onTap: _next),
      ]));

  Widget _close() => _DarkInterlude(child: Center(child: Stack(children: [
        _afterLantern(Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 72 + 30),
          Text('The lantern is dimming.', style: _display(38, color: const Color(0xFFF7F0E2)), textAlign: TextAlign.center), const SizedBox(height: 18), Text('Tomorrow, the door will remember you.', style: _body(20, color: const Color(0xFFD9CDBD)), textAlign: TextAlign.center), const SizedBox(height: 54),
          Text('closing in 09', style: GoogleFonts.spaceMono(fontSize: 14, color: const Color(0xFFECCB87), letterSpacing: 1.5)),
        ])),
        _risingLantern(LanternPhase.out, 72, onDark: true),
      ])));
}

TextStyle _display(double size, {Color? color}) => GoogleFonts.baloo2(fontSize: size, height: 1.05, fontWeight: FontWeight.w800, color: color ?? const Color(0xFF23363A));
TextStyle _body(double size, {Color? color}) => GoogleFonts.baloo2(fontSize: size, height: 1.35, fontWeight: FontWeight.w600, color: color ?? const Color(0xFF4D5B59));
TextStyle _story(double size) => GoogleFonts.baloo2(fontSize: size, height: 1.55, fontWeight: FontWeight.w600, color: const Color(0xFF2B3939));
TextStyle _small() => GoogleFonts.baloo2(fontSize: 14, height: 1.35, color: const Color(0xFF7C6D5C));

class _PageScaffold extends StatelessWidget {
  const _PageScaffold({required this.eyebrow, required this.child, this.celebration = false, this.fill = false});
  final String eyebrow; final Widget child; final bool celebration;
  /// The page takes the full height and [child] scrolls inside it, for pages
  /// holding a whole chapter with their buttons kept in view.
  final bool fill;
  @override
  Widget build(BuildContext context) => fill
      ? Padding(padding: const EdgeInsets.fromLTRB(18, 12, 18, 18), child: CustomPaint(painter: _PageBorderPainter(), child: Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(30, 30, 30, 24), color: const Color(0xFFF7F0E2), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(eyebrow.toUpperCase(), style: GoogleFonts.baloo2(fontSize: 11, letterSpacing: 1.7, fontWeight: FontWeight.w900, color: const Color(0xFF718080))), const SizedBox(height: 12), Expanded(child: child)]))))
      : Padding(padding: const EdgeInsets.fromLTRB(18, 12, 18, 18), child: Column(children: [
    Expanded(child: Center(child: SingleChildScrollView(child: CustomPaint(painter: _PageBorderPainter(), child: Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(30, 30, 30, 34), color: celebration ? const Color(0xFFF8E3A5) : const Color(0xFFF7F0E2), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(eyebrow.toUpperCase(), style: GoogleFonts.baloo2(fontSize: 11, letterSpacing: 1.7, fontWeight: FontWeight.w900, color: const Color(0xFF718080))), const SizedBox(height: 12), child])))))),
  ]));
}

class _WarmButton extends StatelessWidget {
  const _WarmButton({required this.label, required this.icon, required this.onTap}); final String label; final IconData icon; final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(label), style: FilledButton.styleFrom(backgroundColor: const Color(0xFF3D6170), foregroundColor: const Color(0xFFF7F0E2), minimumSize: const Size.fromHeight(58), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))));
}

/// A plain full-width choice, deliberately quieter than [_WarmButton]: none of
/// the intercept's answers is the right one, so none of them gets the fill.
class _QuietChoice extends StatelessWidget {
  const _QuietChoice({required this.label, required this.onTap}); final String label; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, child: OutlinedButton(onPressed: onTap, style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(58), alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), side: const BorderSide(color: Color(0xFFD5C8B5), width: 1.3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))), child: Text(label, style: _body(20, color: const Color(0xFF23363A)))));
}

class _Door extends StatelessWidget {
  const _Door({required this.title, required this.subtitle, required this.color, required this.onTap}); final String title, subtitle; final Color color; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(button: true, label: title, child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: Container(constraints: const BoxConstraints(minHeight: 82), padding: const EdgeInsets.all(12), decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFD5C8B5), width: 1.3)), child: Row(children: [_Cover(color: color), const SizedBox(width: 17), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(title, style: GoogleFonts.baloo2(fontSize: 22, fontWeight: FontWeight.w800)), const SizedBox(height: 1), Text(subtitle, style: _small())])), const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Color(0xFF718080))]))));
}

class _Cover extends StatelessWidget {
  const _Cover({required this.color}); final Color color;
  @override
  Widget build(BuildContext context) => Container(width: 52, height: 58, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4), topRight: Radius.circular(12), bottomRight: Radius.circular(5)), border: Border.all(color: const Color(0xFF60716F), width: 1.2)), child: const Center(child: Icon(Icons.auto_awesome, size: 22, color: Color(0xFF3D6170))));
}

class _ArtifactSketch extends StatelessWidget {
  const _ArtifactSketch({required this.label}); final String label;
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD1B76D), width: 1.2), borderRadius: BorderRadius.circular(16)), child: Row(children: [CustomPaint(size: const Size(76, 56), painter: _MothPainter()), const SizedBox(width: 16), Expanded(child: Text(label, style: _display(23, color: const Color(0xFF8B5B1F))))]));
}

class _LanternMark extends StatelessWidget {
  const _LanternMark();
  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 34, height: 34, decoration: const BoxDecoration(color: Color(0xFFE78A62), shape: BoxShape.circle), child: const Icon(Icons.light_mode_rounded, size: 20, color: Color(0xFF4B302B))), const SizedBox(width: 10), Flexible(child: Text('for curious readers', style: _small().copyWith(fontWeight: FontWeight.w800)))]);
}

class _DarkInterlude extends StatelessWidget {
  const _DarkInterlude({required this.child}); final Widget child;
  @override
  Widget build(BuildContext context) => Container(color: const Color(0xFF182629), width: double.infinity, height: double.infinity, padding: const EdgeInsets.all(34), child: child);
}

class _PageBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFFBCA991)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final path = Path()..moveTo(13, 2)..quadraticBezierTo(size.width * .28, 6, size.width * .52, 2)..quadraticBezierTo(size.width * .78, -1, size.width - 12, 4)..quadraticBezierTo(size.width - 6, size.height * .3, size.width - 11, size.height * .55)..quadraticBezierTo(size.width - 6, size.height * .8, size.width - 13, size.height - 3)..quadraticBezierTo(size.width * .7, size.height - 7, size.width * .46, size.height - 2)..quadraticBezierTo(size.width * .2, size.height + 2, 10, size.height - 4)..quadraticBezierTo(5, size.height * .7, 9, size.height * .48)..quadraticBezierTo(4, size.height * .22, 13, 2);
    canvas.drawPath(path, p);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MothPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFFE78A62);
    canvas.drawOval(Rect.fromLTWH(7, 12, 28, 34), p); canvas.drawOval(Rect.fromLTWH(40, 12, 28, 34), p); canvas.drawCircle(const Offset(38, 29), 7, Paint()..color = const Color(0xFF3D6170));
    final line = Paint()..color = const Color(0xFF3D6170)..strokeWidth = 1.5; canvas.drawLine(const Offset(34, 23), const Offset(25, 12), line); canvas.drawLine(const Offset(42, 23), const Offset(51, 12), line);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A small choice chip in the book's colours, for picks that aren't the
/// page's main action: a name for him, how much to read.
class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap}); final String label; final bool selected; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ChoiceChip(
        label: Text(label), selected: selected, onSelected: (_) => onTap(),
        labelStyle: TextStyle(color: selected ? const Color(0xFFF7F0E2) : const Color(0xFF325171), fontWeight: FontWeight.w800),
        selectedColor: const Color(0xFF3D6170), backgroundColor: const Color(0xFFE6D8C3), side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      );
}

/// The answer in ink, under Grumble's pencil: from a grown-up who knows her,
/// pointing at something she really did.
class _InkNote extends StatelessWidget {
  const _InkNote({required this.text, required this.from}); final String text; final String from;
  @override
  Widget build(BuildContext context) => Semantics(
        label: 'A note from $from: $text',
        child: Transform.rotate(angle: .012, child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
          decoration: BoxDecoration(color: const Color(0xFFFFFBF2), border: Border.all(color: const Color(0xFFC9D3E3)), borderRadius: BorderRadius.circular(6)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(text, style: GoogleFonts.caveat(fontSize: 27, height: 1.05, fontWeight: FontWeight.w600, color: const Color(0xFF24408E))),
            const SizedBox(height: 6),
            Align(alignment: Alignment.centerRight, child: Text(from, style: GoogleFonts.caveat(fontSize: 25, fontWeight: FontWeight.w700, color: const Color(0xFF24408E)))),
          ]),
        )),
      );
}

/// Chapter text she can touch: by sentence (pick a favourite line) or by word
/// (tap one to hear it). [onTap] gets the paragraph, the index of the sentence
/// or word within it, and its text.
class _TapText extends StatefulWidget {
  const _TapText({required this.paragraphs, required this.bySentence, required this.onTap, this.selected});
  final List<String> paragraphs;
  final bool bySentence;
  final (int, int)? selected;
  final void Function(int paragraph, int index, String text) onTap;
  @override
  State<_TapText> createState() => _TapTextState();
}

class _TapTextState extends State<_TapText> {
  final _recognizers = <TapGestureRecognizer>[];

  void _clear() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  @override
  void dispose() {
    _clear();
    super.dispose();
  }

  TextSpan _tappable(String text, VoidCallback onTap, {bool picked = false}) {
    final r = TapGestureRecognizer()..onTap = onTap;
    _recognizers.add(r);
    return TextSpan(text: text, recognizer: r, mouseCursor: SystemMouseCursors.click, style: picked ? const TextStyle(backgroundColor: Color(0xFFE9B96A)) : null);
  }

  @override
  Widget build(BuildContext context) {
    _clear();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      for (var p = 0; p < widget.paragraphs.length; p++)
        Padding(padding: const EdgeInsets.only(bottom: 14), child: Text.rich(TextSpan(style: _story(20), children: [
          if (widget.bySentence)
            for (final (i, sentence) in Chapter.sentences(widget.paragraphs[p]).indexed) ...[
              _tappable(sentence, () => widget.onTap(p, i, sentence), picked: widget.selected == (p, i)),
              const TextSpan(text: ' '),
            ]
          else
            for (final (i, m) in RegExp(r'\S+|\s+').allMatches(widget.paragraphs[p]).indexed)
              m.group(0)!.trim().isEmpty
                  ? TextSpan(text: m.group(0))
                  : _tappable(m.group(0)!, () => widget.onTap(p, i, m.group(0)!.replaceAll(RegExp(r'^[^\w]+|[^\w]+$'), ''))),
        ]))),
    ]);
  }
}
