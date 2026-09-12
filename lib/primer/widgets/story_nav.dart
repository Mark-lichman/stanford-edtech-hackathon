/// The presenter's nav. One pip per beat of the run, named the way the script
/// names them, a phone-view toggle, and a reset.
///
/// This is stage chrome, not part of the story — it exists so the driver can
/// jump to a beat mid-pitch, show the run at phone size, and put the demo back
/// to the start between run-throughs. Nothing here is child-facing, which is
/// why it is small and out of the way rather than 56dp and warm.
///
/// It is labelled as prototype controls and always drawn outside the phone
/// frame, on its own strip, so nobody in the room reads it as the app. It lays
/// itself out from its own width: on a narrow screen the label, the pips, and
/// the day, view toggle and reset each take their own row.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryNav extends StatelessWidget {
  const StoryNav({
    super.key,
    required this.beats,
    required this.step,
    required this.day,
    required this.mobile,
    required this.onJump,
    required this.onDay,
    required this.onReset,
    required this.onToggleMobile,
  });

  /// Beat names, in the order they are tapped. Index is the step.
  final List<String> beats;
  final int step;

  /// Which day of the eight weeks the run is showing. The stepper clamps it to
  /// [maxDay]; the story decides what the day changes.
  final int day;
  final ValueChanged<int> onDay;
  static const maxDay = 56;

  /// Whether the story is currently shown in the phone frame.
  final bool mobile;
  final ValueChanged<int> onJump;
  final VoidCallback onReset;
  final VoidCallback onToggleMobile;

  static const _ink = Color(0xFF3A2E1F);
  static const _edge = Color(0xFFD9C295);
  static const _marigold = Color(0xFFE09612);
  static const _slate = Color(0xFF3D6170);
  static const _soft = Color(0xFF7C6D5C);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, box) {
          // Below this, label + day + nine pips + toggle + reset stop fitting on
          // one line and the pips would wrap into a tower; stack rows instead.
          final compact = box.maxWidth < 900;

          final label = Text(
            'PROTOTYPE CONTROLS',
            style: GoogleFonts.baloo2(
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.w900,
              color: _slate,
            ),
          );

          final pips = Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (var i = 0; i < beats.length; i++)
                _Pip(
                  n: i + 1,
                  label: beats[i],
                  current: i == step,
                  compact: compact,
                  onTap: () => onJump(i),
                ),
            ],
          );

          final days = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: day > 1 ? () => onDay(day - 1) : null,
                tooltip: 'Previous day',
                color: _ink,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.remove_rounded, size: 18),
              ),
              Semantics(
                label: 'Day $day of $maxDay',
                excludeSemantics: true,
                child: SizedBox(
                  width: 58,
                  child: Text(
                    'Day $day',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.baloo2(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: day < maxDay ? () => onDay(day + 1) : null,
                tooltip: 'Next day',
                color: _ink,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.add_rounded, size: 18),
              ),
            ],
          );

          final toggle = IconButton(
            onPressed: onToggleMobile,
            tooltip: mobile ? 'Full width' : 'Phone view',
            color: mobile ? _ink : _soft,
            isSelected: mobile,
            icon: const Icon(Icons.smartphone_rounded, size: 20),
            selectedIcon: const Icon(Icons.desktop_windows_rounded, size: 20),
          );

          final reset = compact
              ? IconButton(
                  onPressed: onReset,
                  tooltip: 'Reset',
                  color: _ink,
                  icon: const Icon(Icons.restart_alt_rounded, size: 20),
                )
              : TextButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.restart_alt_rounded, size: 17),
                  label: const Text('Reset'),
                  style: TextButton.styleFrom(
                    foregroundColor: _ink,
                    textStyle: GoogleFonts.baloo2(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                );

          // Its own strip and rule, a different ground from any page.
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: _strip,
              border: Border(bottom: BorderSide(color: _edge, width: 1.4)),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(compact ? 6 : 18, 6, compact ? 2 : 10, 6),
              child: compact
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        label,
                        pips,
                        Row(children: [days, const Spacer(), toggle, reset]),
                      ],
                    )
                  : Row(
                      children: [
                        label,
                        const SizedBox(width: 12),
                        days,
                        Expanded(child: Center(child: pips)),
                        toggle,
                        reset,
                      ],
                    ),
            ),
          );
        },
      );

  static const _strip = Color(0xFFE7D5B8);
}

class _Pip extends StatelessWidget {
  const _Pip({
    required this.n,
    required this.label,
    required this.current,
    required this.compact,
    required this.onTap,
  });

  final int n;
  final String label;
  final bool current;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Full: a 30 pip in a 44 target. Phone: 24 in 34, so all nine fit on their
    // own row across a 360-wide screen.
    final hit = compact ? 34.0 : 44.0;
    final pip = compact ? 24.0 : 30.0;

    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        selected: current,
        label: 'Beat $n, $label',
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: hit,
            height: hit,
            child: Center(
              child: Container(
                width: pip,
                height: pip,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: current ? StoryNav._marigold : null,
                  border: Border.all(
                    color: current ? StoryNav._ink : StoryNav._edge,
                    width: current ? 2 : 1.4,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$n',
                    style: GoogleFonts.baloo2(
                      fontSize: compact ? 11 : 13,
                      fontWeight: FontWeight.w800,
                      color: current ? StoryNav._ink : StoryNav._soft,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
