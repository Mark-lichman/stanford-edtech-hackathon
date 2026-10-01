/// The seam between the journey and wherever books come from.
///
/// Mark writes this; Amlan fills in [EpicBookSource] if there turns out to be
/// anything to fill it in with. The demo runs on [SeededBookSource] either way,
/// so nothing downstream waits on the Epic question being answered.
library;

class Book {
  const Book({
    required this.id,
    required this.title,
    required this.stepsOut,
    required this.deepLink,
    this.linkConfirmed = false,
    this.coverUrl,
  });

  final String id;
  final String title;

  /// Distance from the child's home ground. 0 is something she already loves.
  final int stepsOut;

  /// Where tapping the door sends her. For Epic this is
  /// `https://www.getepic.com/book/{id}`; for a public-domain book it is the
  /// Project Gutenberg page; for a seeded book it may be a stub.
  final String deepLink;

  final String? coverUrl;

  /// True only when somebody has opened [deepLink] and seen the book.
  /// Deliberately explicit rather than derived from the URL shape: pasting
  /// a plausible getepic.com link must never be enough to make a door
  /// claimable on stage. Amlan flagged the unconfirmed ones (a4f7416); the
  /// ids they replaced are in git history if they turn out to be good.
  final bool linkConfirmed;

  bool get isHomeGround => stepsOut == 0;

}

abstract interface class BookSource {
  /// The three doors for tonight.
  ///
  /// Always returns exactly three, and one of them is always home ground —
  /// that rule is the product, not a detail, so it lives here rather than in
  /// the UI where someone could quietly drop it.
  Future<List<Book>> doorsFor({required String interest, required int reach});
}

/// Hand-entered books. Ships today, always works, and we say so on stage.
class SeededBookSource implements BookSource {
  const SeededBookSource();

