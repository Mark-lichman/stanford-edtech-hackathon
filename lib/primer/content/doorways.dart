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
    required this.interceptClose,
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

  /// Said out loud by her, not by us. Under a second.
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

  /// What the book says after she taps one. It does not console her and it does
  /// not reframe anything.
  final String interceptClose;
}

/// The one authored door.
///
/// The quest is the back matter of the book itself — Pilkey stops the story and
/// teaches you to draw Dog Man in twenty-eight steps — so it is cut from the
/// chapter rather than bolted onto it. Paper and a pencil, indoors, alone: it
/// clears the content safety rule with room to spare.
///
/// The marginalia and the quest are aimed at each other on purpose. Grumble
/// says she can't draw; the book answers with twenty-eight ridiculously easy
/// steps. We never argue with him — the book just quietly turns out to be right.
const dogMan = Doorway(
  bookId: 'dog-man-1',
  wayIn: 'George and Harold are in trouble again, so they made a comic. It is '
      'about a police dog and a policeman who get hurt on the same day, and a '
      'doctor who fixes it in the dumbest way anybody has ever thought of. '
      'That is chapter one. Read it. Then go to the very back, where Dav '
      'Pilkey stops the story and shows you how to draw Dog Man in '
      'twenty-eight ridiculously easy steps. Do all twenty-eight. Then give '
      "him one thing he doesn't have.",
  prompt: 'After you close the book tonight',
  behavior: 'Draw Dog Man. All twenty-eight steps, in order, the way the back '
      'of the book shows you. Then add one thing to him that Dav Pilkey did '
      'not draw.',
  celebration: 'Hold it up and say it out loud: I drew that.',
  why: 'Because the man who drew this got sent out of class for drawing, and '
      'drew anyway.',
  returnLine: 'Go to the back of the book and find the line that says how many '
      'steps it takes to draw him. Read it out loud.',
  artifact: 'A Dog Man with one thing nobody else gave him',
  artifactInUse: 'He turns up in the story later, and the thing you added is '
      'the thing that works.',
  marginalia: [
    'you cant draw',
    'yours will look wrong',
    'twenty-eight is too many',
  ],
  interceptOptions: [
    'Tonight was too full.',
    "It said I can't draw.",
  ],
  interceptClose: "You heard it. That's the hard part.",
);

/// Three authored doors, all real books. Hilda is the one the demo runs on: it
/// is the only title that reads in twenty minutes whole, the only one at a
/// level she can read aloud, and its quest is the Field Guide screen. Dog Man
/// is the verified fallback. Harriet waits on somebody confirming Hamster
/// Princess is in Epic's catalogue at all.
///
/// Only one of these gets rehearsed. Authoring three was cheap; rehearsing
/// three is how a demo dies.
const doorways = <String, Doorway>{
  'hilda-troll': hildaAndTheTroll,
  'dog-man-1': dogMan,
  'harriet-invincible': harrietTheInvincible,
};

/// The fractions door.
///
/// Harriet is good at exactly two things, checkers and fractions, and she does
/// them in her head while falling off cliffs. That is the whole trick here: the
/// fractions are hers, not ours. The moment we hand a child a worksheet with a
/// hamster on it we have built the thing we said we would not build.
///
/// So the quest is not fraction practice. It is a physical limit she finds with
/// her own hands — a sheet of paper stops folding after about seven, and nobody
/// believes that until they try it. The fraction is what she writes down at the
/// end to describe what happened, which is what fractions are actually for.
///
/// Depends on the unverified 'fractions' shelf. Don't rehearse against this one
/// until the Epic links are real.
const harrietTheInvincible = Doorway(
  bookId: 'harriet-invincible',
  wayIn: 'Harriet Hamsterbone is a princess, which she thinks is boring. She is '
      'good at two things: checkers and fractions. Then her parents tell her a '
      'rat cursed her as a baby, and that she will prick her finger on a '
      'hamster wheel when she turns twelve. Harriet works out what this means '
      'faster than they do. It means nothing can hurt her until then. Read '
      'chapter one and find out the first thing she does about it. Then get '
      'one piece of paper.',
  prompt: 'After you close the book tonight',
  behavior: 'One piece of paper. Fold it in half. Fold it in half again. Keep '
      'going for as long as your hands can do it. Then open it out, count the '
      'boxes, and write on one box what fraction of the paper it is.',
  celebration: 'Hold the paper up and say it out loud: I found where it stops.',
  why: 'Because Harriet does fractions in her head while falling off a cliff, '
      'and you just did one on the floor of your room.',
  returnLine: 'Find the line where Harriet works out what the curse really '
      'means. Read it out loud.',
  artifact: 'A sheet of paper folded as far as it goes',
  artifactInUse: 'Later the story needs something small enough to hide, and '
      'this is the only thing you have that is small enough.',
  marginalia: [
    'youll get the fraction wrong',
    'thats just a piece of paper',
    'you always stop halfway',
  ],
  interceptOptions: [
    'Tonight was too full.',
    "It said I'd get it wrong.",
  ],
  interceptClose: "You heard it. That's the hard part.",
);

/// The creatures door, and the one the demo taps.
///
/// Hilda's own practice is the quest: she goes out, she looks at something for
/// longer than anybody else would, and she draws it. That is also, exactly,
/// screen 5 of this app — the Field Guide is the thing Hilda already does. The
/// artifact she makes on night one is literally the first page of it.
///
/// One deliberate divergence from the book: Hilda goes outside and we do not
/// send children outside. The looking is the transferable part, and a shelf
/// nobody has looked behind is as unexplored as a wilderness when you are nine.
///
/// Verify before the rehearsal: that the opening pages actually show her
/// drawing. The sketchbook is central to the character and the Netflix series
/// makes it explicit, but it is worth two minutes with the real pages.
const hildaAndTheTroll = Doorway(
  bookId: 'hilda-troll',
  wayIn: 'Hilda lives in a house at the edge of the wilderness, and she cannot '
      'sit still. She goes out with a sketchbook and draws the things she '
      'finds. Most people in her world pretend the creatures are not there. '
      'Hilda draws them anyway, which is why she is the one who knows what '
      'they are. Read it tonight — it is short. Then find one thing in your '
      'house that nobody has ever really looked at, and draw it.',
  prompt: 'After you close the book tonight',
  behavior: 'Find one thing in your house that nobody looks at — under the '
      'sofa, the back of a shelf, the corner of a window. Sit in front of it '
      'and draw it. Give it a name, like it is a creature. Write one true '
      'thing about it underneath.',
  celebration: 'Hold up the page and say it out loud: I found that.',
  why: 'Because Hilda is not braver than everybody else. She just looks at '
      'things for longer.',
  returnLine: 'Go back to the first page and find the very first thing anybody '
      'says out loud. Read it.',
  artifact: 'The first page of your field guide',
  artifactInUse: 'It goes in the front of the Field Guide, and everything you '
      'find after tonight goes in behind it.',
  marginalia: [
    'thats not a real creature',
    'youre just making it up',
    'nobody wants to see that',
  ],
  interceptOptions: [
    'Tonight was too full.',
    'It said I was making it up.',
  ],
  interceptClose: "You heard it. That's the hard part.",
);
