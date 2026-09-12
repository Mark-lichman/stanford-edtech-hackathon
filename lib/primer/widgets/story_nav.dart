/// The presenter's nav. One pip per beat of the run, named the way the script
/// names them, a phone-view toggle, and a reset.
///
/// This is stage chrome, not part of the story — it exists so the driver can
/// jump to a beat mid-pitch, show the run at phone size, and put the demo back
/// to the start between run-throughs. Nothing here is child-facing, which is
/// why it is small and out of the way rather than 56dp and warm.
///
/// It lays itself out from its own width, not the screen's, so inside the phone
/// frame it is already the compact version with no second code path.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryNav extends StatelessWidget {
  const StoryNav({
    super.key,
    required this.beats,
    required this.step,
    required this.mobile,
    required this.onJump,
    required this.onReset,
    required this.onToggleMobile,
  });

  /// Beat names, in the order they are tapped. Index is the step.
  final List<String> beats;
  final int step;

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
          final compact = box.maxWidth < 560;
          return Padding(
            padding: EdgeInsets.fromLTRB(compact ? 6 : 18, 8, compact ? 2 : 10, 0),
            child: Row(
              children: [
                if (!compact)
                  Text(
                    'LANTERN',
                    style: GoogleFonts.baloo2(
                      fontSize: 12,
                      letterSpacing: 2.2,
                      fontWeight: FontWeight.w900,
                      color: _slate,
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: Wrap(
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
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onToggleMobile,
                  tooltip: mobile ? 'Full width' : 'Phone view',
                  color: mobile ? _ink : _soft,
                  isSelected: mobile,
                  icon: const Icon(Icons.smartphone_rounded, size: 20),
                  selectedIcon: const Icon(Icons.desktop_windows_rounded, size: 20),
                ),
                if (compact)
                  IconButton(
                    onPressed: onReset,
                    tooltip: 'Reset',
                    color: _ink,
                    icon: const Icon(Icons.restart_alt_rounded, size: 20),
                  )
                else
                  TextButton.icon(
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
                  ),
              ],
            ),
          );
        },
      );
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
    // Full: a 30 pip in a 44 target. Phone: 24 in 34, so eight of them, the
    // toggle and reset still fit across a 360-wide screen.
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
