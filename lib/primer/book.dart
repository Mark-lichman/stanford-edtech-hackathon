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

  /// True while we only have a search fallback rather than a real Epic id.
  /// Show it, but never claim on stage that the link opens the book.
  bool get hasConfirmedLink => id != needsId;
}

/// Placeholder id for a book whose Epic id nobody has looked up yet.
const needsId = 'needs-epic-id';

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

  /// The Hilda books, by Luke Pearson. Real series, real order, on Epic.
  ///
  /// Only the first id is confirmed against a live Epic URL. The rest are
  /// marked [needsId] so nobody demos a dead link by accident — Amlan fills
  /// them in, or we open book one and talk over the rest.
  static const _shelf = <String, List<Book>>{
    'creatures': [
      Book(
        id: '62843717',
        title: 'Hilda and the Troll',
        stepsOut: 0,
        deepLink: 'https://www.getepic.com/book/62843717/hilda-and-the-troll',
      ),
      Book(
        id: needsId,
        title: 'Hilda and the Midnight Giant',
        stepsOut: 1,
        deepLink: 'https://www.getepic.com/search?q=Hilda+and+the+Midnight+Giant',
      ),
      Book(
        id: needsId,
        title: 'Hilda and the Bird Parade',
        stepsOut: 2,
        deepLink: 'https://www.getepic.com/search?q=Hilda+and+the+Bird+Parade',
      ),
      Book(
        id: needsId,
        title: 'Hilda and the Mountain King',
        stepsOut: 3,
        deepLink: 'https://www.getepic.com/search?q=Hilda+and+the+Mountain+King',
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
