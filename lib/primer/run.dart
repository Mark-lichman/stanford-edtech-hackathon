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

  /// Celebration calls this. Named rather than mutated in place so there is one
  /// spot to look when the guide is wrong on stage.
  void earn(String artifactPage) {
    artifactEarned = true;
    fieldGuide.add(artifactPage);
  }
}
