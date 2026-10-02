/// Night eight: the book tells a story about Maya, made from her first week.
///
/// Everything in it is something she did, quoted as she wrote it. That is the
/// product invariant (Product design tab): the story accumulates what the
/// child actually did, which a freshly generated story cannot fake. Scrawl is
/// the name she gave Grumble on night four; he appears in pencil four times,
/// and every time the page answers him with proof he was wrong. He is never
/// erased, shrunk or fought, and he is never read aloud.
///
/// Seeded for the showcase. Her week was chosen by our research persona in
/// character, and the text went through four rounds of review by that persona:
///
///   Mon  Old Mother West Wind   Biscuit "sleeps with one ear awake"
///   Tue  Doctor Dolittle        "Tail tip flick = HURRY UP"
///   Wed  Winnie-the-Pooh        couldn't do it; took the intercept
///   Thu  Winnie-the-Pooh        finished the dishwasher hum; renamed him Scrawl
///   Fri  Peter Cottontail       Mr Legs behind the bathroom tap
///   Sat  Old Mother West Wind   the radiator ticks slow "when it's going to sleep"
///   Sun  Doctor Dolittle        "Slow blink = I like you but I'm busy"
///
/// Kept out on purpose, because each would read to her as being watched,
/// judged or scored: Wednesday, her brother laughing at the hum, how much she
/// read on any night, and the line she picked in the intercept.
library;

class WeekPage {
  const WeekPage(this.text, {this.verse = const [], this.scrawl, this.answer});

  /// What the page says. A line break starts a new line.
  final String text;

  /// Her own hum, set as lines.
  final List<String> verse;

  /// Grumble's pencil, in his new name. Drawn, never read aloud.
  final String? scrawl;

  /// The proof that answers him, straight under his note.
  final String? answer;

  /// What the voice reads: everything on the page except his pencil.
  String get spoken => [text, ...verse, ?answer].join(' ');
}

const weekStoryTitle = 'Maya and the Night House';

/// Her chosen name for him this week.
const weekJudgeName = 'Scrawl';

/// The books she picked this week, shown on the title page. Titles only: how
/// many nights or how much she read would turn the page into a scorecard.
const weekBooks = [
  'Old Mother West Wind',
  'The Story of Doctor Dolittle',
  'Winnie-the-Pooh',
  'The Adventures of Peter Cottontail',
];

/// Her week, night by night, for the grown-ups' slide: what a parent or a
/// sponsor needs to see before the story makes sense. Grown-ups may see the
/// hard night; the story she reads never mentions it.
const weekNights = <({String day, String book, String found})>[
  (day: 'Mon', book: 'Old Mother West Wind', found: 'Her first news: Biscuit the cat "sleeps with one ear awake."'),
  (day: 'Tue', book: 'The Story of Doctor Dolittle', found: 'Cat talk at dinner: "Tail tip flick = HURRY UP."'),
  (day: 'Wed', book: 'Winnie-the-Pooh', found: "Couldn't do the quest. The book asked what the voice said, then let it go."),
  (day: 'Thu', book: 'Winnie-the-Pooh', found: 'Went back and finished her dishwasher hum. Renamed Grumble "Scrawl".'),
  (day: 'Fri', book: 'The Adventures of Peter Cottontail', found: 'Found Mr Legs, the spider who hides behind the bathroom tap.'),
  (day: 'Sat', book: 'Old Mother West Wind', found: 'The radiator ticks slow "when it\'s going to sleep."'),
  (day: 'Sun', book: 'The Story of Doctor Dolittle', found: '"Slow blink = I like you but I\'m busy."'),
];

/// Eleven pages, reviewed four times by the persona. Pages 3, 4, 6, 7 and 9
/// came in the fourth round, from parts of her week the first draft left out.
const weekStory = <WeekPage>[
  WeekPage('The house is quiet. Maya looks for news. The Merry Little Breezes do that too. "What is the news?"'),
  WeekPage(
    'Maya\'s first stop is Biscuit. Biscuit is asleep on the warm radiator. Maya writes her news the Grandfather Frog way:\n'
    '"Chug-arum. Biscuit sleeps with one ear awake. It turns when the fridge opens."',
  ),
  WeekPage('There is a grey pencil in this book. It used to be called Grumble. "Grumble is a baby name," says Maya. "He\'s messy, so he\'s Scrawl."'),
  WeekPage('At dinner, Biscuit sits by his bowl. Dad picks up the tin. The tip of Biscuit\'s tail flicks. Maya knows cat talk, like Doctor Dolittle. Tail tip flick = HURRY UP.'),
  WeekPage(
    'On the stairs, Biscuit blinks at Maya. Slow blink = I like you but I\'m busy.',
    scrawl: 'it was just blinking',
    answer: '"You don\'t speak cat," says Maya.',
  ),
  WeekPage('Peter Cottontail has a hiding place in the briar patch. Mr Legs has one too. Mr Legs lives behind the tap. He goes in when the water runs and comes out when it stops.'),
  WeekPage(
    '',
    scrawl: 'it will be gone tomorrow',
    answer: 'Maya checks the tap before bed. Mr Legs is there. Maya wants to know if spiders sleep.',
  ),
  WeekPage(
    'The radiator ticks fast when it\'s getting hot and slow when it\'s going to sleep. The dust creature is waiting.',
    scrawl: 'thats not news',
    answer: '"It is to me," says Maya. The dust creature under the radiator. It only comes out when the heating stops ticking.',
  ),
  WeekPage(
    'Down in the kitchen, the dishwasher hums. Pooh says, "That buzzing-noise means something." Maya has a hum for the dishwasher:',
    verse: [
      'The dishwasher is humming,',
      'it hums when we\'re in bed,',
      'it washes all the spoons up',
      'and the light goes green not red.',
    ],
  ),
  WeekPage(
    '',
    scrawl: 'nothing lives in your house',
    answer: 'Biscuit lives here.\nMr Legs lives here.\nThe dust creature lives here.\nThe green mark on the back of the third stair. It was there before we were.',
  ),
  WeekPage('Maya goes up the stairs. If the Merry Little Breezes ask Maya, "What is the news?" she has lots.'),
];
