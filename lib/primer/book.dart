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
    this.coverUrl,
  });

  final String id;
  final String title;

  /// Distance from the child's home ground. 0 is something she already loves.
  final int stepsOut;

  /// Where tapping the door sends her. For Epic this is
  /// `https://www.getepic.com/book/{id}`; for a seeded book it may be a stub.
  final String deepLink;

  final String? coverUrl;

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
    // VERIFIED, and the shelf the demo runs on. Whole series is in Epic, so the
    // reach widening is a real journey through real books rather than a trick.
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

    // VERIFIED. The fallback shelf, authored and working.
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
