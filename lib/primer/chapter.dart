/// The chapter she listens to and then reads from: plain text in
/// assets/chapters, one file per book, cleaned from Project Gutenberg. The
/// first line is the chapter's title, then paragraphs split by blank lines.
library;

import 'package:flutter/services.dart';

class Chapter {
  const Chapter({required this.title, required this.paragraphs});

  final String title;
  final List<String> paragraphs;

  static final _cache = <String, Future<Chapter?>>{};
  static final _loaded = <String, Chapter?>{};

  /// Null when Lantern has no text for this book (the Epic shelves), and the
  /// page says so rather than showing an empty reader.
  static Future<Chapter?> load(String bookId) => _cache[bookId] ??= () async {
        Chapter? c;
        try {
          c = parse(await rootBundle.loadString('assets/chapters/$bookId.txt'));
        } catch (_) {}
        return _loaded[bookId] = c;
      }();

  /// Whether [bookId] has finished loading, and if so its chapter (which may be
  /// null). Lets a page draw a loaded chapter at once instead of waiting a
  /// frame on a future that has already finished.
  static (bool, Chapter?) loaded(String bookId) => (_loaded.containsKey(bookId), _loaded[bookId]);

  static Chapter parse(String raw) {
    final blocks = raw.replaceAll('\r', '').split(RegExp(r'\n\s*\n'));
    return Chapter(
      title: blocks.first.trim(),
      paragraphs: [for (final b in blocks.skip(1)) if (b.trim().isNotEmpty) b.trim()],
    );
  }

  /// The paragraph holding [phrase], or the first one when it can't be found:
  /// a chapter that opens at the top is better than one that doesn't open.
  int paragraphWith(String? phrase) {
    if (phrase == null) return 0;
    final i = paragraphs.indexWhere((p) => p.contains(phrase));
    return i < 0 ? 0 : i;
  }

  /// Sentences of one paragraph, each keeping its own closing punctuation and
  /// quote marks, so tapping one selects exactly what she would read.
  static List<String> sentences(String paragraph) => [
        for (final m in RegExp(r'[^.!?\n]+[.!?]+["”’)]*|[^.!?\n]+$', multiLine: true).allMatches(paragraph))
          if (m.group(0)!.trim().isNotEmpty) m.group(0)!.trim(),
      ];
}
