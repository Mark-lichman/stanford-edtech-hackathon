import 'package:flutter/material.dart';

import '../theme.dart';

/// A piece of paper, not a card. Screens own the page's content and state.
class BookPage extends StatelessWidget {
  const BookPage({
    super.key,
    required this.child,
    this.onReadAloud,
    this.readAloudLabel = 'Read this page aloud',
    this.tone = PageTone.paper,
    this.padding = const EdgeInsets.fromLTRB(32, 32, 32, 36),
  });

  final Widget child;
  final VoidCallback? onReadAloud;
  final String readAloudLabel;
  final PageTone tone;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final pageColor = tone == PageTone.celebration
        ? PrimerTheme.lampPale
        : PrimerTheme.paperLight;

    return Semantics(
      label: 'Story page',
      child: CustomPaint(
        painter: _PageBorderPainter(),
        child: Container(
          color: pageColor,
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              child,
              if (onReadAloud != null) ...[
                const SizedBox(height: PrimerTheme.space6),
                Semantics(
                  button: true,
                  label: readAloudLabel,
                  child: InkWell(
                    onTap: onReadAloud,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _InkSoundMark(),
                          const SizedBox(width: 10),
                          Text(readAloudLabel, style: PrimerTheme.affordance),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Short alias for screens that prefer the story vocabulary.
class Page extends BookPage {
  const Page({
    super.key,
    required super.child,
    super.onReadAloud,
    super.readAloudLabel,
    super.tone,
    super.padding,
  });
}

enum PageTone { paper, celebration }

/// Large story copy with the read-aloud behavior at the text boundary.
class PageText extends StatelessWidget {
  const PageText({super.key, required this.text, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: onTap != null,
        label: onTap == null ? text : 'Read aloud: $text',
        child: InkWell(
          onTap: onTap,
          child: Text(text, style: PrimerTheme.story),
        ),
      );
}

class _InkSoundMark extends StatelessWidget {
  const _InkSoundMark();

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: const Size(24, 22),
        painter: _SoundMarkPainter(),
      );
}

class _SoundMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final ink = Paint()
      ..color = PrimerTheme.berry
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(3, 10), const Offset(8, 10), ink);
    canvas.drawLine(const Offset(11, 6), const Offset(11, 14), ink);
    canvas.drawArc(const Rect.fromLTWH(12, 5, 9, 12), -mathPi / 2, mathPi, false, ink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

const mathPi = 3.141592653589793;

class _PageBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PrimerTheme.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(12, 3)
      ..quadraticBezierTo(size.width * .25, -1, size.width * .5, 3)
      ..quadraticBezierTo(size.width * .78, 0, size.width - 12, 4)
      ..quadraticBezierTo(size.width + 1, size.height * .28, size.width - 5, size.height * .52)
      ..quadraticBezierTo(size.width + 1, size.height * .76, size.width - 11, size.height - 4)
      ..quadraticBezierTo(size.width * .7, size.height + 1, size.width * .45, size.height - 3)
      ..quadraticBezierTo(size.width * .2, size.height + 1, 10, size.height - 5)
      ..quadraticBezierTo(3, size.height * .7, 8, size.height * .48)
      ..quadraticBezierTo(3, size.height * .2, 12, 3);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
