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
    this.wayInAsk = '',
    required this.prompt,
    required this.behavior,
    required this.celebration,
    required this.why,
    required this.readOn,
    this.readOnFrom,
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

  /// What the book asks her to do next, after the story. Shown as its own
  /// paragraph and, in the recording, after a pause and a soft chime, so she
  /// can tell the story has stopped and the book is now talking to her.
  final String wayInAsk;

  /// The anchor — an existing routine the quest hangs off.
  final String prompt;

  /// The quest, cut from the chapter so it only makes sense once she has read
  /// it. Indoors, alone, no tools, no strangers, no going outside.
  final String behavior;

  /// Said out loud by her, not by us. Under a second.
  final String celebration;

  final String why;

  /// Where she starts reading on her own after the quest: the part of the
  /// chapter that answers what the quest made her notice. Deliberately a thing
  /// she has to find, because the hunting is what builds a reader. Read to
  /// herself, never aloud on demand (Persona tab: she won't).
  final String readOn;

  /// Words from the chapter text that mark where [readOn] starts, so the page
  /// can open there. Null when the book has no chapter text in Lantern.
  final String? readOnFrom;

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

  /// The way in exactly as it is read aloud: the book's title, then the words.
  /// The page and tool/render_voice.dart both read it from here, because a
  /// recording only plays when its text matches this to the letter.
  String spokenWayIn(String title) => wayInAsk.isEmpty ? '$title. $wayIn' : '$title. $wayIn $wayInAsk';
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
  readOn: 'Go to the back of the book and find the line that says how many '
      'steps it takes to draw him. Read it to yourself.',
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

/// Every authored door, keyed by [Book.id].
///
/// The three adventures' way-ins are recorded in Lily's voice, and a recording
/// only plays while the text matches it exactly. Change a way-in together with
/// a re-render (tool/render_voice.dart, about 400 characters a door), or that
/// way-in falls back to the device voice.
///
/// The first three are the Cover's adventures, one home-ground book per
/// public-domain series, and the run reads whichever one she chose. Only the
/// home-ground book of each series is authored; the other two doors on each
/// shelf fall back to it until somebody writes theirs.
///
/// Hilda, Dog Man and Harriet are the Epic shelves. Hilda was the one the demo
/// ran on before the adventures: it
/// is the only title that reads in twenty minutes whole, the only one at a
/// level she can read aloud, and its quest is the Field Guide screen. Dog Man
/// is the verified fallback. Harriet waits on somebody confirming Hamster
/// Princess is in Epic's catalogue at all.
///
/// Only one of these gets rehearsed. Authoring three was cheap; rehearsing
/// three is how a demo dies.
const doorways = <String, Doorway>{
  'old-mother-west-wind': oldMotherWestWind,
  'story-of-doctor-dolittle': storyOfDoctorDolittle,
  'winnie-the-pooh': winnieThePooh,
  'hilda-troll': hildaAndTheTroll,
  'dog-man-1': dogMan,
  'harriet-invincible': harrietTheInvincible,
};

/// The meadow adventure: Thornton Burgess.
///
/// The Merry Little Breezes' whole day is going round to everybody and asking
/// for the news, and Grandfather Frog always has some. That is the Field Guide
/// habit with a frog's voice on it, and it needs no going outside: a spider in
/// a corner is news if you watched it long enough.
///
/// Chapter one is about five minutes. It has Farmer Brown with a gun and Tommy
/// Brown after the eggs; both are foiled, and it is gentle by 1910 standards.
const oldMotherWestWind = Doorway(
  bookId: 'old-mother-west-wind',
  wayIn: 'Every morning Old Mother West Wind comes down from the Purple Hills '
      'with a big bag over her shoulder. In the bag are her children, the '
      'Merry Little Breezes. She shakes them out onto the Green Meadows, and '
      'the first thing they do is race round to everybody and ask for the '
      'news. Grandfather Frog always has some.',
  wayInAsk: 'Listen to the first chapter. It is short. Then find out what the news '
      'is in your house.',
  prompt: 'After the chapter ends',
  behavior: 'Find one living thing in your house: a plant, a spider in a '
      'corner, a fly on the window, a pet. Watch it until you notice one thing '
      'nobody ever told you about it. Then write it down as news, the way '
      'Grandfather Frog would say it. Start with Chug-arum.',
  celebration: 'Say it out loud: Chug-arum, I have news.',
  why: 'Because the Breezes are not cleverer than anybody else. They just go '
      'and look, every single morning.',
  readOn: 'Start where Grandfather Frog says good morning.',
  readOnFrom: 'which was his way of saying good morning',
  artifact: 'A piece of news from your house',
  artifactInUse: 'The Breezes carry it home over the Purple Hills tonight, and '
      'tomorrow Grandfather Frog tells it first.',
  marginalia: [
    'nothing lives in your house',
    'thats not news',
    'it didnt even do anything',
  ],
  interceptOptions: [
    'Tonight was too full.',
    'It said nothing happened.',
  ],
  interceptClose: "You heard it. That's the hard part.",
);

