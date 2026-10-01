/// The one mutable thing that carries across screens. Track A owns this file;
/// every other track reads it.
///
/// No provider, no store, no routing library. `setState` at the top of
/// [main.dart] and this object underneath it — for seven screens and one
/// evening that is the whole of the state management story.
library;

import 'book.dart';

class Run {
  /// Seeded lived-in on purpose (Track E): she has a name, the judge already
  /// has the name she gave him, and the field guide already has pages in it.
  /// The Cover must not look like the first thing that has ever happened —
  /// a demo that starts from empty reads as a demo.
  String childName = 'Maya';
  String judgeName = 'Grumble';

  /// Two nights already behind her. Pages, not a count: the guide is a thing
  /// she made, never a score.
  final List<String> fieldGuide = [
    'The dust creature under the radiator. It only comes out when the heating '
        'stops ticking.',
    'The green mark on the back of the third stair. It was there before we were.',
  ];

  Book? picked;
  bool artifactEarned = false;

  /// PLAN.md §11 — the small social element, the whole of it. One page in the
  /// guide is not hers: something an earlier explorer left behind, shown under
  /// her own artifact at Celebration.
  ///
  /// Hand-made and seeded for the showcase, and we say so on stage. A content
  /// swap, not a system — no accounts, no matching, no realtime, no moderation
  /// queue.
  ///
  /// The rule that keeps it safe in one move: the stories touch, the children
  /// don't. No names, no profiles, nothing a child wrote reaching another
  /// child. Anything that needs a moderation answer is out of scope by
  /// definition.
  // ponytail: one seeded page, not the pool of two or three §11 allows. Make it
  // a list and pick by fieldGuide.length if a second night ever gets demoed.
  static const leftBehind =
      'A map of the airing cupboard, drawn by someone who got there first. '
      'They put the shelves the wrong way round.';

  /// The answer in ink, under Grumble's pencil on his page. The research on
  /// externalizing a child's critic pairs every appearance of it with proof it
  /// was wrong, so this points at something she really did: the first page of
  /// her field guide. From a grown-up who knows her, never another child.
  ///
  /// Seeded for the showcase, like the page left behind, and we say so on
  /// stage. In the product her grown-up writes it; nothing she writes is sent.
  static const inkNote = (
    from: 'Dad',
    text: "He's wrong. You found the dust creature under the radiator two "
        'nights ago. I saw the page.',
  );

  /// Celebration calls this. Named rather than mutated in place so there is one
  /// spot to look when the guide is wrong on stage.
  void earn(String artifactPage) {
    artifactEarned = true;
    fieldGuide.add(artifactPage);
  }
}