  // One evening, one shelf. Every link in 'funny' is a real Epic book id,
  // checked against getepic.com — if a door opens nothing on stage the pitch
  // dies in the first ten seconds.
  //
  // Magic Tree House is deliberately absent: Epic's own recommendation pages
  // list it under "available on Amazon", not on Epic. Don't put it back without
  // a working getepic.com/book link.
  static const _shelf = <String, List<Book>>{
    // The three adventures the Cover offers. Each is one public-domain series
    // (US: published 1930 or earlier), so the door opens the whole real book
    // on Project Gutenberg and nothing waits on Epic. Every id was looked up on
    // gutenberg.org and the title on the page matches.
    //
    // Thornton Burgess: the meadow animals, told as bedtime-length chapters by
    // a naturalist. The Bird Book is a field guide written as a story.
    'meadow': [
      Book(
        id: 'old-mother-west-wind',
        title: 'Old Mother West Wind',
        stepsOut: 0,
        deepLink: 'https://www.gutenberg.org/ebooks/2557',
        linkConfirmed: true,
      ),
      // His rabbit is called Peter Rabbit in the text, the same name as
      // Potter's, which Frederick Warne trademarks. The text is free to use;
      // keep the name off anything we brand.
      Book(
        id: 'peter-cottontail',
        title: 'The Adventures of Peter Cottontail',
        stepsOut: 1,
        deepLink: 'https://www.gutenberg.org/ebooks/46866',
        linkConfirmed: true,
      ),
      Book(
        id: 'reddy-fox',
        title: 'The Adventures of Reddy Fox',
        stepsOut: 2,
        deepLink: 'https://www.gutenberg.org/ebooks/1825',
        linkConfirmed: true,
      ),
      Book(
        id: 'burgess-bird-book',
        title: 'The Burgess Bird Book for Children',
        stepsOut: 3,
        deepLink: 'https://www.gutenberg.org/ebooks/3074',
        linkConfirmed: true,
      ),
    ],

    // Hugh Lofting, 1920 to 1928. The originals carry racist passages (the
    // Prince Bumpo chapters in the first two books), and the cleaned-up 1988
    // editions are still in copyright, so every chapter a door sends her to is
    // one somebody has read first. The authored door uses chapters one and two.
    'animal-talk': [
      Book(
        id: 'story-of-doctor-dolittle',
        title: 'The Story of Doctor Dolittle',
        stepsOut: 0,
        deepLink: 'https://www.gutenberg.org/ebooks/501',
        linkConfirmed: true,
      ),
      Book(
        id: 'voyages-of-doctor-dolittle',
        title: 'The Voyages of Doctor Dolittle',
        stepsOut: 1,
        deepLink: 'https://www.gutenberg.org/ebooks/1154',
        linkConfirmed: true,
      ),
      Book(
        id: 'doctor-dolittles-post-office',
        title: "Doctor Dolittle's Post Office",
        stepsOut: 2,
        deepLink: 'https://www.gutenberg.org/ebooks/58947',
        linkConfirmed: true,
      ),
      Book(
        id: 'doctor-dolittle-in-the-moon',
        title: 'Doctor Dolittle in the Moon',
        stepsOut: 3,
        deepLink: 'https://www.gutenberg.org/ebooks/73411',
        linkConfirmed: true,
      ),
    ],

    // A. A. Milne. The text and Shepard's drawings are free in the US; Disney's
    // Pooh (the red shirt, the look) is trademarked and stays out.
    'forest': [
      Book(
        id: 'winnie-the-pooh',
        title: 'Winnie-the-Pooh',
        stepsOut: 0,
        deepLink: 'https://www.gutenberg.org/ebooks/67098',
        linkConfirmed: true,
      ),
      Book(
        id: 'house-at-pooh-corner',
        title: 'The House at Pooh Corner',
        stepsOut: 1,
        deepLink: 'https://www.gutenberg.org/ebooks/73011',
        linkConfirmed: true,
      ),
      Book(
        id: 'now-we-are-six',
        title: 'Now We Are Six',
        stepsOut: 2,
        deepLink: 'https://www.gutenberg.org/ebooks/70516',
        linkConfirmed: true,
      ),
      Book(
        id: 'when-we-were-very-young',
        title: 'When We Were Very Young',
        stepsOut: 3,
        deepLink: 'https://www.gutenberg.org/ebooks/70271',
        linkConfirmed: true,
      ),
    ],

    // The shelf the demo first ran on, before the Cover offered the three
    // adventures above. Kept for the Epic pitch. Only Hilda and the Troll is confirmed
    // open — Amlan checked the rest and could not stand them up (a4f7416),
    // so they carry linkConfirmed: false and the ids stay for re-checking.
    // The whole series being on Epic is what makes the eight-week walk a
    // real journey, so the titles stay on the shelf either way.
    //
    // Hilda and the Troll reads in 15-30 minutes, which is the only book we
    // found that matches PLAN.md's "~20 minutes reading the actual chapter"
    // without us having to slice a chapter out of a three-hour novel. At
    // GN530L it is also the only one a struggling nine-year-old can read aloud.
    'creatures': [
      Book(
        id: 'hilda-troll',
        title: 'Hilda and the Troll',
        stepsOut: 0,
        deepLink: 'https://www.getepic.com/book/62843717/hilda-and-the-troll',
        linkConfirmed: true,
      ),
      Book(
        id: 'hilda-giant',
        title: 'Hilda and the Midnight Giant',
        stepsOut: 1,
        deepLink:
            'https://www.getepic.com/book/62845939/hilda-and-the-midnight-giant',
      ),
      Book(
        id: 'hilda-bird-parade',
        title: 'Hilda and the Bird Parade',
        stepsOut: 2,
        deepLink:
            'https://www.getepic.com/book/78842117/hilda-and-the-bird-parade',
      ),
      Book(
        id: 'hilda-black-hound',
        title: 'Hilda and the Black Hound',
        stepsOut: 3,
        deepLink:
            'https://www.getepic.com/book/78856560/hilda-and-the-black-hound',
      ),
      Book(
        id: 'hilda-stone-forest',
        title: 'Hilda and the Stone Forest',
        stepsOut: 4,
        deepLink:
            'https://www.getepic.com/book/78882113/hilda-and-the-stone-forest',
      ),
      Book(
        id: 'hilda-mountain-king',
        title: 'Hilda and the Mountain King',
        stepsOut: 5,
        deepLink:
            'https://www.getepic.com/book/84660424/hilda-and-the-mountain-king',
      ),
    ],

    // The fallback shelf, authored. Ids were checked once but not since
    // Amlan's pass, so nothing here claims to open until somebody looks.
    'funny': [
      Book(
        id: 'dog-man-1',
        title: 'Dog Man',
        stepsOut: 0,
        deepLink:
            'https://www.getepic.com/book/96427025/dog-man-a-graphic-novel-dog-man-1-from-the-creator-of-captain-underpants',
      ),
      Book(
        id: 'underpants-1',
        title: 'The Adventures of Captain Underpants',
        stepsOut: 1,
        deepLink:
            'https://www.getepic.com/book/96443690/the-adventures-of-captain-underpants-color-edition-captain-underpants-1',
      ),
      Book(
        id: 'underpants-2',
        title: 'Captain Underpants and the Attack of the Talking Toilets',
        stepsOut: 2,
        deepLink:
            'https://www.getepic.com/book/96429247/captain-underpants-and-the-attack-of-the-talking-toilets-color-edition-captain-underpants-2',
      ),
      // The furthest door, and the one that quietly makes the point: the man who
      // drew the others was the kid sent out of class for drawing comics.
      Book(
        id: 'dav-pilkey',
        title: 'Dav Pilkey',
        stepsOut: 3,
        deepLink: 'https://www.getepic.com/book/56769880/dav-pilkey',
      ),
    ],

    // NOT VERIFIED ON EPIC. Real books, real titles, but no getepic.com/book id
    // was findable for any of them and the publisher is the same house whose
    // Magic Tree House titles Epic sends people to Amazon for. The links below
    // are placeholders and WILL open nothing.
    //
    // Before this shelf goes anywhere near the stage: search Hamster Princess in
    // Epic while signed in, and paste the real ids in. If they aren't there,
    // present 'funny' and keep this in the drawer.
    'fractions': [
      Book(
        id: 'harriet-invincible',
        title: 'Hamster Princess: Harriet the Invincible',
        stepsOut: 0,
        deepLink: 'UNVERIFIED://harriet-invincible',
      ),
      Book(
        id: 'of-mice-and-magic',
        title: 'Hamster Princess: Of Mice and Magic',
        stepsOut: 1,
        deepLink: 'UNVERIFIED://of-mice-and-magic',
      ),
      Book(
        id: 'ratpunzel',
        title: 'Hamster Princess: Ratpunzel',
        stepsOut: 2,
        deepLink: 'UNVERIFIED://ratpunzel',
      ),
      Book(
        id: 'giant-trouble',
        title: 'Hamster Princess: Giant Trouble',
        stepsOut: 3,
        deepLink: 'UNVERIFIED://giant-trouble',
      ),
    ],
  };

