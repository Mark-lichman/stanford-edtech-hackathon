import 'package:flutter/material.dart';

import 'primer/run.dart';
import 'primer/widgets/widgets.dart';

void main() => runApp(const PrimerApp());

class PrimerApp extends StatelessWidget {
  const PrimerApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'The Primer',
        debugShowCheckedModeBanner: false,
        home: Beats(),
      );
}

/// The seven beats, in the order they are tapped. Track B replaces each
/// placeholder with its screen, one file at a time; nothing else here moves.
class Beats extends StatefulWidget {
  const Beats({super.key});

  @override
  State<Beats> createState() => _BeatsState();
}

class _BeatsState extends State<Beats> {
  final _run = Run();
  final _page = PageController();

  static const _beats = [
    'cover',
    'doors',
    'way in',
    'the return',
    'celebration',
    'the intercept',
    'the dark',
  ];

  static final _dark = _beats.length - 1;

  void _next() => _page.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

  /// Track E: The Dark on demand. A long press anywhere jumps straight to it,
  /// so it can be hit mid-pitch without a visible control on stage.
  void _toTheDark() => _page.jumpToPage(_dark);

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _next,
        onLongPress: _toTheDark,
        child: Scaffold(
          body: PageView(
            controller: _page,
            // The presenter taps forward. A stray swipe must not be able to
            // skip a beat or reveal the next one early.
            physics: const NeverScrollableScrollPhysics(),
            children: [for (final beat in _beats) _Placeholder(beat, _run)],
          ),
        ),
      );
}

/// Ugly on purpose, and gone by tonight. It shows the beat name so Track B
/// knows which file replaces it, and the seeded run so Track E's seed is
/// visible before the screens exist.
class _Placeholder extends StatelessWidget {
  const _Placeholder(this.beat, this.run);

  final String beat;
  final Run run;

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(beat, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 16),
        Text('${run.childName} · ${run.judgeName}'),
        Text('field guide: ${run.fieldGuide.length} pages'),
      ],
    );
    return beat == 'the dark' ? DarkPanel(child: body) : BookPage(child: body);
  }
}
