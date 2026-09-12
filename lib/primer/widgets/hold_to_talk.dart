import 'package:flutter/material.dart';

import '../theme.dart';

/// A stateless press-and-hold seam. The screen owns recording state and audio.
class HoldToTalk extends StatelessWidget {
  const HoldToTalk({
    super.key,
    required this.onDone,
    this.onSkip,
    this.isHolding = false,
    this.label = 'Hold to talk',
    this.activeLabel = 'Listening...',
    this.skipLabel = 'I\'d rather not talk tonight',
    this.level = 0,
  });

  final VoidCallback onDone;
  final VoidCallback? onSkip;
  final bool isHolding;
  final String label;
  final String activeLabel;
  final String skipLabel;
  final double level;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          GestureDetector(
            onLongPress: onDone,
            child: Semantics(
              button: true,
              label: isHolding ? activeLabel : label,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 176,
                height: 176,
                decoration: BoxDecoration(
                  color: isHolding ? PrimerTheme.lamp : PrimerTheme.lampPale,
                  shape: BoxShape.circle,
                  border: Border.all(color: PrimerTheme.lamp, width: 2),
                ),
                child: CustomPaint(
                  painter: _TalkMarkPainter(active: isHolding),
                  child: Center(
                    child: Text(
                      isHolding ? activeLabel : label,
                      style: PrimerTheme.affordance.copyWith(color: PrimerTheme.ink),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: PrimerTheme.space4),
          _LevelMark(value: level),
          if (onSkip != null) ...[
            const SizedBox(height: PrimerTheme.space5),
            Semantics(
              button: true,
              label: skipLabel,
              child: TextButton(
                onPressed: onSkip,
                child: Text(
                  skipLabel,
                  style: PrimerTheme.affordance.copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ],
      );
}

class _LevelMark extends StatelessWidget {
  const _LevelMark({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Gentle listening level',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 5; i++)
              Container(
                width: 5,
                height: 9 + (i * 3),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: i < (value.clamp(0, 1) * 5).ceil()
                      ? PrimerTheme.berry
                      : PrimerTheme.field,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      );
}

class _TalkMarkPainter extends CustomPainter {
  const _TalkMarkPainter({required this.active});
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = active ? PrimerTheme.berry : PrimerTheme.inkSoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromLTWH(size.width / 2 - 16, size.height / 2 - 34, 32, 54), 0, mathPi, false, p);
    canvas.drawLine(Offset(size.width / 2 - 10, size.height / 2 - 7), Offset(size.width / 2 + 10, size.height / 2 - 7), p);
  }

  @override
  bool shouldRepaint(covariant _TalkMarkPainter oldDelegate) => oldDelegate.active != active;
}

const mathPi = 3.141592653589793;
