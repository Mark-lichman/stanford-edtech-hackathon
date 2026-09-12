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

  // One evening, one shelf. Every id and link below is a real Epic book — if a
  // door opens nothing on stage the pitch dies in the first ten seconds.
  //
  // Magic Tree House is deliberately absent: Epic's own recommendation pages
  // list it under "available on Amazon", not on Epic. Don't put it back without
  // a working getepic.com/book link.
  //
  // Only `underpants-1` is authored end to end. The rest are real titles that
  // make the three doors honest and give reach somewhere to widen to.
  static const _shelf = <String, List<Book>>{
    'funny': [
      Book(
        id: 'underpants-1',
        title: 'The Adventures of Captain Underpants',
        stepsOut: 0,
        deepLink:
            'https://www.getepic.com/book/96443690/the-adventures-of-captain-underpants-color-edition-captain-underpants-1',
      ),
      Book(
        id: 'underpants-2',
        title: 'Captain Underpants and the Attack of the Talking Toilets',
        stepsOut: 1,
        deepLink:
            'https://www.getepic.com/book/96429247/captain-underpants-and-the-attack-of-the-talking-toilets-color-edition-captain-underpants-2',
      ),
      Book(
        id: 'dog-man-1',
        title: 'Dog Man',
        stepsOut: 2,
        deepLink:
            'https://www.getepic.com/book/96427025/dog-man-a-graphic-novel-dog-man-1-from-the-creator-of-captain-underpants',
      ),
      // The furthest door, and the one that quietly makes the point: the man who
      // wrote the others was the kid sent out of class for drawing comics.
      Book(
        id: 'dav-pilkey',
        title: 'Dav Pilkey',
        stepsOut: 3,
        deepLink: 'https://www.getepic.com/book/56769880/dav-pilkey',
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
