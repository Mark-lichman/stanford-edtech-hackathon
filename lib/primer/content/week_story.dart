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
/// character, and the text went through six rounds of review by that persona:
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

/// How much of him the story shows, decided by a persona review before it was
/// built: he is the theme, never the star. He is not on the title page. His
/// sketch appears once, small, on the page where she names him; elsewhere he
/// is only a pencil slip in the margin, answered on the same page in larger,
/// darker type, so Maya always has the last word. On the last page the margin
/// is quiet and he has put his pencil down: he retires without being
/// shrunk or beaten.
class WeekPage {
  const WeekPage(this.text, {this.verse = const [], this.scrawl, this.answer, this.after, this.namesHim = false, this.quiet});

  /// What the page says. A line break starts a new line.
  final String text;

  /// Her own hum, set as lines.
  final List<String> verse;

  /// Grumble's pencil, in his new name. Drawn, never read aloud.
  final String? scrawl;

  /// The proof that answers him, straight under his note.
  final String? answer;

  /// Plain story text that carries on after the answer.
  final String? after;

  /// The page where she renames him: the one place his face is drawn.
  final bool namesHim;

  /// An empty slip in the margin and this line: the night he doesn't write.
  final String? quiet;

  /// What the voice reads: everything on the page except his pencil.
  String get spoken => [text, ...verse, ?answer, ?after, ?quiet].join(' ');
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
///
/// [answered] is who answered Grumble that night: the theme for grown-ups is
/// her progress, so the slide shows who answered him, not a list of what he
/// said. Only Wednesday quotes him, because that is where honesty matters.
const weekNights = <({String day, String book, String found, String answered})>[
  (day: 'Mon', book: 'Old Mother West Wind', found: 'Her first news: Biscuit the cat "sleeps with one ear awake."', answered: 'Maya'),
  (day: 'Tue', book: 'The Story of Doctor Dolittle', found: 'Cat talk at dinner: "Tail tip flick = HURRY UP."', answered: 'Dad'),
  (day: 'Wed', book: 'Winnie-the-Pooh', found: 'Couldn\'t do the quest. Grumble wrote "your song is silly". The book asked what the voice said, then let it go.', answered: 'He got through'),
  (day: 'Thu', book: 'Winnie-the-Pooh', found: 'Went back and finished her dishwasher hum. Renamed Grumble "Scrawl".', answered: 'Maya'),
  (day: 'Fri', book: 'The Adventures of Peter Cottontail', found: 'Found Mr Legs, the spider who hides behind the bathroom tap.', answered: 'Maya'),
  (day: 'Sat', book: 'Old Mother West Wind', found: 'The radiator ticks slow "when it\'s going to sleep."', answered: 'Maya'),
  (day: 'Sun', book: 'The Story of Doctor Dolittle', found: '"Slow blink = I like you but I\'m busy."', answered: 'Maya'),
];

/// For the grown-ups: what Scrawl is, and why the book never fights him.
const aboutScrawl = 'Scrawl is how Lantern draws Maya\'s inner critic, the voice that says she is bad at reading. '
    'The book never fights or erases him. It lets her notice him, then answers him with proof from her own week. '
    'He got through once, on Wednesday. By the weekend, Maya was answering him herself.';

/// One bedtime walk through the house, so the week reads as one story rather
/// than a tour of moments. Scrawl dares her on page 3, she goes looking for
/// news for the Merry Little Breezes (landing, bathroom, stairs, kitchen, back
/// to bed), and page 11 answers the dare in her own Monday words. Connecting
/// narration is only ever where she goes and when; what she found and said is
/// her week, quoted. Reviewed six times by the persona, the last two for
/// cohesion.
const weekStory = <WeekPage>[
  WeekPage('It is bedtime, and the house is quiet. Soon the Merry Little Breezes will come. They always ask, "What is the news?"'),
  WeekPage('There is a grey pencil in this book. It used to be called Grumble. "Grumble is a baby name," says Maya. "He\'s messy, so he\'s Scrawl."', namesHim: true),
  WeekPage('', scrawl: 'nothing lives in your house', answer: 'Maya picks up her field guide. She goes looking for news.'),
  WeekPage(
    'On the landing, Biscuit is asleep on the warm radiator. Maya writes her news the Grandfather Frog way:\n'
    '"Chug-arum. Biscuit sleeps with one ear awake. It turns when the fridge opens."',
  ),
  WeekPage(
    'The radiator ticks fast when it\'s getting hot and slow when it\'s going to sleep. The dust creature is waiting.',
    scrawl: 'thats not news',
    answer: '"It is to me," says Maya.',
  ),
  WeekPage(
    'In the bathroom, Mr Legs lives behind the tap. He goes in when the water runs and comes out when it stops.',
    scrawl: 'it will be gone tomorrow',
    answer: 'Maya checks the tap. Mr Legs is there.',
    after: 'Maya wants to know if spiders sleep.',
  ),
  WeekPage('Maya goes down the stairs. Biscuit wakes up and follows her. On the stairs, Biscuit blinks at Maya. Slowly.'),
  WeekPage(
    'Slow blink = I like you but I\'m busy.',
    scrawl: 'it was just blinking',
    answer: '"You don\'t speak cat," says Maya.',
    after: 'Earlier, at dinner, when Dad picked up the tin, the tip of Biscuit\'s tail flicked. Tail tip flick = HURRY UP.',
  ),
  WeekPage(
    'In the kitchen, the dishwasher hums. Pooh says, "That buzzing-noise means something." Maya has a hum for the dishwasher:',
    verse: [
      'The dishwasher is humming,',
      'it hums when we\'re in bed,',
      'it washes all the spoons up',
      'and the light goes green not red.',
    ],
  ),
  WeekPage(
    'Back in bed, Maya opens her field guide.\n'
    '"The dust creature under the radiator. It only comes out when the heating stops ticking."\n'
    '"The green mark on the back of the third stair. It was there before we were."',
  ),
  WeekPage('"Biscuit LIVES here," says Maya.'),
  WeekPage(
    'The Merry Little Breezes come. "What is the news?" Maya has lots.',
    quiet: 'The margin is quiet. Scrawl has put his pencil down.',
  ),
];
