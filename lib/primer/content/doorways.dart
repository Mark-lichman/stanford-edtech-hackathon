/// Hand-authored content for the doors. This is the demo's soul; it is writing,
/// not code, so it lives as plain const data with no logic anywhere near it.
///
/// Field names follow the HabitCrafts `habits` shape (prompt / behavior /
/// celebration / why) so a port is a copy, not a rewrite.
library;

class Doorway {
  const Doorway({
    required this.bookId,
    required this.wayIn,
    required this.prompt,
    required this.behavior,
    required this.celebration,
    required this.why,
    required this.returnLine,
    required this.artifact,
    required this.artifactInUse,
    required this.marginalia,
    required this.interceptOptions,
  });

  /// Matches [Book.id].
  final String bookId;

  /// Roughly eighty words: a setup, a hook, and a question she now needs
  /// answered. Then we hand her the book and close.
  final String wayIn;

  /// The anchor — an existing routine the quest hangs off.
  final String prompt;

  /// The quest, cut from the chapter so it only makes sense once she has read
  /// it. Indoors, alone, no tools, no strangers, no going outside.
  final String behavior;

  /// Said out loud by her, not by us.
  final String celebration;

  final String why;

  /// What she hunts for in the book and reads back in ten seconds. Deliberately
  /// a thing she has to find, because the hunting is what builds a reader.
  final String returnLine;

  final String artifact;

  /// Artifacts appear in use or not at all. No grid, no empty slots, no count.
  final String artifactInUse;

  /// Grey pencil, in the margin, wipeable. Second person, never first.
  final List<String> marginalia;

  /// The "I couldn't do it" path. At least one is about the situation rather
  /// than about her, and that is not decoration — it is the whole point.
  final List<String> interceptOptions;
}

const captainUnderpants = Doorway(
  bookId: 'underpants-1',
  wayIn: 'George and Harold get in trouble for everything. So they make comic '
      'books in a treehouse, and one of them is about a man in his underwear. '
      'Then they hypnotize their principal, and he becomes him. Somewhere in '
      "tonight's chapter the book stops telling the story and teaches you "
      'something instead. It is called Flip-O-Rama. Read it and find out what '
      'it is for. Then make one. Two drawings, one pencil, your thumb.',
  prompt: 'After you close the book tonight',
  behavior: 'Make one Flip-O-Rama. Two drawings on two pages, almost the same, '
      'with one thing moved. One pencil. Nothing else.',
  celebration: 'Flip it once, then say it out loud: I made that move.',
  why: 'Because George and Harold got in trouble for everything and still made '
      'the thing everybody wanted to read.',
  returnLine: 'Find the part where the book tells you how to hold the page. '
      'Read it out loud.',
  artifact: 'Two pages that move',
  artifactInUse: 'It goes in the back of the book, and the next time the story '
      'needs something to come alive, this is what it uses.',
  marginalia: [
    'you cant draw',
    'yours wont move',
    'thats a little kid thing',
  ],
  interceptOptions: [
    'Tonight was too full.',
    'It said I cant draw.',
  ],
);

/// Only the one door is authored. The other three are real books with no
/// content behind them yet, and the demo taps this one.
const doorways = <String, Doorway>{
  'underpants-1': captainUnderpants,
};