  @override
  Future<List<Book>> doorsFor({
    required String interest,
    required int reach,
  }) async {
    final shelf = _shelf[interest.trim().toLowerCase()];
    if (shelf == null || shelf.isEmpty) {
      throw ArgumentError.value(interest, 'interest', 'nothing seeded for this');
    }

    final home = shelf.firstWhere((b) => b.isHomeGround, orElse: () => shelf.first);

    // Furthest first, so the doors actually travel outward as reach grows.
    // Taking the nearest two instead means she is never offered the far door
    // and the whole widening mechanic quietly stops working.
    final others = shelf
        .where((b) => !b.isHomeGround && b.stepsOut <= reach)
        .toList()
      ..sort((a, b) => b.stepsOut.compareTo(a.stepsOut));

    // If the shelf can't fill three within reach, allow exactly one stretch
    // door just beyond it rather than showing a short list.
    if (others.length < 2) {
      final stretch = shelf
          .where((b) => !b.isHomeGround && b.stepsOut > reach)
          .toList()
        ..sort((a, b) => a.stepsOut.compareTo(b.stepsOut));
      others.addAll(stretch.take(2 - others.length));
    }

    final doors = others.take(2).toList()
      ..sort((a, b) => a.stepsOut.compareTo(b.stepsOut));
    return [home, ...doors];
  }
}