/// The talking-to-animals adventure: Hugh Lofting.
///
/// Chapter two is the whole quest. Polynesia tells the Doctor that animals talk
/// "with their ears, with their feet, with their tails", and the Doctor learns
/// by watching Jip twitch his nose and writing it down in the butcher's book.
/// She does the same with whatever animal she has, or the one at the window.
///
/// Chapter two only, "Animal Language": chapters one and two together run
/// about twenty minutes read aloud, too long for a bedtime, and two is where
/// the quest comes from. Only these two have been read for this door; the
/// first book has passages later on that we will not send a child to.
const storyOfDoctorDolittle = Doorway(
  bookId: 'story-of-doctor-dolittle',
  wayIn: 'Doctor Dolittle has so many animals in his house that people stop '
      'coming to see him. Then one rainy afternoon his parrot, Polynesia, '
      'tells him a secret. Animals can talk. Not just parrots. All of them. '
      'They just do not always use their mouths, and you only hear it if you '
      'watch. The Doctor gets a pencil and starts writing it down.',
  wayInAsk: 'Listen to the chapter where it happens. Then go and watch an animal '
      'the way Polynesia taught him.',
  prompt: 'After the chapter ends',
  behavior: 'Find an animal in your house or out of your window: a pet, a '
      'bird, a fly, a spider. Watch it without making a sound. Write down one '
      'thing it said without using its mouth: what it did, and what you think '
      'it meant.',
  celebration: 'Say it out loud: I heard that.',
  why: 'Because the Doctor did not learn animal language by being clever. He '
      "learned it by watching Jip's nose.",
  readOn: 'Start where Polynesia tells the Doctor what animals talk with.',
  readOnFrom: 'talk with their ears',
  artifact: 'The first word in your animal dictionary',
  artifactInUse: 'Later an animal in the story says it to you, and you are the '
      'only one who knows what it means.',
  marginalia: [
    'animals dont talk',
    'you dont know what it meant',
    'it was just scratching',
  ],
  interceptOptions: [
    'Tonight was too full.',
    'It said I was making it up.',
  ],
  interceptClose: "You heard it. That's the hard part.",
);

/// The forest adventure: A. A. Milne.
///
/// Pooh hears a buzzing, sits down, and says "That buzzing-noise means
/// something", then makes up songs all the way up the tree. Thinking about one
/// sound for longer than anyone else would is the same habit as Hilda's
/// drawing, and a hum is a thing she makes, not a score.
const winnieThePooh = Doorway(
  bookId: 'winnie-the-pooh',
  wayIn: 'Winnie-the-Pooh is a bear who lives in a forest. One day he hears a '
      'buzzing at the top of a tree, so he sits down and thinks. A buzzing '
      'like that must mean something. Then he climbs, and makes up a song on '
      'the way, and it all goes wrong in a very funny way.',
  wayInAsk: 'Listen to the first chapter. Then find a sound in your house that '
      'keeps going, and work out what it means.',
  prompt: 'After the chapter ends',
  behavior: 'Find a sound in your house that keeps going: the fridge, a clock, '
      'the pipes, the rain. Sit next to it and think like Pooh. What is making '
      'it, and why? Then make up a little song about it, four lines, the way '
      'Pooh sings on his way up the tree.',
  celebration: 'Say it out loud: That means something.',
  why: 'Because Pooh is not clever, and he still works it out. He just thinks '
      'about one sound for longer than anybody else would.',
  readOn: 'Start where Pooh hears the buzzing and sits down to think.',
  readOnFrom: 'That buzzing-noise means something',
  artifact: 'Your first hum',
  artifactInUse: 'One night the story goes quiet, and your hum is the thing '
      'that gets it moving again.',
  marginalia: [
    'its just the fridge',
    'your song is silly',
    'that doesnt mean anything',
  ],
  interceptOptions: [
    'Tonight was too full.',
    'It said my song was silly.',
  ],
  interceptClose: "You heard it. That's the hard part.",
);

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
  readOn: 'Find the line where Harriet works out what the curse really '
      'means. Read it to yourself.',
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
  readOn: 'Go back to the first page and find the very first thing anybody '
      'says out loud. Read it to yourself.',
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
