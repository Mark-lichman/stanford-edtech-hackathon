import 'package:flutter/material.dart';

import '../theme.dart';

/// One book choice. The screen owns the book model and navigation.
class Door extends StatelessWidget {
  const Door({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.cover,
  });

  final String title;
  final String? subtitle;
  final Widget? cover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: title,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 52,
                    height: 60,
                    child: cover ?? const _DoorCover(),
                  ),
                  const SizedBox(width: PrimerTheme.space4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(title, style: PrimerTheme.display.copyWith(fontSize: 24)),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(subtitle!, style: PrimerTheme.affordance),
                        ],
                      ],
                    ),
                  ),
                  const _DoorArrow(),
                ],
              ),
            ),
          ),
        ),
      );
}

class _DoorCover extends StatelessWidget {
  const _DoorCover();

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: PrimerTheme.berryPale,
          border: Border.all(color: PrimerTheme.berry, width: 1),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(5),
          ),
        ),
        child: const Center(child: _TinyBookMark()),
      );
}

class _TinyBookMark extends StatelessWidget {
  const _TinyBookMark();

  @override
  Widget build(BuildContext context) => CustomPaint(size: const Size(24, 28), painter: _BookMarkPainter());
}

class _BookMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = PrimerTheme.berry;
    canvas.drawOval(const Rect.fromLTWH(3, 7, 18, 15), p);
    canvas.drawCircle(const Offset(12, 8), 4, p);
    final ink = Paint()
      ..color = PrimerTheme.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawLine(const Offset(8, 9), const Offset(3, 2), ink);
    canvas.drawLine(const Offset(16, 9), const Offset(21, 2), ink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DoorArrow extends StatelessWidget {
  const _DoorArrow();

  @override
  Widget build(BuildContext context) => CustomPaint(size: const Size(22, 18), painter: _ArrowPainter());
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = PrimerTheme.inkSoft
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(2, 9), const Offset(19, 9), p);
    canvas.drawLine(const Offset(13, 3), const Offset(19, 9), p);
    canvas.drawLine(const Offset(13, 15), const Offset(19, 9), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
